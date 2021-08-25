################################################################################
#
# spec
#
################################################################################

LINUX_EXTENSIONS += spec

define SPEC_PREPARE_KERNEL
	if [ ! -e $(HOST_DIR)/usr/bin/cheby ]; then \
		echo 'Please install manually cheby by running "make host-cheby"'; \
		exit 1; \
	fi
	$(HOST_DIR)/usr/bin/cheby --gen-c -i $(SPEC_DIR)/hdl/rtl/spec_base_regs.cheby > $(SPEC_DIR)/software/kernel/spec-core-fpga.h

	`# Create destination directory`; \
	DEST_DIR=$(LINUX_DIR)/drivers/wrtd_ref_spec150t_adc; \
	mkdir -p $${DEST_DIR}; \
	if [ ! -e $${DEST_DIR}/Kconfig ]; then \
		sed -i 's:endmenu:source "drivers/wrtd_ref_spec150t_adc/Kconfig"\nendmenu:g' $(LINUX_DIR)/drivers/Kconfig; \
		echo 'obj-y += wrtd_ref_spec150t_adc/' >> $(LINUX_DIR)/drivers/Makefile; \
	fi; \
	\
	`# Copy sources`; \
	cp -dpfr $(SPEC_DIR)/software/kernel $${DEST_DIR}/spec; \
	\
	`# Add a Kconfig`; \
	echo 'config SPEC' >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\ttristate \"SPEC drivers for Linux\"" >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\tdefault m" >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\tselect FMC" >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\tselect FPGA" >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\tselect GENERAL_CORES" >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\thelp" >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\t  A simple 4-lane PCIe carrier for a low pin count FPGA Mezzanine Card (VITA 5.7)." >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\t  " >> $${DEST_DIR}/spec/Kconfig; \
	echo -e "\t  https://ohwr.org/project/spec" >> $${DEST_DIR}/spec/Kconfig; \
	\
	echo 'source "drivers/wrtd_ref_spec150t_adc/spec/Kconfig"' >> $${DEST_DIR}/Kconfig; \
	\
	`# Edit Makefile`; \
	echo 'obj-m += spec/' >> $${DEST_DIR}/Makefile;
endef
