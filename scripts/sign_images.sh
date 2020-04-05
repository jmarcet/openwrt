#!/bin/sh

set -ex

# directory where search for images
TOP_DIR="${TOP_DIR:-./bin/targets}"
# key to sign images
BUILD_KEY="${BUILD_KEY:-key-build}" # TODO unify naming?
# remove other signatures (added e.g.  by buildbot)
REMOVE_OTER_SIGNATURES="${REMOVE_OTER_SIGNATURES:-1}"

# find all sysupgrade images in TOP_DIR
# factory images don't need signatures as non OpenWrt system doen't check them anyway
#for image in $(find $TOP_DIR -type f -name "*-sysupgrade.bin" -o -name "*-combined*.img*"); do
for image in $(find $TOP_DIR -type f -name "*-combined-efi.img" -o -name "*-combined-efi.img.gz"); do
	# remove all previous signatures
	if [ -n "$REMOVE_OTER_SIGNATURES" ]; then
		while true; do
			fwtool -t -s /dev/null "$image" || break
		done
	fi
	# run same operation as build root does for signing
	#cp -f "$BUILD_KEY.ucert" "$image.ucert"
	[ -e "$image.ucert" ] && rm -f $image.ucert
	usign -S -m "$image" -s "$BUILD_KEY" -x "$image.sig"
	ucert -A -c "$image.ucert" -x "$image.sig"
	fwtool -S "$image.ucert" "$image"
done
