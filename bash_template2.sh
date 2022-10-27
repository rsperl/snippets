#!/bin/bash

# see also 
#  - Google's Shell Style Guide: https://google.github.io/styleguide/shell.xml
#  - ShellCheck: https://github.com/koalaman/shellcheck

# src:
#  - http://hackaday.com/2017/07/21/linux-fu-better-bash-scripting
#  - https://dev.to/thiht/shell-scripts-matter

# exit if any line fails (you can do command_fails || true, and the script continues)
set -o errexit

set -euo pipefail
# -e            exit if any command returns non-zero status
# -u            prevent use of undefined variables
# -o pipefail   force pipelines to fail on first non-zero code

IFS=$'\n\t'

action=${1:-"default value"}

tmpdir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")

# write to stderr
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

readonly LOG_FILE="$(basename "$0").log"
info()    { echo "[INFO]    $@" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $@" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $@" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $@" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

cleanup() {
  info "### finished"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  trap cleanup EXIT
  info "### starting"
  # Script goes here
  # ...
fi
