#!/bin/bash

set -e

_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )
#_arch=$( echo $_bindir | cut -d'/' -f3- | tr '/' '-' )

_image_path=$( ls -t $_bindir/openwrt-*-x86-64-asus-rog-strix-z690-i-gaming-wifi-squashfs-combined-efi.img.gz | head -1 )
_image_name=$(basename $_image_path)

if [ -z "$_image_path" ]; then
    echo "Usage: no suitable image found"
    exit 1
fi

echo "Upggrading with image $(ls -al $_image_path)"

scp $_image_path root@shinnosuke:/tmp/
ssh root@shinnosuke "sysupgrade -i -n -p -v /tmp/$_image_name"

exit 0
