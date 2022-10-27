#!/usr/bin/env python
# -*- coding: utf-8 -*-
import time
import os
from pid import PidFile, PidFileAlreadyLockedError

lockdir = "/tmp/"
filename = "mylockfile"
lockfile = os.path.join(lockdir, filename + ".pid")

try:
    with PidFile(piddir=lockdir, pidname=filename) as p:
        print("got a pidfile {}".format(p))
        print("filename:  {}".format(p.filename))
        print("pid:      {}".format(p.pid))
        time.sleep(30)
except PidFileAlreadyLockedError as e:
    with open (lockfile, "r") as fh:
        pid = fh.read().strip()
        print("Script is already running: {}".format(pid))
