IDE_VERSION = 1.3.0
NODE_VERSION = 8.9.4
IDE_RELEASE = https://github.com/PRIArobotics/hedgehog-ide/releases/download/v$(IDE_VERSION)/hedgehog-ide-$(IDE_VERSION)-linux-armv6l.tar.gz

all: setup-release

setup-release: install-node setup-env install-release config-release enable-service

setup-develop: install-node install-develop

install-node:
		sudo aptitude -y update
		sudo aptitude -y install libssl-dev libzmq-dev libcurl4-gnutls-dev
		wget https://nodejs.org/dist/v$(NODE_VERSION)/node-v$(NODE_VERSION)-linux-armv7l.tar.gz -O /tmp/nodejs.tar.gz
		tar -xf /tmp/nodejs.tar.gz -C /tmp
		sudo cp -R /tmp/node-v$(NODE_VERSION)-linux-armv7l/* /usr/local/

setup-env:
	# make sure node can bind to port 80 without running as root
	sudo setcap cap_net_bind_service=+ep /usr/local/bin/node

	# add user with minimal permissions
	sudo adduser --no-create-home --system --group hedgehog-ide < /dev/null
	# grant pi user access to IDE-created files (i.e. code)
	sudo usermod -a -G hedgehog-ide pi
	# FIXME remove the IDE dialout permission when PRIArobotics/hedgehog-ide#34 is fixed
	sudo usermod -a -G dialout hedgehog-ide

install-develop:
	git clone https://github.com/PRIArobotics/hedgehog-ide.git
	cd hedgehog-ide && npm install
	cd hedgehog-ide && ./node_modules/typings/dist/bin.js install
	cd hedgehog-ide && ./node_modules/grunt/bin/grunt build

create-release:
	cd hedgehog-ide && ./node_modules/grunt/bin/grunt release
	tar czfv hedgehog-ide-$(IDE_VERSION)-linux-armv7l.tar.gz hedgehog-ide/release --transform 's/hedgehog-ide\/release/hedgehog-ide/'

install-release:
	wget $(IDE_RELEASE) -O ./hedgehog-ide.tar.gz
	tar -xf ./hedgehog-ide.tar.gz

config-release:
	cp ./server.config.js ./hedgehog-ide/config/server.config.js
	# Generate a JWT secret
	# Though this is not the optimal way of injecting the generated secret
	# into the config file, it works ¯\_(ツ)_/¯
	sed -i.bak "s#\(jwtSecret: *'\)[^']*\('\)#\1`node -e "console.log(require('crypto').randomBytes(256).toString('base64'));"`\2#g" ./hedgehog-ide/config/server.config.js
	mkdir -p $(shell node -p "require('./server.config.js').programStorageDirectory")
	sudo chgrp hedgehog-ide $(shell node -p "require('./server.config.js').programStorageDirectory")
	chmod g+w $(shell node -p "require('./server.config.js').programStorageDirectory")

enable-service:
	sudo cp ./hedgehog-ide.service /lib/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl start hedgehog-ide.service
	sudo systemctl enable hedgehog-ide.service

disable-service:
	sudo systemctl stop hedgehog-ide.service
	sudo systemctl disable hedgehog-ide.service
