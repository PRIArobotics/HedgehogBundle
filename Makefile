.PHONY: all protoc env clean-env install uninstall run-server run-simulator

all: run-server

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

# clean up the python environment for the HWC Flasher
clean-env:
	rm -rf env


install:
	sed -r \
	    -e 's*##PWD##*$(PWD)*' \
	    -e 's*##MAC##*$(shell ifconfig enp9s0 | grep HWaddr | sed 's/^.*HWaddr.*..:..:..:\(..:..:..\).*/\1/')*' \
	    res/bin/hedgehog-server.in > res/bin/hedgehog-server
	chmod +x res/bin/hedgehog-server

	sudo ln -s -f $(PWD)/res/init.d/hedgehog-server /etc/init.d/
	sudo ln -s -f $(PWD)/res/bin/hedgehog-server /usr/local/bin/

	sudo update-rc.d hedgehog-server defaults

uninstall:
	sudo update-rc.d hedgehog-server remove

	sudo rm -f /etc/init.d/hedgehog-server
	sudo rm -f /usr/local/bin/hedgehog-server


run-server:
	. env/bin/activate && cd HedgehogServer && hedgehog-server

run-simulator:
	. env/bin/activate && cd HedgehogServer && hedgehog-simulator
