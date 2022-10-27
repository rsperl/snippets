#
# copy a string across the network
#
# start netcat listening on dest host:
nc -l 1234 | pbcopy

# send string to dest host via netcat:
echo $STR | nc 192.168.0.123 1234

#####################################################################################################################

#
# check if a upd port is open with netcat
#
nc -v -u -z -w 3 localhost 5000

# send a test packet
#  -n - Tells the echo command to not output the trailing newline.
#  -4u Use IPV4 addresses only.  Use UDP instead of TCP.
#  -w1 Silently close the session after 1 second of idle time.  That way, we’re not stuck waiting for more data.
echo -n “foo” | nc -4u -w1 <host> <udp port>

#####################################################################################################################