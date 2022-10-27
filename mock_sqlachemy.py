#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sqlalchemy import create_engine


# use a minimal dburi with no real info
dburi = "mysql://"

# create method to be called upon execute
def mockery(sql, *args, **kwargs):
    print("sql: {}".format(sql))
    print("args: {}".format(args))
    print("kwargs: {}".format(kwargs))


# create db engine using strategy=mock and executor the method to be called
db = create_engine(dburi, strategy="mock", executor=mockery)

db.engine.execute("select * from mytable where updated_on=%s", "current_timestamp")

# the executor can be changed on the fly
def mockery2(sql, *args, **kwargs):
    print("mockery2")


db.executor = mockery2
db.engine.execute("select 2")
