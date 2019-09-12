.PHONY: setup install-nvm install-deps install archive install-archive

NODE_VERSION ?= 7.9.0

setup: install-nvm install-deps

install-nvm:
	curl -L https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

install-deps:
	sudo aptitude -y install libssl-dev libzmq-dev libcurl4-gnutls-dev

install:
	export NVM_DIR="$$HOME/.nvm" && . "$$NVM_DIR/nvm.sh" && nvm install $(NODE_VERSION)

archive:

install-archive: