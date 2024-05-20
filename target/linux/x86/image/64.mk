define Device/generic
  DEVICE_VENDOR := Generic
  DEVICE_MODEL := x86/64
  GRUB2_VARIANT := generic
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += \
	kmod-amazon-ena kmod-amd-xgbe kmod-bnx2 kmod-dwmac-intel kmod-e1000e kmod-e1000 \
	kmod-forcedeth kmod-fs-vfat kmod-igb kmod-igc kmod-ixgbe kmod-r8169 \
	kmod-tg3
  IMAGES := combined-efi.img.gz
endef
TARGET_DEVICES += generic

define Device/qemu-standard-pc-q35-ich9-2009
  DEVICE_VENDOR := Qemu
  DEVICE_MOEL := Standard Q35 ICH9 2009
  GRUB_CONSOLE_CMDLINE := console=tty0
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += intel-microcode kmod-9pnet kmod-e1000 kmod-fs-9p \
	kmod-mmc kmod-mmc-realtek kmod-sound-hda-intel kmod-sound-soc-ac97 \
	kmod-sound-soc-core openwrt-keyring virtio-console-helper
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := qemu-standard-pc-q35-ich9-2009
endef
TARGET_DEVICES += qemu-standard-pc-q35-ich9-2009

define Device/dell-inc-0hwtmh
  DEVICE_VENDOR := Dell Inc.
  DEVICE_MODEL := XPS 15 9570
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += collectd-mod-wireless hostapd-common hostapd-utils \
	kmod-cfg80211 kmod-iwlwifi kmod-mac80211 kmod-mmc kmod-mmc-realtek \
	kmod-rfkill kmod-sound-hda-intel kmod-sound-hda-codec-hdmi \
	kmod-sound-hda-codec-realtek iwinfo iwlwifi-firmware-iwl9260 \
	wireless-regdb wireless-tools wpa-cli wpad-openssl
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := dell-inc-0hwtmh
endef
TARGET_DEVICES += dell-inc-0hwtmh

define Device/asrock-z77-pro4-m
  DEVICE_VENDOR := ASRock
  DEVICE_MODEL := Z77 Pro4-M
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += r8169-firmware kmod-hwmon-nct6775 kmod-igb kmod-itco-wdt \
	kmod-md-mod kmod-phy-realtek kmod-r8169 kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek kmod-sound-soc-ac97 \
	kmod-sound-soc-core kmod-usb-serial-ch341 kmod-usb-serial-cp210x \
	kmod-usb-serial-ftdi kmod-usb-serial-pl2303
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := asrock-z77-pro4-m
endef
TARGET_DEVICES += asrock-z77-pro4-m

define Device/asus-rog-strix-z690-i-gaming-wifi
  DEVICE_VENDOR := ASUS
  DEVICE_MODEL := ROG STRIX Z690-I GAMING WIFI
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += intel-microcode kmod-hwmon-nct6775 \
	kmod-i2c-801 kmod-igb kmod-igc kmod-itco-wdt kmod-md-mod kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := asus-rog-strix-z690-i-gaming-wifi
endef
TARGET_DEVICES += asus-rog-strix-z690-i-gaming-wifi

define Device/asustek-computer-inc-sabertooth-z77
  DEVICE_VENDOR := ASUSTEK Computer Inc.
  DEVICE_MODEL := Sabertooth z77
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += intel-microcode kmod-hwmon-nct6775 kmod-e1000e \
	kmod-i2c-801 kmod-igb kmod-itco-wdt kmod-md-mod kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	kmod-usb-serial-ch341 kmod-usb-serial-cp210x kmod-usb-serial-ftdi \
	kmod-usb-serial-pl2303
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := asustek-computer-inc-sabertooth-z77
endef
TARGET_DEVICES += asustek-computer-inc-sabertooth-z77
