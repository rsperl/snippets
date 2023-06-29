# return the final $count chars of a string
# usage: get_suffix $mystring $count
function get_suffix() {
  local s="$1"
  local count="$(($2 + 1))"
  echo "${s:count}"
}

# return a substring of $count chars from $start
# usage: get_substring $start $count
function get_substring() {
  local s="$1"
  local start="$2"
  local count="$3"
  echo "${s:start:count}"
}

# get the $count chars from the start of a string
# usage: get_prefix $my_string $count
function get_prefix() {
  local s="$1"
  local count="$2"
  echo "${s:0:count}"
}
