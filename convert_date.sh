#!/usr/bin/env bash

# convert from timestamp to epoch: 1626459360
date -d '2021-07-16 14:16:00' +%s

# returns days left until given date
function countdown_days_left() {
  local future_date="$1"
  if [[ -z $future_date ]]; then
    echo "Usage: $0 <YYYY-mm-dd>"
    return 1
  fi

  future_date_sec="$(date -d "$future_date" +%s)"
  now_sec="$(date +%s)"
  days_sec="$((future_date_sec - now_sec))"

  # requires bc to correctly account for DST
  days=$(
    printf "%.0f" $(
      echo "scale=2; ($future_date_sec - $now_sec )/(60*60*24)" | bc
    )
  )
  echo "$days"
}
