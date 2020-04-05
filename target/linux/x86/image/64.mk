define Device/generic
  DEVICE_TITLE := Generic x86/64
  GRUB2_VARIANT := generic
  DEVICE_PACKAGES += kmod-e1000e kmod-e1000 kmod-r8169 kmod-igb kmod-bnx2
  SUPPORTED_DEVICES := generic
endef
TARGET_DEVICES += generic

define Device/asrock-z77-pro4-m
  DEVICE_TITLE := ASRock Z77 Pro4-M
  DEVICE_PACKAGES += kmod-fs-btrfs kmod-hwmon-drivetemp kmod-hwmon-nct6775 \
	kmod-kvm-intel kmod-md-mod kmod-md-raid456 kmod-phy-realtek kmod-r8169 \
	kmod-sound-hda-codec-hdmi kmod-sound-hda-codec-realtek \
	kmod-usb-net-asix-ax88179 kmod-veth
  IMAGES := combined-efi.img.gz
  IMAGE/combined-efi.img := grub-config efi | combined efi | append-metadata
  IMAGE/combined-efi.img.gz := grub-config efi | combined efi | gzip | append-metadata
  SUPPORTED_DEVICES := asrock-z77-pro4-m
endef
TARGET_DEVICES += asrock-z77-pro4-m
