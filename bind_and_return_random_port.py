#!/usr/bin/env python3

import socket

s = socket.socket(socket.AF_INET, type=socket.SOCK_STREAM)
s.bind(("localhost", 0))
address, port = s.getsockname()
print("Bound to {} on port {}".format(address, port))
s.close()
