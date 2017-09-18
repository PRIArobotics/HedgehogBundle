IDE_VERSION = 1.1.1
NODE_VERSION = 7.9.0
IDE_RELEASE = https://github.com/PRIArobotics/hedgehog-ide/releases/download/v$(IDE_VERSION)/hedgehog-ide-$(IDE_VERSION)-linux-armv6l.tar.gz

all: release

setup:
	sudo aptitude -y install libssl-dev libzmq-dev
	wget https://nodejs.org/dist/v$(NODE_VERSION)/node-v$(NODE_VERSION)-linux-armv6l.tar.gz -O /tmp/nodejs.tar.gz
	tar -xf /tmp/nodejs.tar.gz -C /tmp
	sudo cp -R /tmp/node-v$(NODE_VERSION)-linux-armv6l/* /usr/local/
	sudo setcap cap_net_bind_service=+ep $(shell readlink -f $(shell which node))

release:
	wget $(IDE_RELEASE) -O ./hedgehog-ide.tar.gz
	tar -xf ./hedgehog-ide.tar.gz
	cp ./server.config.js ./hedgehog-ide/config/server.config.js
	mkdir -p $(shell node -p "require('./server.config.js').programStorageDirectory")
	chgrp nogroup $(shell node -p "require('./server.config.js').programStorageDirectory")
	chmod g+w $(shell node -p "require('./server.config.js').programStorageDirectory")

autorun-ide:
	cd hedgehog-ide && umask 002 && npm start --production

install:
	sudo cp ./hedgehog-ide.service /lib/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl start hedgehog-ide.service
	sudo systemctl enable hedgehog-ide.service

uninstall:
	sudo systemctl stop hedgehog-ide.service
	sudo systemctl disable hedgehog-ide.service
