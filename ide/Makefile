all: dependencies release service

release:
	cd ~
	wget https://github.com/PRIArobotics/hedgehog-ide/releases/download/v0.2-beta/hedgehog-ide-v0.2.0-beta-linux-armv6l.tar.gz
	tar -xf  hedgehog-ide-v0.2.0-beta-linux-armv6l.tar.gz

dependencies:
	wget https://nodejs.org/dist/latest/node-v7.4.0-linux-armv6l.tar.xz
	tar -xvf node-v7.4.0-linux-armv6l.tar.xz
	sudo cp -R node-v7.4.0-linux-armv6l/* /usr/local/
	sudo apt update
	sudo apt install libssl-dev libzmq-dev

service:
	sudo cp ~/hedgehog-ide/systemd/hedgehog-ide.service /lib/systemd/system
	sudo systemctl start hedgehog-ide.service
	sudo systemctl enable hedgehog-ide.service
