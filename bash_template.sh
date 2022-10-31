#!/usr/bin/env bash

# see also
#  - Google's Shell Style Guide: https://google.github.io/styleguide/shell.xml
#  - ShellCheck: https://github.com/koalaman/shellcheck

# src:
#  - http://hackaday.com/2017/07/21/linux-fu-better-bash-scripting
#  - https://dev.to/thiht/shell-scripts-matter

# custom set -x output
PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
if [[ ${TRACE-0} == "1" ]]; then set -o xtrace; fi

# exit on error, unset vars, or pipefail
set -o errexit
set -o nounset
set -o pipefail

# word boundaries (default is space, tab, newline)
IFS=$'\n\t'

action=${1:-"default value"}

tmpdir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")

echoerr() {
  echo "$@" >&2
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''
  args=("$@")

  while :; do
    case "${1-}" in
    -h | --help)
      usage
      ;;
    -v | --verbose)
      set -x
      ;;
    --no-color)
      NO_COLOR=1
      ;;
    -f | --flag) # example flag
      flag=1
      ;;
    -p | --param) # example named parameter
      param="${2-}"
      shift
      ;;
    -?*)
      echoerr "Unknown option: $1"
      return 1
      ;;
    *)
      break
      ;;
    esac
    shift
  done

  # check required params and arguments
  if [[ -z ${param-} ]]; then
    echoerr "Missing required parameter: param"
    return 1
  fi
  if [[ ${#args[@]} -eq 0 ]]; then
    echoerr "Missing script arguments"
    return 1
  fi

  return 0
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z ${NO_COLOR-} ]] && [[ ${TERM-} != "dumb" ]]; then
    NOCOLOR=$(echo -en '\033[0m') RED=$(echo -en '\033[00;31m') GREEN=$(echo -en '\033[00;32m')
    YELLOW=$(echo -en '\033[00;33m') BLUE=$(echo -en '\033[00;34m') MAGENTA=$(echo -en '\033[00;35m')
    PURPLE=$(echo -en '\033[00;35m') CYAN=$(echo -en '\033[00;36m') LIGHTGRAY=$(echo -en '\033[00;37m')
    LRED=$(echo -en '\033[01;31m') LGREEN=$(echo -en '\033[01;32m') LYELLOW=$(echo -en '\033[01;33m')
    LBLUE=$(echo -en '\033[01;34m') LMAGENTA=$(echo -en '\033[01;35m') LPURPLE=$(echo -en '\033[01;35m')
    LCYAN=$(echo -en '\033[01;36m') WHITE=$(echo -en '\033[01;37m')
  else
    NOCOLOR='' RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' PURPLE='' CYAN='' LIGHTGRAY=''
    LRED='' LGREEN='' LYELLOW='' LBLUE='' LMAGENTA='' LPURPLE='' LCYAN='' WHITE=''
  fi
}

# write to stderr
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $$ $@" >&2
}

info() { err "[INFO]    $@" >&2; }
warning() { err "$YELLOW[WARNING]$NOCOLOR $@"; }
error() { err "$RED[ERROR]$NOCOLOR   $@"; }
fatal() {
  err "$RED[FATAL]   $@$NOCOLOR"
  return 1
}

cleanup() {
  info "### finished"
}

parse_params "$@"
setup_colors

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  trap cleanup EXIT
  info "### starting"
  warning "watch out"
  error "oops"
  fatal "dead"
  # Script goes here
  # ...
fi
