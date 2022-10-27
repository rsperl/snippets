#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Create a link named json2yml and yml2json to this file.
If invoked as json2yml, it will convert json file to yml.
If invoked as yml2json, it will convert yml file to json.
"""
import sys
import json
import atexit

import yaml


program = sys.argv[0]

if len(sys.argv) == 1:
    sys.exit("Usage: {} file.json [file.yml]".format(program))

infile = sys.argv[1]
if len(sys.argv) == 3:
    outfile = open(sys.argv[2], "w")
else:
    outfile = sys.stdout

atexit.register(outfile.close)

with open(infile, "r") as fh:
    s = fh.read()
    if "json2yml" in program:
        outfile.write(yaml.safe_dump(json.loads(s)))
    elif "yml2json" in program:
        outfile.write(json.dumps(yaml.load(s), indent=2))
    else:
        sys.exit("must be invoked as json2yml or yml2json")
