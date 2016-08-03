.PHONY: all protoc env clean-env run

all: run

protoc:
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . env/bin/activate && \
	    cd HedgehogProtocol && invoke protoc
	export PATH="$(PWD)/protoc-arm/bin:$(PATH)" && \
	    export LD_LIBRARY_PATH="$(PWD)/protoc-arm/lib:$(LD_LIBRARY_PATH)" && \
	    . env/bin/activate && \
	    cd HedgehogUtils && invoke protoc

# set up the python environment for the HWC Flasher
env:
	python3 -m virtualenv env
	. env/bin/activate && pip install https://github.com/zeromq/pyre/archive/master.zip
	. env/bin/activate && pip install -e HedgehogPlatform
	. env/bin/activate && pip install -e HedgehogUtils
	. env/bin/activate && pip install -e HedgehogProtocol[dev]
	. env/bin/activate && pip install -e HedgehogServer
	. env/bin/activate && pip install -e HedgehogClient[test]

install:
	sed -re 's*##PWD##*$(PWD)*' res/bin/hedgehog-server.in > res/bin/hedgehog-server
	chmod +x res/bin/hedgehog-server

	sudo ln -s $(PWD)/res/init.d/hedgehog-server /etc/init.d/
	sudo ln -s $(PWD)/res/bin/hedgehog-server /usr/local/bin/

	sudo update-rc.d hedgehog-server defaults

uninstall:
	sudo update-rc.d hedgehog-server remove

	sudo rm -f /etc/init.d/hedgehog-server
	sudo rm -f /usr/local/bin/hedgehog-server


# clean up the python environment for the HWC Flasher
clean-env:
	rm -rf env

run-server:
	. env/bin/activate && hedgehog-server

run-simulator:
	. env/bin/activate && hedgehog-simulator
