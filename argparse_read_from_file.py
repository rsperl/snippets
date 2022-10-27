#!/usr/bin/env python3

import argparse


def parseargs():
    """parses CLI args"""
    parser = argparse.ArgumentParser()
    parser.add_argument("--username")
    # ...

    args = parser.parse_args()
    # if an arg value begins with @ and it is the path to a file,
    # replace the arg value with the contents of the file
    argkeys = args.__dict__.keys()
    for option in argkeys:
        value = args.__dict__.get(option, "")
        if type(value) == str and value[0] == "@" and os.path.isfile(value[1:]):
            with open(value[1:], "r") as fh:
                args.__dict__[option] = fh.read().strip()

    return args
