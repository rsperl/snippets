#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import signal
import os
import sys

from datetime import datetime


def _handle_sigint(sig, frame):
    print(f"sig={sig}")
    print(f"frame={frame}")
    filename = frame.f_code.co_filename
    lineno = frame.f_lineno
    print(f"exiting from CTRL-c at {filename}:{lineno} with signal {sig >> 8}")
    sys.exit(0)


if __name__ == "__main__":
    signal.signal(signal.SIGINT, _handle_sigint)
    print(f"calling sigint on PID {os.getpid()}")
    os.kill(os.getpid(), signal.SIGINT)
