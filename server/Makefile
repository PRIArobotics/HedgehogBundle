.PHONY: all create-env clean-env env env-develop protoc protoc-provided \
    setup setup-develop run-server run-simulator install uninstall

all: run-server

# create python environment
create-env:
	test -d env || python3 -m virtualenv env

# delete python environment
clean-env:
	rm -rf env

# Installs a Hedgehog server distribution into the environment.
env: create-env
	. env/bin/activate && pip install --upgrade \
	    --extra-index-url https://testpypi.python.org/pypi/ \
	    ipython \
	    https://github.com/zeromq/pyre/archive/master.zip \
	    hedgehog-server hedgehog-client

# Installs Hedgehog server sources into the environment for development.
# The Hedgehog sources are installed, and can be edited, in env/src.
# Compared to `env`, this additionally installs `invoke` (via hedgehog-utils[dev] & hedgehog-protocol[dev])
# to call the protobuf compiler, and `twine`, a tool for deploying packages to PyPI.
env-develop: create-env
	. env/bin/activate && pip install --upgrade \
	    ipython twine \
	    https://github.com/zeromq/pyre/archive/master.zip \
	    -e git+https://github.com/PRIArobotics/HedgehogPlatform@develop#egg=hedgehog-platform \
	    -e git+https://github.com/PRIArobotics/HedgehogUtils@develop#egg=hedgehog-utils[dev] \
	    -e git+https://github.com/PRIArobotics/HedgehogProtocol@develop#egg=hedgehog-protocol[dev] \
	    -e git+https://github.com/PRIArobotics/HedgehogServer@develop#egg=hedgehog-server \
	    -e git+https://github.com/PRIArobotics/HedgehogClient@develop#egg=hedgehog-client[test]

# Runs the protobuf compiler for hedgehog-protocol and hedgehog-utils.
# This only works if the server sources are installed for development.
# This target uses the protoc binary from this repository, which is for ARM. On a development machine, install protoc
# manually and use `protoc-provided`
protoc:
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . env/bin/activate && \
	    cd env/src/hedgehog-protocol && invoke protoc
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . env/bin/activate && \
	    cd env/src/hedgehog-utils && invoke protoc

# Runs the protobuf compiler for hedgehog-protocol and hedgehog-utils.
# This only works if the server sources are installed for development.
# This target uses the protoc binary installed on the system
protoc-provided:
	. env/bin/activate && \
	    cd env/src/hedgehog-protocol && invoke protoc
	. env/bin/activate && \
	    cd env/src/hedgehog-utils && invoke protoc


####
# setup targets
####

setup: env

setup-develop: env-develop protoc

with-raspberry:
	. env/bin/activate && pip install \
	    hedgehog-platform[raspberry] hedgehog-server[raspberry]


####
# run targets
####

run-server:
	. env/bin/activate && hedgehog-server --port 10789 --logging-conf 'logging.conf'

autorun-server:
	. env/bin/activate && hedgehog-server --logging-conf 'logging.conf' --scan-file /media/usb/hedgehog.conf --scan

run-simulator:
	. env/bin/activate && hedgehog-simulator --port 10789 --logging-conf 'logging.conf'


####
# RPi autostart installation targets
####

install:
	sudo cp ./hedgehog-server.service /lib/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl start hedgehog-server.service
	sudo systemctl enable hedgehog-server.service

uninstall:
	sudo systemctl stop hedgehog-server.service
	sudo systemctl disable hedgehog-server.service
