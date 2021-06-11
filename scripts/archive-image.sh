#!/usr/bin/env bash

DESTDIR="/storage/downloads/openwrt"
ARCHDIR="/storage/backups/openwrt/x86/64"
ARCHIVE="asrock-z77-pro4-m\|asustek-computer-inc-sabertooth-z77\|dell-inc-0hwtmh\|qemu-standard-pc-q35-ich9-2009"

INTERACTIVE=1
[ $# -eq 1 -a "$1" == "-f" ] && INTERACTIVE=0

ask_bool() {
	local default="$1"; shift;
	local answer="$default"

	[ "$INTERACTIVE" -eq 1 ] && {
		case "$default" in
			0) echo -n "$* (y/N): ";;
			*) echo -n "$* (Y/n): ";;
		esac
		read answer
		case "$answer" in
			y*) answer=1;;
			n*) answer=0;;
			*) answer="$default";;
		esac
	}
	[ "$answer" -gt 0 ]
}                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                              
set -v

(
_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_imgdir=$( ls -d bin/targets/$_target/* )
 eval $( grep CONFIG_EXTERNAL_KERNEL_TREE .config)

_build=$( cat $_imgdir/version.buildinfo )
_img=$( ls -t $_imgdir/openwrt-*.img??? | head -1 )
_date=$( date -r $_img +%Y%m%d_%H%M%S )
_subdir=$_date-`echo $_img | cut -d'-' -f3-4`

_destdir="$DESTDIR/${_subdir}"
_archdir="$ARCHDIR/${_subdir}"

_TAG="$_date.$_build.master-x64"
_TAG2="$_date.#_build.asustek-computer-inc-sabertooth-z77"
_pwd=$(pwd)

if [ -d "$_destdir" ]; then
	echo "$_destdir already exists"
	exit 1
fi

for dir in . feeds/packages feeds/luci; do
	cd $_pwd/$dir
	ask_bool 1 "Add git tag $_TAG for $dir" && git tag $_TAG
	ask_bool 1 "Push force and push new tag $_TAG for $dir" && ( git push --force origin && git push --tags origin )
done
cd $_pwd/files-asustek-computer-inc-sabertooth-z77
ask_bool 1 "Add git tag $_TAG2" && git tag $_TAG2
ask_bool 1 "Push force and push new tag $_TAG2" && ( git push --force origin && git push --tags origin )
cd $_pwd

mkdir -p "$_destdir"
cp -a -v bin/packages bin/targets "$_destdir"/
[ -n "$CONFIG_EXTERNAL_KERNEL_TREE" ] && cp -a "$CONFIG_EXTERNAL_KERNEL_TREE"/.config "$_destdir"/targets/x86/64/config-kernel.${_TAG2}

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
