#!/usr/bin/env bash

CURR_DIR="$(dirname $0)"

PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
if [[ ${TRACE-0} == "1" ]]; then set -o xtrace; fi

# exit on error, unset vars, or pipefail
# set -o errexit
# set -o nounset
# set -o pipefail

# return 1 if interactive, 0 otherwise (file was sourced)
function is_interactive() {
  if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
    echo 1
  else
    echo 0
  fi
}

source "${CURR_DIR}/bash_color.sh"
(($(is_interactive))) && setup_colors
source "${CURR_DIR}/bash_logging.sh"
source "${CURR_DIR}/bash_parse_args.sh"
source "${CURR_DIR}/bash_util.sh"
