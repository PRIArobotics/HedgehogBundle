.PHONY: create-env clean-env env env-develop protoc protoc-provided \
    setup setup-develop run-server run-simulator install uninstall

HEDGEHOG_SERVER_DISTRIBUTION ?= 0.9.1
ENV_NAME = hedgehog-server-$(HEDGEHOG_SERVER_DISTRIBUTION)
ENV = ~/.pyenv/versions/$(ENV_NAME)

# create python environment
create-env:
	test -d $(ENV) || pyenv virtualenv $(ENV_NAME)
	rm -f env
	ln -s $(ENV) env

# delete python environment
clean-env:
	pyenv virtualenv-delete -f $(ENV_NAME)
	rm -f env

# Installs a Hedgehog server distribution into the environment.
env: create-env
	. $(ENV)/bin/activate && pip install --upgrade \
	    -r distributions/hedgehog-server-$(HEDGEHOG_SERVER_DISTRIBUTION).txt

# Installs Hedgehog server sources into the environment for development.
# The Hedgehog sources are installed, and can be edited, in env/src.
# Compared to `env`, this additionally installs `invoke` (via hedgehog-utils[dev] & hedgehog-protocol[dev])
# to call the protobuf compiler, and `twine`, a tool for deploying packages to PyPI.
env-develop: create-env
	. $(ENV)/bin/activate && pip install --upgrade \
	    -r distributions/hedgehog-server-$(HEDGEHOG_SERVER_DISTRIBUTION)-dev.txt

# Runs the protobuf compiler for hedgehog-protocol and hedgehog-utils.
# This only works if the server sources are installed for development.
# This target uses the protoc binary from this repository, which is for ARM. On a development machine, install protoc
# manually and use `protoc-provided`
protoc:
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . $(ENV)/bin/activate && \
	    cd env/src/hedgehog-protocol && invoke protoc
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . $(ENV)/bin/activate && \
	    cd env/src/hedgehog-utils && invoke protoc

# Runs the protobuf compiler for hedgehog-protocol and hedgehog-utils.
# This only works if the server sources are installed for development.
# This target uses the protoc binary installed on the system
protoc-provided:
	. $(ENV)/bin/activate && \
	    cd env/src/hedgehog-protocol && invoke protoc
	. $(ENV)/bin/activate && \
	    cd env/src/hedgehog-utils && invoke protoc

# add user with minimal permissions
# enable `sudo shutdown` and `sudo reboot` without a password for that user
user:
	@if ! (id hedgehog-server >/dev/null 2>&1) ; then \
	    sudo adduser --no-create-home --system --group hedgehog-server < /dev/null; \
	    sudo usermod -a -G dialout,gpio,i2c,spi hedgehog-server; \
	    echo 'hedgehog-server ALL = NOPASSWD: /sbin/reboot, /sbin/shutdown' | \
	        sudo tee /etc/sudoers.d/hedgehog-server >/dev/null \
	    echo "User hedgehog-server created"; \
	else \
	    echo "User hedgehog-server exists"; \
	fi

####
# setup targets
####

setup: user env

setup-develop: user env-develop protoc


####
# run targets
####

run-server:
	. $(ENV)/bin/activate && hedgehog-server --port 10789 --logging-conf 'logging.conf'

run-simulator:
	. $(ENV)/bin/activate && hedgehog-simulator --port 10789 --logging-conf 'logging.conf'


####
# RPi autostart installation targets
####

install:
	sed s/ENV_NAME/$(ENV_NAME)/ hedgehog-server.service | \
	    sudo tee /lib/systemd/system/hedgehog-server.service >/dev/null
	sudo systemctl daemon-reload
	sudo systemctl start hedgehog-server.service
	sudo systemctl enable hedgehog-server.service

uninstall:
	sudo systemctl stop hedgehog-server.service
	sudo systemctl disable hedgehog-server.service
