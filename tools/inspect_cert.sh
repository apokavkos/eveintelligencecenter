#!/usr/bin/expect -f
set timeout 20
set password "N0tallwh0wanderarel0st!1"
spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "docker inspect seat-docker-traefik-1 | grep -i cert"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
    }
}
