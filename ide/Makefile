IDE_VERSION = 1.1.1
NODE_VERSION = 7.9.0
IDE_RELEASE = https://github.com/PRIArobotics/hedgehog-ide/releases/download/v$(IDE_VERSION)/hedgehog-ide-$(IDE_VERSION)-linux-armv6l.tar.gz

all: release

setup:
	# install dependencies
	sudo aptitude -y install libssl-dev libzmq-dev
	wget https://nodejs.org/dist/v$(NODE_VERSION)/node-v$(NODE_VERSION)-linux-armv6l.tar.gz -O /tmp/nodejs.tar.gz
	tar -xf /tmp/nodejs.tar.gz -C /tmp
	sudo cp -R /tmp/node-v$(NODE_VERSION)-linux-armv6l/* /usr/local/

	# make sure node can bind to port 80 without running as root
	sudo setcap cap_net_bind_service=+ep $(shell readlink -f $(shell which node))

	# add user with minimal permissions
	sudo adduser --no-create-home --system --group hedgehog-ide < /dev/null
	# grant pi user access to IDE-created files (i.e. code)
	sudo usermod -a -G hedgehog-ide pi
	# FIXME remove the IDE dialout permission when PRIArobotics/hedgehog-ide#34 is fixed
	sudo usermod -a -G dialout hedgehog-ide

release:
	wget $(IDE_RELEASE) -O ./hedgehog-ide.tar.gz
	tar -xf ./hedgehog-ide.tar.gz
	cp ./server.config.js ./hedgehog-ide/config/server.config.js
	mkdir -p $(shell node -p "require('./server.config.js').programStorageDirectory")
	sudo chgrp hedgehog-ide $(shell node -p "require('./server.config.js').programStorageDirectory")
	chmod g+w $(shell node -p "require('./server.config.js').programStorageDirectory")

install:
	sudo cp ./hedgehog-ide.service /lib/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl start hedgehog-ide.service
	sudo systemctl enable hedgehog-ide.service

uninstall:
	sudo systemctl stop hedgehog-ide.service
	sudo systemctl disable hedgehog-ide.service
