IDE_RELEASE = https://github.com/PRIArobotics/hedgehog-ide/releases/download/v0.2-beta/hedgehog-ide-v0.2.0-beta-linux-armv6l.tar.gz
NODE_VERSION = 7.9.0

all: dependencies release service

release:
	wget $(IDE_RELEASE) -O /tmp/hedgehog-ide.tar.gz
	tar -xf hedgehog-ide-v0.2.0-beta-linux-armv6l.tar.gz -C /home/pi
	cp /home/pi/hedgehog-ide/config/server.config.example.js /home/pi/hedgehog-ide/config/server.config.js

dependencies:
	wget https://nodejs.org/dist/v$(NODE_VERSION)/node-v$(NODE_VERSION)-linux-armv6l.tar.gz -o /tmp/nodejs.tar.gz
	tar -xvf /tmp/nodejs.tar.gz
	sudo cp -R /tmp/node-v$(NODE_VERSION)-linux-armv6l/* /usr/local/
	sudo apt update
	sudo apt install libssl-dev libzmq-dev

service:
	sudo cp /home/pi/hedgehog-ide/systemd/hedgehog-ide.service /lib/systemd/system
	sudo systemctl start hedgehog-ide.service
	sudo systemctl enable hedgehog-ide.service
