#!/usr/bin/env bash

DESTDIR="/storage/downloads/openwrt"
ARCHDIR="/storage/backups/openwrt/x86/64"
ARCHIVE="asrock-z77-pro4-m\|dell-inc-0hwtmh\|qemu-standard-pc-q35-ich9-2009"

set -v

(
_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_imgdir=$( ls -d bin/targets/$_target/* )

_img=$( ls -t $_imgdir/openwrt-*.img??? | head -1 )
_date=$( date -r $_img +%Y%m%d_%H%M%S )
_subdir=$_date-`echo $_img | cut -d'-' -f3-4`

_destdir="$DESTDIR/${_subdir}"
_archdir="$ARCHDIR/${_subdir}"

if [ -d "$_destdir" ]; then
	echo "$_destdir already exists"
	exit 1
fi

mkdir -p "$_destdir"
cp -a -v bin/packages bin/targets "$_destdir"/

mkdir -p "$_archdir"
_t="$_destdir/${_imgdir/bin\/}"
for file in $( ls "$_t" | grep "$ARCHIVE" ); do
	echo "Moving $file to archive..."
	mv "$_t/$file" "$_archdir"/
done

rm -f "$_t_mark" "$_a_mark" "$DESTDIR/latest" "$ARCHDIR/latest" &>/dev/null || true
ln -s $_subdir "$DESTDIR/latest"
ln -s $_subdir "$ARCHDIR/latest"

)

set +v

exit 0
