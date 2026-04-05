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

if {[info exists env(AUTHELIA_SRC_DIR)]} {
    set src_dir $env(AUTHELIA_SRC_DIR)
} else {
    set script_dir [file dirname [file normalize [info script]]]
    set src_dir [file normalize "$script_dir/../infrastructure/authelia"]
}

# 1. Create remote dir
spawn ssh -o StrictHostKeyChecking=no $ssh_target "mkdir -p /opt/authelia/config"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {}
}

# 2. SCP files
spawn scp -o StrictHostKeyChecking=no $src_dir/docker-compose.yml $ssh_target:/opt/authelia/
expect { "*assword: " { send "$password\r"; exp_continue } eof {} }

spawn scp -o StrictHostKeyChecking=no $src_dir/config/configuration.yml $src_dir/config/users_database.yml $ssh_target:/opt/authelia/config/
expect { "*assword: " { send "$password\r"; exp_continue } eof {} }

# 3. Docker Compose Build & Up
spawn ssh -o StrictHostKeyChecking=no $ssh_target "cd /opt/authelia && docker compose up -d"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Authelia Deployment complete."
    }
}
