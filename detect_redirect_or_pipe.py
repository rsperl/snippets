#!/usr/bin/env python3

import sys

if sys.stdout.isatty():
    print("Not redirected or piped")
else:
    print("Redirected or piped somewhere")
