.PHONY: all protoc env clean-env run

all: run

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
