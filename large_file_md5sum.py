#!/usr/bin/env python3

import digest
import hashlib


f = open(filepath)
digest = hashlib.md5()
while True:
    buf = f.read(4096)
    if buf == "":
        break
    digest.update(buf)
f.close()
print(digest.hexdigest())
