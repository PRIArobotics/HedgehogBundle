# name of the project, the binaries will be generated with this name
PROJ_NAME = HedgehogFirmware

#directory for binary output files
BUILDDIR := build

.PHONY: all _clone_firmware clone-firmware-master clone-firmware-light \
    setup setup-light clean flash flash-tmp

# build the firmware in the bundled project
all: $(PROJ_NAME)/$(BUILDDIR)/$(PROJ_NAME).bin

_clone_firmware:
	test -d HedgehogFirmware || git clone https://github.com/PRIArobotics/HedgehogFirmware

# Clones the firmware so it can be built and installed
clone-firmware-master: _clone_firmware
	cd HedgehogFirmware && git checkout master

clone-firmware-light: _clone_firmware
	cd HedgehogFirmware && git checkout light


####
# setup targets
####

setup: clone-firmware-master

setup-light: clone-firmware-light

####
# build & flash targets
####

# build the firmware in the bundled project
$(PROJ_NAME)/$(BUILDDIR)/$(PROJ_NAME).bin:
	cd $(PROJ_NAME) && make $(BUILDDIR)/$(PROJ_NAME).bin

# clean up the firmware in the bundled project
clean:
	cd $(PROJ_NAME) && make clean

# flash the firmware from the bundled project
flash:
	cd $(PROJ_NAME) && make flash

# flash a binary from /tmp/$(PROJ_NAME).bin that was put there by someone else
flash-tmp:
	cd $(PROJ_NAME) && make flash-tmp
