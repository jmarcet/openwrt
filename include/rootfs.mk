ifdef CONFIG_USE_MKLIBS
  define mklibs
	rm -rf $(TMP_DIR)/mklibs-progs $(TMP_DIR)/mklibs-out
	# first find all programs and add them to the mklibs list
	find $(STAGING_DIR_ROOT) -type f -perm /100 -exec \
		file -r -N -F '' {} + | \
		awk ' /executable.*dynamically/ { print $$1 }' > $(TMP_DIR)/mklibs-progs
	# find all loadable objects that are not regular libraries and add them to the list as well
	find $(STAGING_DIR_ROOT) -type f -name \*.so\* -exec \
		file -r -N -F '' {} + | \
		awk ' /shared object/ { print $$1 }' > $(TMP_DIR)/mklibs-libs
	mkdir -p $(TMP_DIR)/mklibs-out
	$(STAGING_DIR_HOST)/bin/mklibs -D \
		-d $(TMP_DIR)/mklibs-out \
		--sysroot $(STAGING_DIR_ROOT) \
		`cat $(TMP_DIR)/mklibs-libs | sed 's:/*[^/]\+/*$$::' | uniq | sed 's:^$(STAGING_DIR_ROOT):-L :'` \
		--ldlib $(patsubst $(STAGING_DIR_ROOT)/%,/%,$(firstword $(wildcard \
			$(foreach name,ld-uClibc.so.* ld-linux.so.* ld-*.so ld-musl-*.so.*, \
			  $(STAGING_DIR_ROOT)/lib/$(name) \
			)))) \
		--target $(REAL_GNU_TARGET_NAME) \
		`cat $(TMP_DIR)/mklibs-progs $(TMP_DIR)/mklibs-libs` 2>&1
	$(RSTRIP) $(TMP_DIR)/mklibs-out
	for lib in `ls $(TMP_DIR)/mklibs-out/*.so.* 2>/dev/null`; do \
		LIB="$${lib##*/}"; \
		DEST="`ls "$(1)/lib/$$LIB" "$(1)/usr/lib/$$LIB" 2>/dev/null`"; \
		[ -n "$$DEST" ] || continue; \
		echo "Copying stripped library $$lib to $$DEST"; \
		cp "$$lib" "$$DEST" || exit 1; \
	done
  endef
endif

# where to build (and put) .ipk packages
opkg = \
  IPKG_NO_SCRIPT=1 \
  IPKG_INSTROOT=$(1) \
  TMPDIR=$(1)/tmp \
  $(STAGING_DIR_HOST)/bin/opkg \
	--offline-root $(1) \
	--force-postinstall \
	--add-dest root:/ \
	--add-arch all:100 \
	--add-arch $(if $(ARCH_PACKAGES),$(ARCH_PACKAGES),$(BOARD)):200

TARGET_DIR_ORIG := $(TARGET_ROOTFS_DIR)/root.orig-$(BOARD)

ifdef CONFIG_CLEAN_IPKG
  define clean_ipkg
	-find $(1)/usr/lib/opkg/info -type f -and -not -name '*.control' -delete
	-sed -i -ne '/^Require-User: /p' $(1)/usr/lib/opkg/info/*.control
	awk ' \
		BEGIN { conffiles = 0; print "Conffiles:" } \
		/^Conffiles:/ { conffiles = 1; next } \
		!/^ / { conffiles = 0; next } \
		conffiles == 1 { print } \
	' $(1)/usr/lib/opkg/status >$(1)/usr/lib/opkg/status.new
	mv $(1)/usr/lib/opkg/status.new $(1)/usr/lib/opkg/status
	-find $(1)/usr/lib/opkg -empty -delete
  endef
endif

define prepare_rootfs
	$(if $(2),@if [ -d '$(2)' ]; then \
		$(call file_copy,$(2)/.,$(1)); \
	fi)
	@mkdir -p $(1)/etc/rc.d
	@mkdir -p $(1)/var/lock
	@( \
		cd $(1); \
		for script in ./usr/lib/opkg/info/*.postinst; do \
			IPKG_INSTROOT=$(1) $$(command -v bash) $$script; \
			ret=$$?; \
			if [ $$ret -ne 0 ]; then \
				echo "postinst script $$script has failed with exit code $$ret" >&2; \
				exit 1; \
			fi; \
		done; \
		for script in ./etc/init.d/*; do \
			grep '#!/bin/sh /etc/rc.common' $$script >/dev/null || continue; \
			if ! echo " $(3) " | grep -q " $$(basename $$script) " && \
				! echo " $$(basename $$script) " | grep -q -f $(2)/etc/disabled-services 2>/dev/null; then \
				IPKG_INSTROOT=$(1) $$(command -v bash) ./etc/rc.common $$script enable; \
				echo "Enabling" $$(basename $$script); \
			else \
				IPKG_INSTROOT=$(1) $$(command -v bash) ./etc/rc.common $$script disable; \
				echo "Disabling" $$(basename $$script); \
			fi; \
		done || true \
	)
	$(if $(SOURCE_DATE_EPOCH),sed -i "s/Installed-Time: .*/Installed-Time: $(SOURCE_DATE_EPOCH)/" $(1)/usr/lib/opkg/status)
	@-find $(1) -name CVS -o -name .svn -o -name .git -o -name '.#*' | $(XARGS) rm -rf
	@( \
		KDIR="$(BUILD_DIR)/linux-$(BOARD)$(if $(SUBTARGET),_$(SUBTARGET))"; \
		LINUX_VERSION="`ls $$KDIR/ | grep '^linux-5'`"; \
		LINUX_DIR="$$KDIR/$$LINUX_VERSION"; \
		LINUX_UNAME_VERSION="`ls $(1)/lib/modules/`"; \
		TARGET_MODULES_DIR="$(1)/lib/modules/$$LINUX_UNAME_VERSION"; \
		rm -rf \
		$(1)/boot \
		$(1)/lib/modules/$$LINUX_UNAME_VERSION \
		$(1)/tmp/* \
		$(1)/usr/lib/opkg/info/*.postinst* \
		$(1)/usr/lib/opkg/lists/* \
		$(1)/var/lock/*.lock; \
		make -C $$LINUX_DIR INSTALL_MOD_PATH=$(1) modules_install; \
		find $$TARGET_MODULES_DIR/kernel/ -type f -exec mv '{}' $$TARGET_MODULES_DIR/ \; ; \
		rm -fr $$TARGET_MODULES_DIR/{build,kernel,source} \
	)
	$(call clean_ipkg,$(1))
	$(call mklibs,$(1))
	$(if $(SOURCE_DATE_EPOCH),find $(1)/ -mindepth 1 -execdir touch -hcd "@$(SOURCE_DATE_EPOCH)" "{}" +)
endef
