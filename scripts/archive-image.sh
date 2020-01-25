#!/usr/bin/env bash

DESTDIR=/storage/downloads/openwrt

set -v

(
_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )
_bindir2=$_bindir/packages

_destdir=$DESTDIR/${_bindir/bin\/targets\/}
_img=$( ls -t $_bindir/*-x86-64-uefi-gpt-squashfs.img | head -1 )
_date=$( date -r $_img +%Y%m%d_%H%M%S )
_subdir=$_date-`echo $_img | cut -d'-' -f3-4`

_t1=$_destdir/$_subdir
_t2=$_t1/packages

if [ -d "$_t1" ] || [ -d "$_t2" ]; then
    [ -d "$_t1" ] && echo "$_t1 already exists"
    [ -d "$_t2" ] && echo "$_t2 already exists"
    exit 1
fi

mkdir -p $_t1
for i in $( ls -t $_bindir/ | head -6 ); do
    cp -a -v $_bindir/$i $_t1/
done

cp -a $_bindir2 $_t2
)

set +v

exit 0
