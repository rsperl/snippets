#!/bin/bash

action="$1"

lvmdevice="$(df / | grep -v Filesystem | awk '{print $1}')"
vgname="$(lvdisplay $lvmdevice | grep 'VG Name' | awk '{print $NF}')"

# had better be a single device, like /dev/sda2
partition="$(pvs | awk "\$2 == \"$vgname\" { print \$1}")"

# strip trailing digits
device="$(echo "$partition" | sed 's/[0-9]\+$//')"

if [ "$partition" = "$device" ]; then
  echo "partition is $partition and system device is $device"
  echo "this only works on partitions"
  exit 1
fi

partition_number="$(parted /dev/sda print | grep primary | grep lvm | awk '{print $1}')"

if [ "$action" = "expand_disk" ]; then
  echo "expanding disk"
  parted -s "$device" resizepart "$partition_number" 100%
  partprobe "$device"
  echo "if you could reboot the box, that would be great"
elif [ "$action" = "expand_lv" ]; then
  # resize pv
  pvresize "$partition"

  # resize lv
  lvextend -l +100%FREE "$lvmdevice"
  xfs_growfs /
  echo "if you could reboot the box, that would be great"
else
  echo "Usage: $0 <expand_disk|expand_lv>"
  exit 1
fi
