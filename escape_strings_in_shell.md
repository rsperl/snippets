## Bash

Enter a line of Bash starting with a # comment, then run `!:q` on the next line to see what that would be with proper Bash escaping applied.

```shell
❯ bash
bash-5.1$ # this' string" has! bad ()[] chars in it:
bash-5.1$ !:q
'# this'\'' string" has! bad ()[] chars in it:'
bash: # this' string" has! bad ()[] chars in it:: command not found
bash-5.1$
```

How does this work? James Coglan explains:

The `!` character begins a history expansion; `!string` produces the last command beginning with string, and `:q` is a modifier that quotes the result; so I'm guessing this is equivalent to `!string` where string is "", so it produces the most recent command, just like `!!` does

## Zsh

When the string is in a variable, use the `q` flag:

```shell
s='# this'\'' string" has! bad ()[] chars in it:'
echo "{(q)s}"
```

src: https://til.simonwillison.net/bash/escaping-a-string
