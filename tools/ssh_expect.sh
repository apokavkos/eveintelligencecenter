#!/usr/bin/expect -f

set timeout 20
set password "N0tallwh0wanderarel0st!1"

spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "docker ps -a && echo '==== DF ====' && df -h && echo '==== FREE ====' && free -m && echo '==== UNAME ====' && uname -a && echo '==== DOCKER NETWORK ====' && docker network ls && echo '==== DONE ===='"

expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    "==== DONE ====" {
        puts "Finished gathering data."
    }
    eof {
        puts "EOF reached."
    }
}
