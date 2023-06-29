#!/usr/bin/env bash

function parse_nvp_args_with_prefix() {
  local prefix="$1"
  shift
  local args="$@"
  if [[ $prefix != "" ]] && [[ ! $prefix =~ _$ ]]; then
    prefix="${prefix}_"
  fi
  for arg in ${args[*]}; do
    local name="$prefix${arg%=*}"
    local value="${arg#*=}"
    export $name=$value
  done
}

parse_nvp_args X $@
echo "a=$a"
echo "b=$b"
