#!/bin/bash

set -e

_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )
#_arch=$( echo $_bindir | cut -d'/' -f3- | tr '/' '-' )

if grep -q ' /boot ' /proc/mounts; then
    [ -w /boot ] || mount -o remount,rw /boot
    [ -w /boot ] || {
        echo "Boot partition mounted ro. Umount it or make it rw!"
        exit 1
    }
fi

_image=$( ls -t $_bindir/openwrt-*-x86-64-asustek-computer-inc-sabertooth-z77-squashfs-combined-efi.img.gz | head -1 )

if [ -z "$_image" ]; then
    echo "Usage: no suitable image found"
    exit 1
fi

echo "Upggrading with image $(ls -al $_image)"

sysupgrade -i -n -p -v $_image

exit 0
