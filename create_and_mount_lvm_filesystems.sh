#!/bin/sh

# # /etc/systemd/system/shared.mount

# [Unit]
# Description=Mount /shared

# [Mount]
# What=/dev/vgshared/lvshared
# Where=/shared
# Type=ext4
# Options=defaults

pvcreate /dev/vdb 
vgcreate vgdocker /dev/vdb
lvcreate -l 100%VG -n lvdocker vgdocker
mkfs -t xfs /dev/vgdocker/lvdocker
mkdir /tmp/d
mount /dev/vgdocker/lvdocker /tmp/d
umoun /tmp/d
mount /dev/vgdocker/lvdocker /var/lib/docker