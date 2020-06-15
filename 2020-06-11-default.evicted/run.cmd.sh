#!/usr/bin/expect

set host [lindex $argv 0]

eval spawn ssh -oStrictHostKeyChecking=no -oCheckHostIP=no azureuser@${host}

expect "^\$"
send "sudo -s\r\r\r"

expect "#"
send "/tmp/cmd\r\r\r"

expect "#"
send "exit\r\r\r"

expect "#"
send "exit\r\r\r"

expect eof
