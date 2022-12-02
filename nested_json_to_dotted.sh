#!/usr/bin/env bash

# Convert a nested json file to dotted keys
# Example output:
# a.b.c.0: 1
# a.b.c.1: 2
# a.b.c.2: 3
# x.y.0.m.r: t
# x.y.0.n.s: u
# x.y.1.m: 3

echo '{
    "a": {
        "b": {
            "c": [1,2,3]
        }
    },
    "x": {
        "y": [
            {
                "m": {
                    "r": "t"
                 },
                "n": {
                    "s": "u"
                }
            },
            {
                "m": 3
            }
        ]
    }
}' |
  jq -r 'paths(scalars) as $p
  | [ ( [ $p[] | tostring ] | join(".") )
    , ( getpath($p) )
    ]
  | join(": ")'
