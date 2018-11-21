#!/bin/bash

_firmware=$1

if [ -z "$_firmware" ]; then
    _target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
    _bindir=$( ls -d bin/targets/$_target/* )
    _img=$( ls -t $_bindir/*-sysupgrade.bin | head -1 )
    if [ -n "$_img" ]; then
        _firmware=$_img
    else
        echo "Usage: ./scripts $0 <firmware>"
        exit 1
    fi
fi

_name="$( basename $_firmware )"
_path=/tmp/$_name
_dirname="$( dirname $_firmware )"

(
set -e

scp $_firmware nighthawk:$_path
_dst_shasum=$( ssh nighthawk "/usr/bin/sha256sum $_path" | awk '{ print $1}' )
_src_shasum=$( grep $_name $_dirname/sha256sums | cut -d' ' -f1 )

if [ "$_dst_shasum" == "$_src_shasum" ]; then
    echo Checksums match!
    echo Performing sysupgrade, please hold tight until nighthawk comes back...
    ssh nighthawk "/sbin/sysupgrade -v -n $_path"
else
    echo Checksums differ
    echo src sha256sum=$_src_shasum
    echo dst sha256sum=$_dst_shasum
fi

set +e
)

exit 0
