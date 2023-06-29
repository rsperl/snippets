# Git notes

## List branches by date of last commit

List remote (`-r`) branches sorted by `committerdate` and show the branch name, comment, author, and relative date.

```shell
git branch -r \
    --sort=committerdate \
    --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) - %(authorname) - (%(color:green)%(committerdate:relative)%(color:reset))'
```

## Delete a remote branch

The `fetch` forces git to recognize remote branches as deleted.

```shell
git push origin :branch_name
git fetch -p
```
