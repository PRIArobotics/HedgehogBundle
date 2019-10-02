.PHONY: setup install-nvm install-deps install archive install-archive

PROTOC_VERSION ?= 3.5.1

setup: install-nvm install-deps

install-deps:
	sudo apt -y install autoconf automake libtool curl make g++ unzip

download-sources:
	[ -f protobuf-all-$(PROTOC_VERSION).zip ] || \
	    wget -O protobuf-all-$(PROTOC_VERSION).zip https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOC_VERSION)/protobuf-all-$(PROTOC_VERSION).zip
	[ -d protobuf-$(PROTOC_VERSION) ] || \
	    unzip protobuf-all-$(PROTOC_VERSION).zip

compile:
	cd protobuf-$(PROTOC_VERSION) && \
	    ./configure && make && make check

install:
	cd protobuf-$(PROTOC_VERSION) && \
	    sudo make install
	sudo ldconfig
