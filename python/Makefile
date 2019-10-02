.PHONY: setup install-pyenv install-deps install archive install-archive

PYTHON_VERSION ?= 3.7.4

setup: install-pyenv install-deps

install-pyenv:
	curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

	echo '' >> ~/.bashrc
	echo 'export PATH="/home/pi/.pyenv/bin:$$PATH"' >> ~/.bashrc
	echo 'eval "$$(pyenv init -)"' >> ~/.bashrc
	echo 'eval "$$(pyenv virtualenv-init -)"' >> ~/.bashrc

install-deps:
	sudo apt -y install libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
	    zlib1g-dev xz-utils libxml2-dev libxmlsec1-dev \
	    libncursesw5-dev libgdbm-dev tk-dev liblzma-dev uuid-dev libffi-dev

install:
	CONFIGURE_OPTS="--enable-shared --enable-optimizations" /home/pi/.pyenv/bin/pyenv install $(PYTHON_VERSION)
	/home/pi/.pyenv/bin/pyenv global $(PYTHON_VERSION)

archive:
	mkdir -p dist
	tar czf dist/python-$(PYTHON_VERSION).tar.gz -C /home/pi/.pyenv/versions $(PYTHON_VERSION)

download-archive:
	[ -f dist/python-$(PYTHON_VERSION).tar.gz ] || \
	    wget -O dist/python-$(PYTHON_VERSION).tar.gz https://raw.githubusercontent.com/PRIArobotics/HedgehogBundle/dist/python/python-$(PYTHON_VERSION).tar.gz

install-archive:
	mkdir -p /home/pi/.pyenv/versions
	tar xzf dist/python-$(PYTHON_VERSION).tar.gz -C /home/pi/.pyenv/versions
	/home/pi/.pyenv/bin/pyenv global $(PYTHON_VERSION)
