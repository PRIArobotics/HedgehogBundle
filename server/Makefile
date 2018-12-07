.PHONY: all create-env clean-env env env-develop protoc protoc-provided \
    setup setup-develop run-server run-simulator install uninstall

all: run-server

HEDGEHOG_SERVER_DISTRIBUTION = 0.6.0

# create python environment
create-env:
	test -d env || python -m virtualenv env

# delete python environment
clean-env:
	rm -rf env

# Installs a Hedgehog server distribution into the environment.
env: create-env
	. env/bin/activate && pip install --upgrade \
	    -r distributions/hedgehog-server-$(HEDGEHOG_SERVER_DISTRIBUTION).txt

# Installs Hedgehog server sources into the environment for development.
# The Hedgehog sources are installed, and can be edited, in env/src.
# Compared to `env`, this additionally installs `invoke` (via hedgehog-utils[dev] & hedgehog-protocol[dev])
# to call the protobuf compiler, and `twine`, a tool for deploying packages to PyPI.
env-develop: create-env
	. env/bin/activate && pip install --upgrade \
	    -r distributions/hedgehog-server-$(HEDGEHOG_SERVER_DISTRIBUTION)-dev.txt

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

user:
	# add user with minimal permissions
	sudo adduser --no-create-home --system --group hedgehog-server < /dev/null
	sudo usermod -a -G dialout,gpio,i2c,spi hedgehog-server

####
# setup targets
####

setup: user env

setup-develop: user env-develop protoc


####
# run targets
####

run-server:
	. env/bin/activate && hedgehog-server --port 10789 --logging-conf 'logging.conf'

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
