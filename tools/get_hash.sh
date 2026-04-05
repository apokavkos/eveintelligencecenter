#!/usr/bin/expect -f

set timeout 20

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

if {[info exists env(RAW_PASS)]} {
    set raw_pass $env(RAW_PASS)
} else {
    send_user "Password to hash: "
    expect_user -re "(.*)\n"
    set raw_pass $expect_out(1,string)
}

spawn ssh -o StrictHostKeyChecking=no $ssh_target "apt-get update && apt-get install -y apache2-utils && htpasswd -nb gemini $raw_pass"

expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
    }
}
