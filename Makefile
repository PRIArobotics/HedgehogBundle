PROTOC_VERSION = 3.0.0-beta-2
PROTOC_PLATFORM = linux-x86_32

.PHONY: all protoc-install protoc env clean-env run

all: run

# install protoc
protoc-install:
	wget https://github.com/google/protobuf/releases/download/v$(PROTOC_VERSION)/protoc-$(PROTOC_VERSION)-$(PROTOC_PLATFORM).zip
	rm -f bin/protoc
	unzip protoc-$(PROTOC_VERSION)-$(PROTOC_PLATFORM).zip protoc -d bin
	rm protoc-$(PROTOC_VERSION)-$(PROTOC_PLATFORM).zip

protoc:
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	. env/bin/activate && cd HedgehogProtocol && invoke protoc

# set up the python environment for the HWC Flasher
env:
	python3 -m virtualenv env
	. env/bin/activate && pip install -e HedgehogProtocol[dev]
	. env/bin/activate && pip install -e HedgehogServer

# clean up the python environment for the HWC Flasher
clean-env:
	rm -rf env

run:
	. env/bin/activate && hedgehog-simulator
