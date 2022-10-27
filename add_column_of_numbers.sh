#!/bin/sh

cat count.txt | awk '{ sum+=$1} END {print sum}'