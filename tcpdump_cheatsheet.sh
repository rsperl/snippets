#!/bin/bash

# -n don't resolve IP
# -l buffer by line (show output without buffering)
# -v slightly verbose

# show connections to remote port 3306
# shows when connections are made to a database
tcpdump -nlv port 3306

# -p don't put the interface in promiscuous mode
# -q slightly quieter output

# shows connections with local ephemeral ports
# useful for identifying unique connections
tcpdump -nlpq port 3306