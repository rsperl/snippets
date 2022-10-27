#!/usr/bin/env python

import sqlite3
import os
from pathlib import Path


# use an in-memory database instead of on-disk
# DBFILE = ":memory:"

CURDIR = os.getcwd()
DBFILE = Path(CURDIR) / "data.sqlite"
if DBFILE.is_file():
    DBFILE.unlink()

SCHEMA = """
create table names (
    name text,
    age integer
);
"""


def dict_factory(cursor, row):
    """Allow accesing results by column name"""
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


conn = sqlite3.connect(DBFILE)
conn.row_factory = dict_factory
c = conn.cursor()
c.execute(SCHEMA)

c.execute("insert into names values (?, ?)", ("Richard", 29))
# does not seem to be required
# conn.commit()
print(f"Rows affected commit: {c.rowcount}")

for r in c.execute("select * from names"):
    print(f"Name: {r['name']}")
    print(f"Age:  {r['age']}")

c.close()

