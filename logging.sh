#!/usr/bin/env bash

# source: https://github.com/nk412/tinylogger/blob/master/tinylogger.bash
# usage:
#   . logging.sh
#   tlog info my log message
#   tlog error my log message
# Note that if you get the error "parse error near `|'" it's because you
# aren't using bash
LOGGER_FMT=${LOGGER_FMT:="%Y-%m-%d %H:%M:%S"}
LOGGER_LVL=${LOGGER_LVL:="info"}

function tlog {
  action=$1 && shift
  case $action in
  debug) [[ $LOGGER_LVL =~ debug ]] && echo "$(date "+${LOGGER_FMT}") - DEBUG - $@" 1>&2 ;;
  info) [[ $LOGGER_LVL =~ debug|info ]] && echo "$(date "+${LOGGER_FMT}") - INFO - $@" 1>&2 ;;
  warn) [[ $LOGGER_LVL =~ debug|info|warn ]] && echo "$(date "+${LOGGER_FMT}") - WARN - $@" 1>&2 ;;
  error) [[ ! $LOGGER_LVL =~ none ]] && echo "$(date "+${LOGGER_FMT}") - ERROR - $@" 1>&2 ;;
  esac
  true
}
