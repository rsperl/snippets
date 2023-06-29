# parse args in name=value format and export vars as $prefix_$name=$value
# usage: parse_nvp_args_with_prefix HELLO a=b c=d
# result: sets HELLO_a=b, HELLO_c=d
function parse_nvp_args_with_prefix() {
  local prefix="$1"
  shift
  local args="$@"
  if [[ $prefix != "" ]] && [[ ! $prefix =~ _$ ]]; then
    prefix="${prefix}_"
  fi
  for arg in ${args[*]}; do
    local name="$prefix${arg%=*}"
    local value="${arg#*=}"
    export $name=$value
  done
}
