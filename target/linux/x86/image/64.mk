define Device/generic
  DEVICE_VENDOR := Generic
  DEVICE_MODEL := x86/64
  DEVICE_PACKAGES += kmod-amazon-ena kmod-bnx2 kmod-e1000e kmod-e1000 \
	kmod-forcedeth kmod-igb kmod-ixgbe kmod-amd-xgbe kmod-r8169 kmod-fs-vfat
  GRUB2_VARIANT := generic
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += amd64-microcode amdgpu-firmware intel-microcode \
	kmod-drm-amdgpu kmod-e1000 kmod-e1000e kmod-itco-wdt kmod-kvm-amd \
	kmod-kvm-intel kmod-mmc kmod-r8169 kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	openwrt-keyring r8169-firmware
  IMAGES := combined-efi.img.gz
endef
TARGET_DEVICES += generic

define Device/qemu-standard-pc-q35-ich9-2009
  DEVICE_TITLE := Qemu Standard Q35 ICH9 2009
  GRUB_CONSOLE_CMDLINE := console=hvc0 console=tty0
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += intel-microcode kmod-9pnet kmod-e1000 kmod-fs-9p \
	kmod-mmc kmod-mmc-realtek kmod-sound-hda-intel openwrt-keyring \
	virtio-console-helper
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := qemu-standard-pc-q35-ich9-2009
endef
TARGET_DEVICES += qemu-standard-pc-q35-ich9-2009

define Device/dell-inc-0hwtmh
  DEVICE_TITLE := Dell Inc. XPS 15 9570
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += collectd-mod-wireless hostapd-common hostapd-utils \
	kmod-cfg80211 kmod-iwlwifi kmod-mac80211 kmod-mmc kmod-mmc-realtek \
	kmod-kmod-rfkill kmod-sound-hda-intel kmod-sound-hda-codec-hdmi \
	kmod-sound-hda-codec-realtek iwinfo iwlwifi-firmware-iwl9260 \
	wireless-regdb wireless-tools wpa-cli wpad-openssl
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := dell-inc-0hwtmh
endef
TARGET_DEVICES += dell-inc-0hwtmh

define Device/asrock-z77-pro4-m
  DEVICE_TITLE := ASRock Z77 Pro4-M
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += r8169-firmware kmod-hwmon-nct6775 kmod-igb kmod-itco-wdt \
	kmod-md-mod kmod-phy-realtek kmod-r8169 kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	kmod-usb-serial-ch341 kmod-usb-serial-cp210x kmod-usb-serial-ftdi \
	kmod-usb-serial-pl2303
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := asrock-z77-pro4-m
endef
TARGET_DEVICES += asrock-z77-pro4-m

define Device/asustek-computer-inc-sabertooth-z77
  DEVICE_TITLE := ASUS Sabertoot Zz77
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += intel-microcode kmod-hwmon-nct6775 kmod-e1000e \
	kmod-hwmon-lm78 kmod-igb kmod-ixgbe kmod-itco-wdt kmod-md-mod kmod-sfp \
	kmod-sound-hda-intel kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	kmod-usb-serial-ch341 kmod-usb-serial-cp210x kmod-usb-serial-ftdi \
	kmod-usb-serial-pl2303
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := asustek-computer-inc-sabertooth-z77
endef
TARGET_DEVICES += asustek-computer-inc-sabertooth-z77
