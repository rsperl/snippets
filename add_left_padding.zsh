#!/bin/zsh

# left padding parameter expansion flag
value=145
echo ${(l:10::0:)value}
# 0000000145
