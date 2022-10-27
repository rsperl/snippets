#!/usr/bin/env python3

import subprocess

date = subprocess.Popen(["date", "+%c"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
(out, err) = date.communicate()
print("stdout:    {}".format(out))
print("stderr:    {}".format(err))
print("exit code: {}".format(date.returncode))
