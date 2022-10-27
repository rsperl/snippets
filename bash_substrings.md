# Bash Substrings

src: https://opensource.com/article/17/6/bash-parameter-expansion

### `${varname:offset}` get the last part of a string

    $ v='richard'
    $ echo ${v:3}
    hard
    $

### `${varname:offset:length}` get a substring

    $ v='richard'
    $ echo ${v:3:2}
    ha
    $

### `${varname#pattern}` remove beginning of string through pattern (`##` makes it greedy)

    $ v='richard'
    $ echo ${v#*h}
    ard
    $

For example, to find the lowest priority directory in `PATH`, do

    echo ${PATH##*:}

### `${varname%pattern}` remove end of string from pattern (`%%` makes it greedy)

    $ v='richard'
    $ echo ${v%a*}
    rich
    $

For example, to find the highist priority directory in `PATH`, do

    echo ${PATH%%:*}
