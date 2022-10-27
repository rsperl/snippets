#!/usr/bin/env bash

# Create the archive from the current commit
# archive can be .tar or .zip
git archive -o /tmp/myarchive.zip HEAD
