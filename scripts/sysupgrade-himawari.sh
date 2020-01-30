#!/bin/bash

set -e
_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )
_arch=$( echo $_bindir | cut -d'/' -f3- | tr '/' '-' )
_vmlinuz=$( ls -t $_bindir/openwrt-*-$_arch-vmlinuz | head -1 )
if [ -n "$_vmlinuz" ]; then
    echo $_vmlinuz
else
    echo "Usage: no suitable kernel found"
    exit 1
fi
_rootfs=$( ls -t $_bindir/openwrt-*-x86-64-uefi-gpt-squashfs.img | head -1 )
if [ -n "$_rootfs" ]; then
    echo $_rootfs
else
    echo "Usage: no suitable rootfs found"
    exit 1
fi

if [ ! -w /boot/vmlinuz ]; then
    echo "Can't write kernel"
    exit 1
fi

cp -a $_rootfs /tmp/sysupgrade.img
VERBOSE=1 IMAGE=/tmp/sysupgrade.img /lib/upgrade/do_stage2
sync

exit 0
