#!/bin/bash

ARCHDIR="/mnt/openwrt_backups"

INTERACTIVE=1
[ $# -eq 1 ] && [ "$1" == "-f" ] && INTERACTIVE=0

ask_bool() {
	local default="$1"; shift;
	local answer="$default"

	[ "$INTERACTIVE" -eq 1 ] && {
		case "$default" in
			0) echo -n "$* (y/N): ";;
			*) echo -n "$* (Y/n): ";;
		esac
		read -r answer
		case "$answer" in
			y*) answer=1;;
			n*) answer=0;;
			*) answer="$default";;
		esac
	}
	[ "$answer" -gt 0 ]
}

grep -q " ${ARCHDIR} fuse.sshfs " /proc/mounts || mount "${ARCHDIR}"

set -ev

_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_imgdir=$( ls -d bin/targets/"$_target"/* )
eval "$( grep CONFIG_EXTERNAL_KERNEL_TREE .config )"

# shellcheck disable=SC2012
_img=$( ls -t "$_imgdir"/openwrt-*.img??? | head -1 )
_build=$( cat "$_imgdir"/version.buildinfo )
_date=$( date -r "$_img" +%Y%m%d_%H%M%S )
_subdir=$_date-$( echo "$_img" | cut -d'-' -f3-4 )

_archdir="$ARCHDIR/$_target/$_subdir"

_TAG="$_date.$_build.master-x64"
_TAG2="$_date.$_build.asus-rog-strix-z690-i-gaming-wifi"
_pwd=$(pwd)

if [ -d "$_archdir" ]; then
	echo "$_archdir already exists"
	exit 1
fi

for dir in . feeds/packages feeds/luci feeds/routing; do
	cd "$_pwd"/$dir
	ask_bool 1 "Add git tag $_TAG for $dir" && git tag "$_TAG"
	ask_bool 1 "Push force and push new tag $_TAG for $dir" && ( git push --force origin && git push --tags origin )
done
cd "$_pwd"/files-asus-rog-strix-z690-i-gaming-wifi
ask_bool 1 "Add git tag $_TAG2" && git tag "$_TAG2"
ask_bool 1 "Push force and push new tag $_TAG2" && ( git push --force origin && git push --tags origin )
cd "$_pwd"

mkdir -p "$_archdir"
cp -a -v bin/packages bin/targets "$_archdir"/
[ -n "$CONFIG_EXTERNAL_KERNEL_TREE" ] && cp -a "$CONFIG_EXTERNAL_KERNEL_TREE/.config" "$_archdir${_imgdir/bin}/config-kernel.$_TAG2"

rm -f "$( dirname "$_archdir" )/latest" &>/dev/null || true
ln -s "$_subdir" "$( dirname "$_archdir" )/latest"

