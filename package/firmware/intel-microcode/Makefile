#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=intel-microcode
PKG_VERSION:=20201110
PKG_RELEASE:=1

PKG_ORIG_NAME=Intel-Linux-Processor-Microcode-Data-Files
PKG_SOURCE:=microcode-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/intel/$(PKG_ORIG_NAME)/archive/
PKG_HASH:=c9e42ad0032d8cd611c7bc2fb94a16429ac485c7971809737b055550a49f58b8
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_ORIG_NAME)-microcode-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=iucode-tool/host

include $(INCLUDE_DIR)/package.mk

define Package/intel-microcode
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=$(PKG_SOURCE_URL)
  DEPENDS:=@TARGET_x86
  TITLE:=Intel x86 CPU microcode
endef

define Build/Compile
	rm -f intel-ucode{,-with-caveats}/list
	mkdir $(PKG_BUILD_DIR)/intel-ucode-ipkg
	$(STAGING_DIR)/../host/bin/iucode_tool -q \
		--write-firmware=$(PKG_BUILD_DIR)/intel-ucode-ipkg $(PKG_BUILD_DIR)/intel-ucode
	#$(STAGING_DIR)/../host/bin/iucode_tool --write-earlyfw=$(PKG_BUILD_DIR)/intel-ucode.img $(PKG_BUILD_DIR)/intel-ucode{,-with-caveats}/
endef

define Package/intel-microcode/install
	#$(INSTALL_DIR) $(1)/boot
	#$(INSTALL_DATA) $(PKG_BUILD_DIR)/intel-ucode.img $(1)/boot
	$(INSTALL_DIR) $(1)/lib/firmware/intel-ucode
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/intel-ucode-ipkg/* $(1)/lib/firmware/intel-ucode
endef

$(eval $(call BuildPackage,intel-microcode))
