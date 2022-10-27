#!/bin/sh

# src: http://www.commandlinefu.com/commands/view/4284/optimal-way-of-deleting-huge-numbers-of-files

find /path/to/dir -type f -print0 | xargs -0 rm

# Using xargs is better than:
#
#  find /path/to/dir -type f -exec rm \-f {} \;
#
# as the -exec switch uses a separate process for each remove. 
# xargs splits the streamed files into more managable subsets so less processes are required.