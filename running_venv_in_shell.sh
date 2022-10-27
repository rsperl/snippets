#!/bin/bash

# Wrapper script for running python applications in a virtualenv
# Defaults to the awx user ansible venv used by tower
# To override, set the full path to the virtual env up to the bin dir


#
# usage: venv_wrapper.sh pythonscript.py scriptarg1 scriptarg2 ...
#

VENVDIR=${VENVDIR:-/var/lib/awx/venv/ansible}
ACTIVATE="$VENVDIR/bin/activate"
if [[ ! -f "$ACTIVATE" ]]
then
    echo "could not find venv activate script '$ACTIVATE'"
    exit 1
fi
source "$ACTIVATE"
$@

