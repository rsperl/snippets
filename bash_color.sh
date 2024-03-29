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
