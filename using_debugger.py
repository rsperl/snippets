#!/usr/bin/env python
import pdb
import sys
import traceback


def main():
    # some WIP code that maybe raises an exception
    raise BaseException("oh no, exception!")
    return 0


if __name__ == "__main__":
    try:
        ret = main()
    except:
        traceback.print_exc()
        pdb.post_mortem()
    sys.exit(ret)
