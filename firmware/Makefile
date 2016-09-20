# name of the project, the binaries will be generated with this name
PROJ_NAME = HedgehogLightFirmware

#directory for binary output files
BUILDDIR := build

.PHONY: all create-env clean-env env env-develop protoc protoc-provided \
    setup setup-develop run-server run-simulator install uninstall

# build the firmware in the bundled project
all: $(PROJ_NAME)/$(BUILDDIR)/$(PROJ_NAME).bin

# create python environment
create-env:
	test -d env || python3 -m virtualenv env

# delete python environment
clean-env:
	rm -rf env

# Installs a Hedgehog flasher distribution into the environment.
env: create-env
	. env/bin/activate && pip install \
	    --extra-index-url https://testpypi.python.org/pypi/ \
	    hedgehog-hwc-flasher

# Installs Hedgehog flasher sources into the environment for development.
# The Hedgehog sources are installed, and can be edited, in env/src.
# Compared to `env-server`, this additionally installs `invoke` (via hedgehog-utils[dev] & hedgehog-protocol[dev])
# to call the protobuf compiler, and `twine`, a tool for deploying packages to PyPI.
env-develop: create-env
	. env/bin/activate && pip install \
	    twine \
	    -e git+https://github.com/PRIArobotics/HedgehogPlatform@develop#egg=hedgehog-platform \
	    -e git+https://github.com/PRIArobotics/HedgehogHWCFlasher@develop#egg=hedgehog-hwc-flasher

# Clones the firmware so it can be built and installed
clone-firmware:
	test -d HedgehogLightFirmware || git clone https://github.com/PRIArobotics/HedgehogLightFirmware


####
# setup targets
####

setup: env clone-firmware

setup-develop: env-develop clone-firmware

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
	. env/bin/activate && cd $(PROJ_NAME) && make flash

# flash a binary from /tmp/$(PROJ_NAME).bin that was put there by someone else
flash-tmp:
	. env/bin/activate && hedgehog-hwc-flasher /tmp/$(PROJ_NAME).bin
