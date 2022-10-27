#!/usr/bin/env bash

login_path="$1"
database_name="$2"

dir="$HOME/.mysql_backups"
/usr/local/bin/mysqldump --login-path="$login_path" "$database_name" | gzip >"$dir/$database_name-$(/bin/date +%Y-%m-%d_%H%M%S).sql.gz"
