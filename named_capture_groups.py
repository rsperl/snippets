#!/usr/bin/env python
# -*- coding: utf-8 -*-
import re

ingredient = "Kumquat: 2 cups"

# Name groups with ?P<name_of_group> syntax
pattern_text = r'(?P<ingredient>\w+):\s+(?P<amount>\d+)\s+(?P<unit>\w+)'

# compile for performance if using repeatedly
pattern = re.compile(pattern_text)

# get the matches (match == None if no match)
match = pattern.match(ingredient)

# get a dict of matches based on names you gave them
mdict = match.groupdict()

print("Ingredient: " + mdict().get("ingredient"))
print("Amount: " + mdict().get("amount"))
print("Unit: " + mdict().get("unit"))
