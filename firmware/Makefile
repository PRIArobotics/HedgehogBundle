# name of the project, the binaries will be generated with this name
PROJ_NAME = HedgehogFirmware

#directory for binary output files
BUILDDIR := build

.PHONY: all _clone_firmware clone-firmware-master clone-firmware-light \
    setup setup-light clean flash flash-tmp

# build the firmware in the bundled project
all:
	cd $(PROJ_NAME) && make all

_clone_firmware:
	test -d HedgehogFirmware || git clone https://github.com/PRIArobotics/HedgehogFirmware

_checkout_firmware_master: _clone_firmware
	cd HedgehogFirmware && git fetch origin master && git checkout -B master origin/master

_checkout_firmware_light: _clone_firmware
	cd HedgehogFirmware && git fetch origin light && git checkout -B light origin/light


####
# setup targets
####

_install_firmware_toolchain:
	sudo aptitude -y install gcc-arm-none-eabi libnewlib-arm-none-eabi

_openocd:
	sudo aptitude -y install autoconf libtool libusb-1.0-0-dev
	test -d openocd || git clone git://git.code.sf.net/p/openocd/code openocd
	cd openocd && ./bootstrap
	cd openocd && ./configure --enable-maintainer-mode --enable-bcm2835gpio --enable-sysfsgpio
	cd openocd && make -j4 && sudo make install

setup: _install_firmware_toolchain _openocd _checkout_firmware_master

setup-light: _install_firmware_toolchain _openocd _checkout_firmware_light

####
# build & flash targets
####

# clean up the firmware in the bundled project
clean:
	cd $(PROJ_NAME) && make clean

# flash the firmware from the bundled project
flash:
	cd $(PROJ_NAME) && make flash

# flash a binary from /tmp/$(PROJ_NAME).bin that was put there by someone else
flash-tmp:
	cd $(PROJ_NAME) && make flash-tmp
