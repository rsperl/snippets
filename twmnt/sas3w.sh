#!/bin/bash

function get_third_weekend_dates() {
  local year=$1
  local month=$2
  day1=$(date --date="$year-$month-1" +%u)
  echo "(day1=$day1)"
  [[ $day1 == 1 ]] && echo "20 21"
  [[ $day1 == 2 ]] && echo "19 20"
  [[ $day1 == 3 ]] && echo "18 19"
  [[ $day1 == 4 ]] && echo "17 18"
  [[ $day1 == 5 ]] && echo "16 17"
  [[ $day1 == 6 ]] && echo "15 16"
  [[ $day1 == 7 ]] && echo "21 22"
}

function is_third_weekend_day() {
  year=$(date +%Y)
  month=$(date +%m)
  day=$(date +%d)
  dates=$(get_third_weekend_dates $year $month)
  sat=$(echo $dates | awk '{print $1}')
  sun=$(echo $dates | awk '{print $2}')
  [[ $day == $sat ]] || [[ $day == $sun ]] && echo 1
}
