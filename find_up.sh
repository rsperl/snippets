#!/usr/bin/env zsh

target="${1:-}"
max_level="${2:-10}"

if [[ $target == "" ]]; then
  echo "Find a file or directory above current directory"
  echo "Usage: $0 <file_or_dir> [max_level]"
  echo "max_level must be an integer between 1 and 20 (default=10)"
  exit 1
fi

if [[ $max_level =~ ^[1-9]+$ ]] && ($max_level >20); then
  echo "max_level must be an integer between 1 and 20 (default=10)"
  exit 1
fi

if [[ -d $target ]]; then
  echo "$target"
  exit 0
fi

test_dir=""
for i in $(seq 1 "$max_level"); do
  test_dir="$test_dir../"
  if [[ -d "$test_dir$target" ]]; then
    echo "$test_dir$target"
    exit 0
  fi
done
exit 1
