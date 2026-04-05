#!/usr/bin/expect -f

set timeout 120

if {[info exists env(SSH_PASSWORD)]} {
    set password $env(SSH_PASSWORD)
} else {
    stty -echo
    send_user "SSH password: "
    expect_user -re "(.*)\n"
    stty echo
    send_user "\n"
    set password $expect_out(1,string)
}

if {[info exists env(SSH_TARGET)]} {
    set ssh_target $env(SSH_TARGET)
} else {
    set ssh_target "root@apokavkos.com"
}

if {[info exists env(MCP_SRC_DIR)]} {
    set src_dir $env(MCP_SRC_DIR)
} else {
    set script_dir [file dirname [file normalize [info script]]]
    set src_dir [file normalize "$script_dir/../infrastructure/eve-mcp-server"]
}

# 1. Create the remote directory
spawn ssh -o StrictHostKeyChecking=no $ssh_target "mkdir -p /opt/eve-mcp-server"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Directory created."
    }
}

# 2. SCP the files
spawn scp -o StrictHostKeyChecking=no $src_dir/docker-compose.yml $src_dir/Dockerfile $src_dir/server.py $src_dir/.env $ssh_target:/opt/eve-mcp-server/
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Files copied."
    }
}

# 3. Docker Compose Up
spawn ssh -o StrictHostKeyChecking=no $ssh_target "cd /opt/eve-mcp-server && docker compose build && docker compose up -d"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Deployment complete."
    }
}
