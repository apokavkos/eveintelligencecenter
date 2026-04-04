#!/bin/usr/expect -f
set timeout 60
set password "N0tallwh0wanderarel0st!1"

spawn ssh -o StrictHostKeyChecking=no root@apokavkos.com "docker run --rm node:18 npm search mcp-server-mysql"

expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "Search complete."
    }
}
