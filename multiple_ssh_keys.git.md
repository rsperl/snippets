## Create the ssh keys

```shell
ssh-keygen -t ed25519 -C my.email@example.com

# save to ~/.ssh/id_new_ssh_keys
```

## Clone the repo

```shell
git clone -c "core.sshCommand=ssh -i ~/.ssh/id_new_ssh_keys -F /dev/null" git@github.com:example/example.git

# configuration saved in .git/config of the repo
# you can now use normal commands it will use the right keys
```

or for an existing repo

```shell
git config core.sshCommand "ssh -i ~/.ssh/id_new_ssh_keys -F /dev/null"
```

---

Src: https://superuser.com/a/912281
