#!/usr/bin/env bash

DESTDIR=/storage/backups/openwrt

set -v

(
_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )
_bindir2=$_bindir/packages
#_arch=$( echo $_bindir | cut -d'/' -f3- | tr '/' '-' )

_destdir=$DESTDIR/${_bindir/bin\/targets\/}
_img=$( ls -t $_bindir/openwrt-*-x86-64-asrock-z77-pro4-m-squashfs-combined-efi.img.gz | head -1 )
_date=$( date -r $_img +%Y%m%d_%H%M%S )
_subdir=$_date-`echo $_img | cut -d'-' -f3-4`

_t=$_destdir/$_subdir
_latest=$_destdir/latest

if [ -d "$_t" ]; then
    echo "$_t already exists"
    exit 1
fi

mkdir -p $_t
for dir in $( ls -t $_bindir/ | head -11 ); do
    cp -a -v $_bindir/$dir $_t/
done

rm -f "$_latest" &>/dev/null
ln -s $_subdir $_latest

)

set +v

exit 0
