#!/usr/bin/env bash

# if not using colors, any color vars used must be set to an empty string
set +u
if [[ -z $NOCOLOR ]]; then
  NOCOLOR=""
  YELLOW=""
  RED=""
fi
set -u

# write to stderr
function err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $$ $@" >&2
}

function info() {
  err "[INFO]    $@" >&2
}

function warning() {
  err "$YELLOW[WARNING] $@$NOCOLOR"
}

function error() {
  err "$RED[ERROR]   $@$NOCOLOR"
}

function fatal() {
  err "$RED[FATAL]   $@$NOCOLOR"
  return 1
}
