To do `git rmtag myTagName`

```ini
[alias]
  rmtag= !sh -c 'git tag -d $1 && git push origin :refs/tags/$1' -

```
