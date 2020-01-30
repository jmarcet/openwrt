platform_check_image() {
	[ "$#" -ne 1 ] && return 1
	local img="$1"

	sgdisk -p "$img" | grep -A 100 '^Number' | tail +2 > /tmp/partmap-raw.image
	[ $( cat /tmp/partmap-raw.image | wc -l ) -eq 4 ] && \
		 [ -n "$( grep 'EF00  EFI System' /tmp/partmap-raw.image )" ] || {
			echo "Invalid image type"
			rm -f /tmp/partmap*.image
			return 1
		}
	awk '{ print $1" "$2" " ( $3 - $2 + 1 ) }' /tmp/partmap-raw.image > /tmp/partmap.image
	rm -f /tmp/partmap-raw.image
}

platform_copy_config() {
	local partdev

	if export_partdevice_label partdev openwrt_boot; then
		mount -t ext4 -o rw,noatime "/dev/$partdev" /mnt
		cp -af "$UPGRADE_BACKUP" "/mnt/$BACKUP_FILE"
		umount /mnt
	fi
}

platform_do_upgrade() {
	local _alt bootpart defboot partdev partdevalt part start size

	export_partdevice_label bootpart openwrt_boot \
		&& export_partdevice_label partdev openwrt_rootfs \
		&& export_partdevice_label partdevalt openwrt_rootfs_alt || {
			echo "Unable to determine upgrade device"
			return 1
		}

	grep -q 'root=PARTLABEL=openwrt_rootfs_alt' /proc/cmdline && _alt= || _alt=-alt
	grep -q ' /boot ' /proc/mounts || {
		mount /dev/$bootpart /boot
		[ -d /boot/boot ] && mount --bind /boot/boot /boot
	}

	#iterate over each partition from the image and write it to the boot disk
	while read part start size; do
		case "$part" in
			2)
				echo "Writing new kernel to /boot/vmlinuz$_alt..."
				[ -n "$_alt" ] && defboot=1 || defboot=0
				get_image "$@" | dd of=/tmp/.bootkernel.img ibs="512" obs=1M skip="$start" count="$size" conv=fsync
				mkdir -p /tmp/.bootkernel \
					&& mount -t ext4 -o ro /tmp/.bootkernel.img /tmp/.bootkernel \
					&& cp -af /tmp/.bootkernel/boot/vmlinuz /boot/vmlinuz$_alt \
					&& sed -e "s:^set default.\+$:set default=\"$defboot\":" -i /boot/grub/grub.cfg
				umount /tmp/.bootkernel; rm -f /tmp/.bootkernel.img; umount /boot
				grep -q ' /boot ' /proc/mounts && umount /boot
				;;
			3)
				[ -n "$_alt" ] && partdev=$partdevalt
				echo "Writing image to /dev/$partdev..."
				dd if=/dev/zero of="/dev/$partdev" bs=1M skip=490 count=32 conv=fsync
				get_image "$@" | dd of="/dev/$partdev" ibs="512" obs=1M skip="$start" count="$size" conv=fsync
				;;
		esac
	done < /tmp/partmap.image
	sync
}
