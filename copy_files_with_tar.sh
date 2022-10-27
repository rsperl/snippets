#!/bin/sh

tar cf - * | ( cd /target; tar xfp -)