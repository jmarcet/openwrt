#!/bin/bash

set -e

_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )
#_arch=$( echo $_bindir | cut -d'/' -f3- | tr '/' '-' )

if [ ! -w /boot/vmlinuz -o ! -w /boot/vmlinuz_alt ]; then
    echo "Can't write kernel"
    exit 1
fi

_image=$( ls -t $_bindir/openwrt-*-x86-64-asustek-computer-inc-sabertooth-z77-squashfs-combined-efi.img.gz | head -1 )

if [ -z "$_image" ]; then
    echo "Usage: no suitable image found"
    exit 1
fi

sysupgrade -i -n -p -v $_image

exit 0
