#!/usr/bin/env python3

"""
Find the differences between two mysql databases.
"""

from __future__ import print_function
import os
import re
import sys
from warnings import filterwarnings
from datetime import datetime
import argparse
import logging
from termcolor import colored
import logging.config
from StringIO import StringIO
from sqlalchemy import create_engine
from sqlalchemy.engine.url import make_url

# Used to create a separator (determined automatically)
TERMINALWIDTH = 0

# Turns color on/off (via --nocolor)
NOCOLOR = False
ISATTY = True

# don't care about sqlalchemy deprecation warnings
filterwarnings('ignore', category=Warning)
def get_sep(char="-"):
    """Creates a separator the width of the terminal"""
    global TERMINALWIDTH
    if TERMINALWIDTH == 0:
        rows, TERMINALWIDTH = os.popen("stty size", "r").read().split()
    sep = "".ljust(int(TERMINALWIDTH) - 10, char) + "\n"
    if NOCOLOR:
        return sep
    return colored(sep, "white", attrs=['bold'])


def parse_args():
    """Parse user args"""
    parser = argparse.ArgumentParser(description="Find mysql database differences")
    parser.add_argument("--srcuri", required=True, help="src database uri")
    parser.add_argument("--desturi", required=True, help="dest database uri")
    parser.add_argument("--nocolor", action="store_true", help="disable colorized output (on automatically if output is redirected")
    return parser.parse_args()


def get_diff_tables(srcuri, desturi):
    """Determine which tables are in which databases"""
    s = "select table_name from information_schema.tables where table_schema=%s"
    dbname = make_url(srcuri).database
    srcdb = create_engine(srcuri)
    destdb = create_engine(desturi)

    insrc = {}
    indest = {}
    inboth = []
    srconly = []
    destonly = []
    for r in srcdb.engine.execute(s, (dbname)):
        insrc[r['table_name']] = True
    for r in destdb.engine.execute(s, (dbname)):
        indest[r['table_name']] = True
        if insrc.get(r['table_name'], False):
            inboth.append(r['table_name'])
        else:
            destonly[r['table_name']] = True
    for t in insrc:
        if t not in indest:
            srconly.append(t)

    return dict(srconly=srconly, destonly=destonly, both=inboth)


def get_diff_columns(srcuri, desturi, table):
    """Find the differences between columns in a table of two databases"""
    s = "select * from information_schema.COLUMNS where TABLE_SCHEMA=%s and TABLE_NAME=%s"
    dbname = make_url(srcuri).database
    srcdb = create_engine(srcuri)
    destdb = create_engine(desturi)

    insrc = dict()
    indest = dict()
    srconly = []
    destonly = []
    inboth = []

    for r in srcdb.engine.execute(s, dbname, table):
        insrc[r['COLUMN_NAME']] = r
    for r in destdb.engine.execute(s, dbname, table):
        cname = r['COLUMN_NAME']
        indest[cname] = r
        if cname not in insrc:
            destonly.append(cname)
        else:
            inboth.append(cname)
    for c in insrc:
        if c not in indest:
            srconly.append(c)

    diffdata = dict()
    for c in inboth:
        diffs = check_field(insrc[c], indest[c], ["COLUMN_TYPE", "ORDINAL_POSITION", "IS_NULLABLE", "COLUMN_DEFAULT"])
        if diffs:
            diffdata[c] = diffs

    return dict(srconly=srconly, destonly=destonly, diff=diffdata)


def check_field(srcfield, destfield, columns):
    """Helper method to compare column attrs between two databases"""
    diffs = dict()
    for c in columns:
        if srcfield[c] != destfield[c]:
            diffs[c] = [srcfield[c], destfield[c]]
    return diffs


def header1(s):
    """helper method to return a formatted header"""
    if NOCOLOR:
        return s
    return colored(s, "red", attrs=['bold'])


def header2(s):
    """helper method to return a formatted header"""
    if NOCOLOR:
        return s
    return colored(s, "blue")


def header3(s):
    """helper method to return a formatted header"""
    if NOCOLOR:
        return s
    return colored(s, "green")


def main():
    """Called when run as a script"""
    global NOCOLOR

    if bool(os.getenv("DEBUG")):
        loggingConfig = {
            "version": 1,
            "disable_existing_loggers": False,
            "formatters": {
                "standard": {
                    "format": "%(asctime)s [%(levelname)5s] %(name)s: %(message)s",
                },
            },
            "handlers": {
                "default": {
                    "level": "INFO",
                    "class": "logging.StreamHandler",
                    "formatter": "standard"
                },
                "file": {
                    "level": "INFO",
                    "class": "logging.FileHandler",
                    "formatter": "standard",
                    "filename": sys.argv[0] + ".log",
                },
            },
            "loggers": {
                "": {
                    "handlers": ["default"],
                    "level": "INFO",
                    "progagate": True
                }
            }
        }
        logging.config.dictConfig(loggingConfig)
    else:
        logging.getLogger().addHandler(logging.NullHandler())

    starttime = datetime.now()
    duration = datetime.now() - starttime
    logging.getLogger().info("### starting")

    args = parse_args()

    if args.nocolor:
        NOCOLOR = True
    if not sys.stdout.isatty():
        NOCOLOR = True
    srcurl = make_url(args.srcuri)
    desturl = make_url(args.desturi)

    o = StringIO()
    o.write(get_sep("="))
    o.write(header1("Src database:") + "  {} on {}\n".format(srcurl.database, srcurl.host))
    o.write(header1("Dest database:") + " {} on {}\n".format(desturl.database, desturl.host))

    tablediff = get_diff_tables(args.srcuri, args.srcuri)

    if len(tablediff.get('srconly', [])):
        o.write(get_sep("="))
        o.write("Tables in src database only:\n")
        o.write("  {}".format(tablediff.get('srconly')))
    if len(tablediff.get('destonly', [])):
        o.write(get_sep("="))
        o.write("Tables in dest database only:\n")
        o.write("  {}".format(tablediff.get('destonly')))

    for t in tablediff.get('both', []):
        cdiff = get_diff_columns(args.srcuri, args.desturi, t)
        cso = cdiff.get("srconly", [])
        if len(cso):
            o.write(get_sep("=") + "\n")
            o.write(header1("Columns in source database table {} only:\n").format(t))
            o.write("  {}\n".format(", ".join(cso)))
        dso = cdiff.get("destonly", [])
        if len(dso):
            o.write(get_sep("=") + "\n")
            o.write(header1("Columns in dest database table {} only:\n").format(t))
            o.write("  {}\n".format(", ".join(dso)))

        if re.match("^_.+$", t):
            continue

        if cdiff.get("diff", False):
            o.write(get_sep("="))
            o.write(header1("Field differences:") + " {}:\n".format(t))
            fmt = "{:<20} {:<18} {:<30} {:<30}\n"
            o.write(header2(fmt.format("Field", "Attr", "Src", "Dest")))
            o.write(get_sep())
            fieldinfo = cdiff.get("diff")
            fields = fieldinfo.keys()
            fields.sort()
            for f in fields:
                attrs = fieldinfo[f]
                attrkeys = attrs.keys()
                attrkeys.sort()
                for a in attrkeys:
                    o.write(fmt.format(f, a, attrs[a][0], attrs[a][1]))

    print(o.getvalue())
    o.close()

    logging.getLogger().info("### finished in {}s".format(duration))


if __name__ == '__main__':
    main()
