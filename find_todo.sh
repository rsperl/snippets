#!/usr/bin/env bash

# TODO - this is here for testing

if [ -z "$VSCODE_PID" ]; then
  ag -i '#\s*todo|#\s*hack|#\s*fixme' 2>/dev/null
else
  ag --vimgrep -i '#\s*todo|#\s*hack|#\s*fixme' 2>/dev/null
fi
