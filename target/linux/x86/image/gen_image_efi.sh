#!/usr/bin/env bash
set -x
[ $# == 7 ] || {
    echo "SYNTAX: $1 <file> <efi size> <efi image> <kernel size> <kernel directory> <rootfs size> <rootfs image>"
    exit 1
}

OUTPUT="$1"
EFISIZE="$2"
EFIIMAGE="$3"
KERNELSIZE="$4"
KERNELDIR="$5"
ROOTFSSIZE="$6"
ROOTFSIMAGE="$7"
GPTOFFSET=$(( $ROOTFSSIZE + 33 ))

rm -f "$OUTPUT"

head=16
sect=63
cyl=$(( ($EFISIZE + $KERNELSIZE + 2 * $ROOTFSSIZE) * 1024 * 1024 / ($head * $sect * 512)))

# create partition table
set `ptgen -o "$OUTPUT" -l 256 -h $head -s $sect -p${EFISIZE}m -p${KERNELSIZE}m -p${ROOTFSSIZE}m -p${ROOTFSSIZE}m ${SIGNATURE:+-S 0x$SIGNATURE}`

EFIOFFSET="$(($1 / 512))"
KERNELOFFSET="$(($3 / 512))"
KERNELSIZE="$4"
ROOTFSOFFSET="$(($5 / 512))"
ROOTFSSIZE="$(($6 / 512))"

dd if=/dev/zero of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc count="$(( 2 * $ROOTFSSIZE ))"
dd if="$ROOTFSIMAGE" of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc
dd if="$EFIIMAGE" of="$OUTPUT" bs=512 seek="$EFIOFFSET" conv=notrunc

make_ext4fs -J -l "$KERNELSIZE" "$OUTPUT.kernel" "$KERNELDIR"
dd if="$OUTPUT.kernel" of="$OUTPUT" bs=512 seek="$KERNELOFFSET" conv=notrunc
rm -f "$OUTPUT.kernel"

# Convert the MBR partition to GPT and set partition types and labels
dd if=/dev/zero of="$OUTPUT" bs=512 count="$GPTOFFSET" conv=notrunc oflag=append
sgdisk -g "$OUTPUT"
sgdisk -t 1:ef00 -t 2:ea00 -c 2:openwrt_boot -c 3:openwrt_rootfs -c 4:openwrt_rootfs_alt "$OUTPUT"
sgdisk -u 3:"$EFI_SIGNATURE" "$OUTPUT"
