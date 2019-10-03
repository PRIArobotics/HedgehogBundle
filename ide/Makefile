IDE_VERSION ?= 1.5.3
IDE_RELEASE = https://github.com/PRIArobotics/hedgehog-ide/releases/download/v$(IDE_VERSION)/hedgehog-ide-$(IDE_VERSION)-linux-armv7l.tar.gz

all: setup-release

setup-release: setup-env install-release config-release

setup-develop: setup-env install-develop config-release

setup-env: node-setcap user

node-setcap:
	# make sure node can bind to port 80 without running as root
	sudo setcap cap_net_bind_service=+ep `which node`

# add user with minimal permissions
user:
	# grant pi user access to IDE-created files (i.e. code)
	# FIXME remove the IDE dialout permission when PRIArobotics/hedgehog-ide#34 is fixed
	@if ! (id hedgehog-ide >/dev/null 2>&1) ; then \
	    sudo adduser --no-create-home --system --group hedgehog-ide < /dev/null; \
	    sudo usermod -a -G hedgehog-ide pi; \
	    sudo usermod -a -G dialout hedgehog-ide; \
	    echo "User hedgehog-ide created"; \
	else \
	    echo "User hedgehog-ide exists"; \
	fi

install-develop:
	git clone --depth 1 https://github.com/PRIArobotics/hedgehog-ide.git
	cd hedgehog-ide && npm ci && npm run release

create-release:
	# assumes `npm run release` was run (e.g. via `make install-develop`)
	tar czf hedgehog-ide-$(IDE_VERSION)-linux-armv7l.tar.gz hedgehog-ide/release --transform 's/hedgehog-ide\/release/hedgehog-ide/'

install-release:
	wget $(IDE_RELEASE) -O ./hedgehog-ide.tar.gz
	tar -xf ./hedgehog-ide.tar.gz

config-release:
	# Generate a JWT secret
	# Though this is not the optimal way of injecting the generated secret
	# into the config file, it works ¯\_(ツ)_/¯
	sed "s#\(jwtSecret: *'\)[^']*\('\)#\1`node -e "console.log(require('crypto').randomBytes(256).toString('base64'));"`\2#g" server.config.js \
	    > ./hedgehog-ide/config/server.config.js
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
