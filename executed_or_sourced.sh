#!/bin/bash

# How to determine if a shell script was sourced or executed

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  echo "script was executed"
else
  echo "script was sourced"
fi
