#!/usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import datetime
import shutil

origfile = "myfile.txt"
backupfile = origfile + "." + datetime.now().strftime("%Y-%m-%d_%H%M%S")

shutil.copy(origfile, backupfile)
