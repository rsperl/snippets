
```text
Host *
  ServerAliveCountMax 3
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel ERROR
  ServerAliveInterval 60
  IdentityFile ~/.ssh/id_rsa

Host *.proxied.domain.com
  ProxyCommand ssh proxyhost.domain.com nc %h %p

Host */*
  ProxyCommand ssh %r@$(dirname %h) -W $(basename %h):%p
```
