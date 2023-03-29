#!/bin/bash

set -e

_tmp_image=/tmp/_openwrt.img

_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )

_image_path=$( ls -t $_bindir/openwrt-*-x86-64-asus-rog-strix-z690-i-gaming-wifi-squashfs-combined-efi.img.gz | head -1 )
_image_name=$(basename $_image_path)

if [ -z "$_image_path" ]; then
    echo "Usage: no suitable image found"
    exit 1
fi

echo "Verifying image $(ls -al $_image_path)"

sync
cp -af "$_image_path" "${_tmp_image}.gz"
[ -e "$_tmp_image" ] && rm -f "${_tmp_image}"
gunzip "${_tmp_image}.gz" || true
LOOP="$( losetup -f -P --show $_tmp_image )"
( sudo mount "${LOOP}p3" /mnt/tmp && ls -Al /mnt/tmp && sudo umount /mnt/tmp && losetup -D "$LOOP" ) || exit 1
losetup -l

echo "Image '${_image_name}' verified OK"

exit 0
