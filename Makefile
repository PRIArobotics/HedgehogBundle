.PHONY: all protoc env clean-env install uninstall run-server run-simulator

all: run-server

# create python environment
create-env:
	test -d env || python3 -m virtualenv env

# delete python environment
clean-env:
	rm -rf env

# Installs a Hedgehog server distribution into the environment.
env: create-env
	. env/bin/activate && pip install \
	    --extra-index-url https://testpypi.python.org/pypi/ \
	    ipython \
	    https://github.com/zeromq/pyre/archive/master.zip \
	    hedgehog-server

# Installs Hedgehog server sources into the environment for development.
# The Hedgehog sources are installed, and can be edited, in env/src.
# Compared to `env-server`, this additionally installs `invoke` (via hedgehog-utils[dev] & hedgehog-protocol[dev])
# to call the protobuf compiler, and `twine`, a tool for deploying packages to PyPI.
env-develop: create-env
	. env/bin/activate && pip install \
	    ipython twine \
	    https://github.com/zeromq/pyre/archive/master.zip \
	    -e git+https://github.com/PRIArobotics/HedgehogPlatform@develop#egg=hedgehog-platform \
	    -e git+https://github.com/PRIArobotics/HedgehogUtils@develop#egg=hedgehog-utils[dev] \
	    -e git+https://github.com/PRIArobotics/HedgehogProtocol@develop#egg=hedgehog-protocol[dev] \
	    -e git+https://github.com/PRIArobotics/HedgehogServer@develop#egg=hedgehog-server \
	    -e git+https://github.com/PRIArobotics/HedgehogClient@develop#egg=hedgehog-client[test]

# runs the protobuf compiler for hedgehog-protocol and hedgehog-utils
# only works if the server sources are installed for development
protoc:
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . env/bin/activate && \
	    cd env/src/hedgehog-protocol && invoke protoc
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . env/bin/activate && \
	    cd env/src/hedgehog-utils && invoke protoc


####
# setup targets
####

server-setup: env

server-setup-develop: env-develop protoc


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
	sed -r -e 's*##PWD##*$(PWD)*' \
	    res/bin/hedgehog-server.in > res/bin/hedgehog-server
	chmod +x res/bin/hedgehog-server

	sudo ln -s -f $(PWD)/res/init.d/hedgehog-server /etc/init.d/
	sudo ln -s -f $(PWD)/res/bin/hedgehog-server /usr/local/bin/

	sudo update-rc.d hedgehog-server defaults

uninstall:
	sudo update-rc.d hedgehog-server remove

	sudo rm -f /etc/init.d/hedgehog-server
	sudo rm -f /usr/local/bin/hedgehog-server
