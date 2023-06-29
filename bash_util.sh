# read from stdin without echoing to the terminal
function read_no_echo() {
  stty -echo
  read s
  stty echo
  echo "$s"
}
