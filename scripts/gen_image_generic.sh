#!/usr/bin/env bash
# Copyright (C) 2006-2012 OpenWrt.org
set -e -x
[ $# == 5 -o $# == 6 ] || {
    echo "SYNTAX: $0 <file> <kernel size> <kernel directory> <rootfs size> <rootfs image> [<align>]"
    exit 1
}

OUTPUT="$1"
KERNELSIZE="$2"
KERNELDIR="$3"
ROOTFSSIZE="$4"
ROOTFSIMAGE="$5"
ALIGN="$6"

rm -f "$OUTPUT"

head=16
sect=63

# create partition table
set $(ptgen -o "$OUTPUT" -h $head -s $sect ${GUID:+-g -p 1m} -p ${KERNELSIZE}m -p ${ROOTFSSIZE}m ${GUID:+-p ${ROOTFSSIZE}m} ${ALIGN:+-l $ALIGN} ${SIGNATURE:+-S 0x$SIGNATURE} ${GUID:+-G $GUID})

if [ -n "$GUID" ]; then
    KERNELOFFSET="$(($3 / 512))"
    KERNELSIZE="$4"
    ROOTFSOFFSET="$(($5 / 512))"
    ROOTFSSIZE="$(($6 / 512))"
else
    KERNELOFFSET="$(($1 / 512))"
    KERNELSIZE="$2"
    ROOTFSOFFSET="$(($3 / 512))"
    ROOTFSSIZE="$(($4 / 512))"
fi

[ -n "$PADDING" ] && dd if=/dev/zero of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc count="$ROOTFSSIZE"
[ -n "$GUID" ] && dd if="$OUTPUT.grub.img" of="$OUTPUT" bs=512 seek=512 conv=notrunc count=2048
dd if="$ROOTFSIMAGE" of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc

make_ext4fs -J -L kernel -l "$KERNELSIZE" "$OUTPUT.kernel" "$KERNELDIR"
dd if="$OUTPUT.kernel" of="$OUTPUT" bs=512 seek="$KERNELOFFSET" conv=notrunc
rm -f "$OUTPUT.kernel"
