fwtool_check_signature() {
	[ $# -gt 1 ] && return 1

	[ ! -x /usr/bin/ucert ] && {
		return 1
	}

	if ! fwtool -q -s /tmp/sysupgrade.ucert "$1"; then
		echo "Image signature not found"
		[ "$FORCE" != 1 ] && {
			echo "Use sysupgrade -F to override this check when downgrading or flashing to vendor firmware"
		}
		return 1
	fi

	fwtool -q -T -s /dev/null "$1" | \
		ucert -V -m - -c "/tmp/sysupgrade.ucert" -P /etc/opkg/keys

	return $?
}

fwtool_check_image() {
	[ $# -gt 1 ] && return 1

	. /usr/share/libubox/jshn.sh

	if ! fwtool -q -i /tmp/sysupgrade.meta "$1"; then
		echo "Image metadata not found"
		[ "$FORCE" != 1 ] && {
			echo "Use sysupgrade -F to override this check when downgrading or flashing to vendor firmware"
		}
		return 1
	fi

	json_load "$(cat /tmp/sysupgrade.meta)" || {
		echo "Invalid image metadata"
		return 1
	}

	device="$(cat /tmp/sysinfo/board_name)"

	json_select supported_devices || return 1

	json_get_keys dev_keys
	for k in $dev_keys; do
		json_get_var dev "$k"
		[ "$dev" = "$device" ] && return 0
	done

	echo "Device $device not supported by this image"
	echo -n "Supported devices:"
	for k in $dev_keys; do
		json_get_var dev "$k"
		echo -n " $dev"
	done
	echo

	return 1
}
