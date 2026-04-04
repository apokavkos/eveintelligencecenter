#!/usr/bin/expect -f
set timeout 120
set password "N0tallwh0wanderarel0st!1"
set src_dir "/Users/apok/Documents/Antigravity/apokavkos.com/authelia-deploy"

# 1. Create remote dir
spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "mkdir -p /opt/authelia/config"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {}
}

# 2. SCP files
spawn scp -o StrictHostKeyChecking=no $src_dir/docker-compose.yml root@apokavkos.com:/opt/authelia/
expect { "*assword: " { send "$password\r"; exp_continue } eof {} }

spawn scp -o StrictHostKeyChecking=no $src_dir/config/configuration.yml $src_dir/config/users_database.yml root@apokavkos.com:/opt/authelia/config/
expect { "*assword: " { send "$password\r"; exp_continue } eof {} }

# 3. Docker Compose Build & Up
spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "cd /opt/authelia && docker compose up -d"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Authelia Deployment complete."
    }
}
