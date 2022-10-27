#!/usr/bin/env python
# -*- coding: utf-8 -*-

try:
    from collections import ChainMap
except ImportError:
    from chainmap import ChainMap

uservars = {"layer": 1, "layer1": True}
defaults = {"layer": 2, "layer2": True}

# create a ChainMap from uservars
m = ChainMap(uservars)

# instead of doing .update, do .new_child(new_dict)
# and update m to thew new value
# continue for all data to pull in
# each call to new_child adds a "map," which is a list
#   of dicts
# calls to m.get will search each list of dicts for the value,
#   beginning with the LAST ADDED DICT FIRST
m = m.new_child(defaults)

# the last child (defaults) has priority
# i.e., {'layer2': True, 'layer': 2, 'layer1': True}
# note that key layer is 2 (from defaults), but we want 1 (from uservars)
print("last child has priority:")
print(m)
print("layer: {}".format(m.get("layer")))
print("\n")

# to give uservars priority, reverse the maps
m.maps = list(reversed(m.maps))
print("reverse the maps to give uservars priority:")
print(m)
print("layer: {}".format(m.get("layer")))
# now key layer is 1
# {'layer2': True, 'layer': 1, 'layer1': True}
