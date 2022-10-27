#!/usr/bin/env bash

# Remove all entries that have a key ending in `.comment`:

data='{"key": "value", "key.comment": "key comment"}'
echo "$data" |
  jq '.|with_entries(select(.key|test(".\\.comment$")|not))'

#
# {
#   "key": "value"
# }
