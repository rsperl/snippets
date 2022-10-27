* OS: Ubuntu 16.04
* Error: can't find mysql_config
* Solution: ```apt install -y libmysqlclient-dev```
---
* OS: Ubuntu 16.04
* Error: can't find openssl.h
* Solution: ```apt install -y libssl-dev```
---
* OS: Ubuntu
* Error: libtool not found
* Solution: ```apt install -y libtool-bin```
---
* OS: Ubuntu
* Error: my_config.h not found when installing MySQL-python
* Solution: ```apt install -y libmariadbclient-dev```
---
* OS: Mac
* Error: No module named Cython.Distutils when installing pymssql
* Solution: ```brew install cython```
---
* OS: 
* Error: ```sqlfront.h not found```
* Solution: install freetds
---
* OS: 
* Error: when installing python cryptography package, you get ```error in cryptography setup command: Invalid environment marker: python_version < '3'```
* Solution: ```pip install --upgrade setuptools``` (src: https://github.com/ansible/ansible/issues/31741)
---
* OS: Any
* Error: when connecting to mysql remotely, you get the error ```Host xxx is not allowed to connect to this MySQL serverConnection closed by foreign host.```
* Solution: create the user with proper host permissions:
```
create user 'myuser'@'%' identified by 'mypassword';
grant all privileges on *.* to 'myuser'@'%' with grant option;
```
---
* OS: Mac
* Error: install MySQL-python cannot find ConfigParser
* Solution: Use mysqlclient -- MySQL-python does not work with python3
---
* OS: Mac
* Error: use of undeclared identifier 'DBVERSION_80' when installing pymssql
* Solution: ```brew install homebrew/versions/freetds091 && brew link --force freetds@0.91```
---
* OS: Mac
* Error: library not found for -lssl
* Solution: The openssl libraries paths are not exported to avoid conflict with the OS versions. Export the paths and re-run the install:

```
$ brew info openssl | grep export
  echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.zshrc
  export LDFLAGS="-L/usr/local/opt/openssl/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl/include"
  export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
$ export LDFLAGS="-L/usr/local/opt/openssl/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl/include"
  export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
$ pipenv install -U <package>
```

---
* OS: Mac
* Error: When installing perl module Crypt::SSLeay, you get an error about LibreSSL not matching the name OpenSSL
* Solution: 

```
brew install libressl
export LD_LIBRARY_PATH=$(brew --prefix openssl)/lib
export CPATH=$(brew --prefix openssl)/include
export PKG_CONFIG_PATH=$(brew --prefix openssl)/lib/pkgconfig
cpan install Crypt::SSLeay
```

---
* OS: Mac
* Error: When installing the perl module `Net::SSL`, you get the error `#include <openssl/opensslv.h>`
* Solution: 

```
export LD_LIBRARY_PATH=$(brew --prefix openssl)/lib
export CPATH=$(brew --prefix openssl)/include
export PKG_CONFIG_PATH=$(brew --prefix openssl)/lib/pkgconfig
cpan install Net::SSL
```
---
* OS: Mac
* Error: when launching ApacheDirectoryStudio, I get a pop up error saying the log is in ~/.ApacheDirectoryStudio/.metadata/.log. The log 
* Solution: per https://bugs.eclipse.org/bugs/show_bug.cgi?id=493761#c83, add `--add-modules=ALL-SYSTEM` after `--vmargs` to `/Applications/ApacheDirectoryStudio.app/Contents/Eclipse/ApacheDirectoryStudio.ini`
---
* OS: Any
* Error: when installing `python-ldap`, I get `lber.h not found`.
* Solution: install `openldap-devel` (centos) or `libsasl2-dev`, `libldap2-dev`, `libssl-dev` (Ubuntu)