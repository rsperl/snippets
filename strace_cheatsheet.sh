# Track child process
strace -f -p $(pidof glusterfsd)

# Track process after 30 seconds
timeout 30 strace $(< /var/run/zabbix/zabbix_agentd.pid)

# Track child process and redirect output to a file
ps auxw | grep 'sbin/[a]pache' | awk '{print " -p " $2}' | xargs strace -o /tmp/strace-apache-proc.out

# Track the open request of a network port
strace -f -e trace=bind nc -l 80

# Track the open request of a network port (show TCP/UDP)
strace -f -e trace=network nc -lu 80
