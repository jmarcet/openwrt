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

if [ -d "$_t1" ]; then
    echo "$_t1 already exists"
    exit 1
fi

mkdir -p $_t1
for dir in $( ls -t $_bindir/ | head -10 ); do
    cp -a -v $_bindir/$dir $_t1/
done
)

set +v

exit 0
