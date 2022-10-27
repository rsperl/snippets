#!/bin/bash

if [[ "$(whoami)" != "root" ]]; then
  echo "script must be run as root"
  exit 1
fi

block_size=1024

swapfile="$1"
size="$2"

if [ "$size" = "" ]; then
  name="$(basename $0)"
  cat <<EOF

Usage: $name swapfile size[M|G]

# create /swapfile as 512M:
$name /swapfile 512M

# create /swapfile2 as 4G:
$name /swapfile 512G
EOF
  exit 1
fi

if [[ $swapfile =~ \ |\' ]]; then
  echo "swapfile cannot contain spaces"
  exit 1
fi
swapfile="$(realpath "$swapfile")"

parent_dir="$(dirname "$swapfile")"
if [ ! -d "$parent_dir" ]; then
  echo "parent directoy for '$swapfile' must exist: $parent_dir"
  exit 1
fi

if $(grep -q "^$swapfile" /etc/fstab); then
  echo "$swapfile is already in /etc/fstab"
  exit 0
fi

if [[ $size =~ ^[0-9]+G$ ]]; then
  size="$(echo $size | sed 's/G//')"
  units="G"
  size_bytes="$((size * 1024 * 1024 * 1024))"
elif [[ $size =~ ^[0-9]+M$ ]]; then
  units="M"
  size="$(echo $size | sed 's/M//')"
  size_bytes="$((size * 1024 * 1024))"
else
  echo "invalid units for swap size - must be 'G' or 'M'"
  exit 1
fi

count="$((size_bytes / block_size))"

f="%-10s: %-7s\n"
printf "$f" "swapfile" "$swapfile"
printf "$f" "size" "$size"
printf "$f" "bytes" "$bytes"
printf "$f" "block size" "$block_size"
printf "$f" "count" "$count"

set -e
set -x
dd if=/dev/zero of="$swapfile" bs=$block_size count=$count
chmod 0600 "$swapfile"
mkswap "$swapfile"
swapon "$swapfile"
swapon -s

echo "$swapfile swap swap defaults 0 0" >>/etc/fstab
set +x
