random_string() {
  local length="${1:-8}"
  echo "(($RANDOM * $RANDOM))" | base64 | tr '[A-Z]' '[a-z]' | sed 's/=//g' | tail -c "$length"
}
