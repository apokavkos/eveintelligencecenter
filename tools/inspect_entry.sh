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

spawn ssh -o StrictHostKeyChecking=no $ssh_target "grep -i -A 10 'entrypoints' /opt/seat-docker/docker-compose.traefik.yml"
expect {
    "*assword: " {
        send "$password\r"
        exp_continue
    }
    eof {
    }
}
