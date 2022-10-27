#!/bin/bash

# show prompt without a newline
echo -n "Password:"

# Turn off echo
stty -echo

# Read what the user typed
read passwd

# Turn echo back on
stty echo

# instead of turning echo off and back on, you can also
# save the current tty settings with
#     stty_orig=$(stty -g)
# turn echo off, then restore the tty settings with
#     stty $stty_orig

echo "you entered: $passwd"
