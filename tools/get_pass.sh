#!/usr/bin/expect -f

set timeout 20
set password "N0tallwh0wanderarel0st!1"

spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "cat /opt/seat-docker/.env | grep DB_PASSWORD"

expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
    }
}
