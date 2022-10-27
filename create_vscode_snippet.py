#!/usr/bin/env python3

import json
import os
import sys
from collections import OrderedDict

if len(sys.argv) != 4:
    sys.exit(f"Usage: {sys.argv[0]} <name> <prefix> <path-to-body-file>")

name, prefix, body_file = sys.argv[1], sys.argv[2], sys.argv[3]

if not os.path.isfile(body_file):
    sys.exit("body file not found: " + body_file)

with open(body_file, "r") as fh:
    print(
        '"'
        + name
        + '": '
        + json.dumps(OrderedDict(prefix=prefix, body=fh.readlines()), indent=4)
    )
