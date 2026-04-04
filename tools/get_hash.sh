#!/usr/bin/expect -f

set timeout 20
set password "N0tallwh0wanderarel0st!1"
set raw_pass "NhLerJ671xjLkDGpku4obg"

spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "apt-get update && apt-get install -y apache2-utils && htpasswd -nb gemini $raw_pass"

expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
    }
}
