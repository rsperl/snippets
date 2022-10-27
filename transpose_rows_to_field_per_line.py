#!/usr/bin/env python
import os
import re
import sys
import atexit

# usage: 
#    rows2columns.py data.tab
#    or
#    cat data.tab | rows2columns.py


if len(sys.argv) > 1:
    if not os.path.exists(sys.argv[1]):
        print("could not find file '{}'".format(sys.argv[1]))
        sys.exit(1)
    inf = open(sys.argv[1])
    atexit.register(inf.close)
else:
    inf = sys.stdin

# get headers and find the longest one to determine format string
headers = re.split(r"\t", inf.readline().strip())
max_header_length = 0
for i in headers:
    if len(i) > max_header_length:
        max_header_length = len(i)
max_header_length += 2
fmtstr = "{:" + str(max_header_length) + "} {}"

# print one field per line with a blank line between records
for line in inf:
    values = re.split(r"\t", line.strip())
    if len(values) != len(headers):
        continue
    for i in range(0, len(headers)):
        print(fmtstr.format(headers[i] + ":", values[i]))
    print("")
