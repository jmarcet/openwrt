define Device/generic
  DEVICE_TITLE := Generic x86/64
  GRUB2_VARIANT := generic
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += kmod-e1000e kmod-e1000 kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	kmod-sound-soc-ac97 kmod-sound-soc-core openwrt-keyring
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := generic
endef
TARGET_DEVICES += generic

define Device/dell-inc-0hwtmh
  DEVICE_TITLE := Dell Inc. XPS 15 9570
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += hostapd-common hostapd-utils kmod-cfg80211 kmod-iwlwifi \
	kmod-mac80211 kmod-rfkill kmod-sound-hda-intel kmod-sound-hda-codec-hdmi \
	kmod-sound-hda-codec-realtek iwinfo iwlwifi-firmware-iwl9260 \
	kmod-sound-soc-ac97 kmod-sound-soc-core wireless-regdb wireless-tools \
	wpa-cli wpad-openssl
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := dell-inc-0hwtmh
endef
TARGET_DEVICES += dell-inc-0hwtmh

define Device/asrock-z77-pro4-m
  DEVICE_TITLE := ASRock Z77 Pro4-M
  KERNEL_INSTALL :=
  DEVICE_PACKAGES += kmod-hwmon-nct6775 kmod-itco-wdt kmod-md-mod \
	kmod-md-raid456 kmod-phy-realtek kmod-r8169 kmod-sound-hda-intel \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	kmod-sound-soc-ac97 kmod-sound-soc-core kmod-usb-net-asix-ax88179 \
	r8169-firmware
  IMAGES := combined-efi.img.gz
  SUPPORTED_DEVICES := asrock-z77-pro4-m
endef
TARGET_DEVICES += asrock-z77-pro4-m
