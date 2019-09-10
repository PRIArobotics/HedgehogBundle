.PHONY: all install uninstall

all:

HEDGEHOG_SERVER_DISTRIBUTION = 0.9.0a3
ENV_NAME = hedgehog-server-$(HEDGEHOG_SERVER_DISTRIBUTION)


####
# RPi autostart installation targets
####

install:
	sudo mkdir -p /media/usb{1,2,3,4,5}
	cat fstab | sudo tee -a /etc/fstab >/dev/null

	sed s/ENV_NAME/$(ENV_NAME)/ hedgehog-boot.service | \
	    sudo tee /lib/systemd/system/hedgehog-boot.service >/dev/null
	sudo systemctl daemon-reload
	sudo systemctl start hedgehog-boot.service
	sudo systemctl enable hedgehog-boot.service

uninstall:
	sudo systemctl stop hedgehog-boot.service
	sudo systemctl disable hedgehog-boot.service
