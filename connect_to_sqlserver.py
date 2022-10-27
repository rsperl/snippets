#!/usr/bin/env python3

# apt-get install -y freetds-dev
# pip install pymssql

import pymssql

server = "hostname.domainname"
database = "mydb"
username = "myuser"
password = "mypass"

conn = pymssql.connect(server, username, password, database)
cursor = conn.cursor(as_dict=True)
cursor.execute("select 6 * 7 as [Result];")
for row in cursor:
    print(row["Result"])
