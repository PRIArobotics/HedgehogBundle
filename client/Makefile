.PHONY: all create-env clean-env env env-gui env-develop env-gui-develop protoc protoc-provided \
    setup setup-develop run-gui install uninstall

all: run-server

# create python environment
create-env:
	test -d env || python -m virtualenv env

# delete python environment
clean-env:
	rm -rf env

# Installs a Hedgehog client distribution into the environment.
env: create-env
	. env/bin/activate && pip install \
	    ipython \
	    https://github.com/zeromq/pyre/archive/master.zip \
	    hedgehog-client

# Installs the Hedgehog GUI
env-gui: env
	. env/bin/activate && pip install \
	    git+https://gitlab.com/kivymd/KivyMD.git#egg=kivymd \
	    hedgehog-gui

# Installs Hedgehog client sources into the environment for development.
# The Hedgehog sources are installed, and can be edited, in env/src.
# Compared to `env`, this additionally installs `invoke` (via hedgehog-utils[dev] & hedgehog-protocol[dev])
# to call the protobuf compiler, `hedgehog-server` (via hedgehog-client[test]) to run client tests, and `twine`, a tool
# for deploying packages to PyPI.
env-develop: create-env
	. env/bin/activate && pip install --upgrade \
	    ipython twine \
	    https://github.com/zeromq/pyre/archive/master.zip \
	    -e git+https://github.com/PRIArobotics/HedgehogPlatform@develop#egg=hedgehog-platform \
	    -e git+https://github.com/PRIArobotics/HedgehogUtils@develop#egg=hedgehog-utils[dev] \
	    -e git+https://github.com/PRIArobotics/HedgehogProtocol@develop#egg=hedgehog-protocol[dev] \
	    -e git+https://github.com/PRIArobotics/HedgehogServer@develop#egg=hedgehog-server \
	    -e git+https://github.com/PRIArobotics/HedgehogClient@develop#egg=hedgehog-client[test]

# Installs the Hedgehog GUI for devlopment
# The Hedgehog sources are installed, and can be edited, in env/src.
env-gui-develop: env-develop
	. env/bin/activate && pip install --upgrade \
	    --extra-index-url https://testpypi.python.org/pypi/ \
	    git+https://gitlab.com/kivymd/KivyMD.git#egg=kivymd \
	    -e git+https://github.com/PRIArobotics/HedgehogGui@develop#egg=hedgehog-gui

# Runs the protobuf compiler for hedgehog-protocol and hedgehog-utils.
# This only works if the client sources are installed for development.
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
# This only works if the client sources are installed for development.
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
setup-gui: env-gui

setup-develop: env-develop protoc
setup-gui-develop: env-gui-develop protoc


####
# run targets
####

run-gui:
	. env/bin/activate && hedgehog-gui


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
