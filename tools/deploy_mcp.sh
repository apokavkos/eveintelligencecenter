#!/usr/bin/expect -f

set timeout 120
set password "N0tallwh0wanderarel0st!1"
set src_dir "/Users/apok/Documents/Antigravity/apokavkos.com/evemcp-deploy"

# 1. Create the remote directory
spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "mkdir -p /opt/eve-mcp-server"
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
spawn scp -o StrictHostKeyChecking=no $src_dir/docker-compose.yml $src_dir/Dockerfile $src_dir/server.py root@apokavkos.com:/opt/eve-mcp-server/
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
spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "cd /opt/eve-mcp-server && docker compose build && docker compose up -d"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Deployment complete."
    }
}
