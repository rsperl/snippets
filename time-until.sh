#!/usr/bin/env zsh

CHECK_DATES=(
  "You can retire in 2029-06-01"
)

LAST_RUN_FILE="$HOME/tmp/.time_until_lr"

function get_days_from_today {
  local other_date="$1"
  echo "$(ddiff --format "%Y %m %d" now "$other_date")"
}

function format_field {
  local n="$1"
  local f="$2"
  if [[ $n == "0" ]]; then
    echo ""
    return 0
  fi
  local s="$n $f"
  if [[ $n != "1" ]]; then
    s+="s"
  fi
  echo "$s"
}

function format_result {
  local result="$1"
  local nyears="$(echo "$result" | awk '{print $1}')"
  local nmonths="$(echo "$result" | awk '{print $2}')"
  local ndays="$(echo "$result" | awk '{print $3}')"
  local years="$(format_field "$nyears" "year")"
  local months="$(format_field "$nmonths" "month")"
  local days="$(format_field "$ndays" "day")"
  s="$days"
  if [[ $months != "" ]]; then
    s="$months, $s"
  fi
  if [[ $years != "" ]]; then
    s="$years, $s"
  fi
  echo "$s"
}

for a in $CHECK_DATES[@]; do
  d="$(echo "$a" | awk '{print $NF}')"
  p="$(echo "$a" | sed -e "s/ $d$//")"
  ndays="$(get_days_from_today "$d")"
  result="$(format_result "$ndays")"
  echo "$p $result"
done
