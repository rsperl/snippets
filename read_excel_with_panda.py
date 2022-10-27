#!/usr/bin/env python

# src: http://pandas.pydata.org/pandas-docs/stable/io.html#io-excel-reader

import pandas as pd

# get a dataframe from xlsx object
xlsx = pd.ExcelFile("path_to_file.xls")
df = pd.read_excel(xlsx, "Sheet1")

# get dataframe from context object
with pd.ExcelFile("path_to_file.xls") as xls:
    df1 = pd.read_excel(xls, "Sheet1")
    df2 = pd.read_excel(xls, "Sheet2")

# examples of manipulating dataframes
# http://code-love.com/2017/04/30/excel-sql-python/
