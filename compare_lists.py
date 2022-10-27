#!/usr/bin/env python3

src = ["a", "b", "c"]
dst = ["c", "d", "e"]
srconly = list(set(src) - set(dst))
# ['a', 'b']

dstonly = list(set(dst) - set(src))
# ['e', 'd']

common_to_both = list(set(src).intersection(dst))
# ['c']
