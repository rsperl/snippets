#!/bin/bash

# adapted from http://hints.macworld.com/article.php?story=20110617204111325

set -e

label="mattermost"
plistfile="$HOME/Library/LaunchAgents/$label.plist"

function setup_mattermost() {
  cat <<EOF >"$plistfile"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>mattermost</string>
  <key>KeepAlive</key>
  <true/>
  <key>Program</key>
  <string>/Applications/Mattermost.app/Contents/MacOS/Mattermost</string>
</dict>
</plist>
EOF
}

function load_mattermost() {
  launchctl load "$plistfile"
}

function unload_mattermost() {
  launchctl remove "$label"
}

action=$1

if [[ $action == "" ]]; then
  echo "Usage: $0 <setup|load|unload>"
  exit 1
fi

if [[ $action == "setup" ]]; then
  setup_mattermost
  load_mattermost
elif [[ $action == "load" ]]; then
  load_mattermost
elif [[ $action == "unload" ]]; then
  unload_mattermost
else
  echo "invalid action '$action' - should be one of load or unload"
  exit 1
fi
