#!/bin/bash

timeout 2 bash -c "</dev/tcp/$s/636" 2>&1
# check $?
