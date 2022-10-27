#!/usr/bin/env python3

import os, sys

if os.geteuid() != 0:
    print("You must be root to run this script")
    sys.exit(0)
