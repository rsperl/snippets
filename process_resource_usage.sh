#!/bin/bash

procname="$1"
if [[ -z $procname ]]; then
  echo "Usage: $0 <procname> [sleeptime] [timeout]"
  exit 1
fi
sleeptime="${2:-1}"
if [[ $sleeptime -lt 1 ]] || [[ $sleeptime -gt 60 ]]; then
  echo "sleeptime must be an integer between 1-60"
  exit 1
fi
timeout="${3:--1}"

function pidof() {
  local procname="$1"
  n=$(ps -A | grep "$procname" | grep -v grep | grep -v "$0" | wc -l | sed -e 's/ //g')
  if [[ $n > "1" ]]; then
    echo "'$procname' matches $n processes"
    return 1
  fi
  if [[ $n -eq 0 ]]; then
    echo "could not find a process matching '$procname'"
    return 1
  fi
  pid=$(ps -A | grep -m1 "$procname" | awk '{print $1}')
  echo "$pid"
  return 0
}

function get_duration() {
  local starttime="$1"
  local now=$(date +%s)
  duration=$((now - starttime))
  echo "$duration"
}

echo "getting pid for procname=$procname"
procpid=$(pidof "$procname")
rc="$?"
if [[ $rc != 0 ]]; then
  exit $rc
fi
filename=$(basename "$procname")".ps.log"

cat <<EOF | tee "$filename"
Process name: $procname
Process ID:   $procpid
Sleep time:   $sleeptime
Timeout:      $timeout
Log file:     $filename

%CPU log
---------------------------------
EOF

starttime=$(date +%s)
while :; do
  elapsed=$(get_duration "$starttime")
  if [[ $elapsed -gt $timeout ]]; then
    cat <<EOF | tee -a "$filename"
---------------------------------
Duration: ${elapsed}s
EOF
    exit 0
  fi
  date=$(date +%Y-%m-%d\ %H:%M:%S)
  cpu=$(ps -p "$procpid" -o %cpu=)"%"
  echo "$date  $cpu" | tee -a "$filename"
  sleep "$sleeptime"
done
