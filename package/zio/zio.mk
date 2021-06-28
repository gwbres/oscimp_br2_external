################################################################################
#
# zio
#
################################################################################

ZIO_VERSION = v1.4.2
ZIO_SITE = https://ohwr.org/project/zio
ZIO_SITE_METHOD = git

ZIO_INSTALL_STAGING = YES

define ZIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		-C $(@D) tools
endef

define ZIO_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/include/linux
	$(INSTALL) -m 0644 $(@D)/include/linux/zio-user.h $(STAGING_DIR)/include/linux
endef

define ZIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D \
		$(@D)/tools/zio-dump \
		$(@D)/tools/zio-cat-file \
	       	$(@D)/tools/test-dtc \
		$(TARGET_DIR)/bin
endef

$(eval $(generic-package))
