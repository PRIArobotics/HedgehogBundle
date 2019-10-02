.PHONY: setup clean build install archive install-archive \
		install-deps download-sources create-virtualenv increase-swap restore-swap compile

PYTHON_VERSION ?= 3.7.4
OPENCV_VERSION ?= 4.1.1

ENV_NAME ?= cv
ENV = ~/.pyenv/versions/$(ENV_NAME)

SWAP_DEFAULT ?= 100
SWAP_INCREASED ?= 2048

setup: install-deps

clean:
	rm -rf opencv-$(OPENCV_VERSION)/build dist
	pyenv virtualenv-delete $(ENV_NAME)

build: download-sources create-virtualenv increase-swap compile restore-swap

install: create-virtualenv
	# take the stuff from build and install it
	sudo cp -r dist/system/usr /
	sudo cp -r dist/python/lib $(ENV)

archive:
	# take the stuff from build and archive it
	tar czf dist/opencv-$(OPENCV_VERSION).tar.gz -C dist/system usr
	tar czf dist/opencv-$(OPENCV_VERSION)-python-$(PYTHON_VERSION).tar.gz -C dist/python lib

download-archive:
	[ -f dist/opencv-$(OPENCV_VERSION).tar.gz ] || \
	    wget -O dist/opencv-$(OPENCV_VERSION).tar.gz https://raw.githubusercontent.com/PRIArobotics/HedgehogBundle/dist/opencv/opencv-$(OPENCV_VERSION).tar.gz
	[ -f dist/opencv-$(OPENCV_VERSION)-python-$(PYTHON_VERSION).tar.gz ] || \
	    wget -O dist/opencv-$(OPENCV_VERSION)-python-$(PYTHON_VERSION).tar.gz https://raw.githubusercontent.com/PRIArobotics/HedgehogBundle/dist/opencv/python/opencv-$(OPENCV_VERSION)-python-$(PYTHON_VERSION).tar.gz

install-archive: create-virtualenv
	# take the stuff from archive and install it
	sudo tar xzf dist/opencv-$(OPENCV_VERSION).tar.gz -C /
	sudo tar xzf dist/opencv-$(OPENCV_VERSION)-python-$(PYTHON_VERSION).tar.gz -C $(ENV)



install-deps:
	sudo apt -y install build-essential
	sudo apt -y install cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
	sudo apt -y install python3-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
	sudo apt -y install libv4l-dev libxvidcore-dev libatlas-base-dev gfortran

download-sources:
	[ -f opencv-$(OPENCV_VERSION).zip ] || \
	    wget -O opencv-$(OPENCV_VERSION).zip https://github.com/opencv/opencv/archive/$(OPENCV_VERSION).zip
	[ -f opencv_contrib-$(OPENCV_VERSION).zip ] || \
	    wget -O opencv_contrib-$(OPENCV_VERSION).zip https://github.com/opencv/opencv_contrib/archive/$(OPENCV_VERSION).zip
	[ -d opencv-$(OPENCV_VERSION) ] || \
	    unzip opencv-$(OPENCV_VERSION).zip
	[ -d opencv_contrib-$(OPENCV_VERSION) ] || \
	    unzip opencv_contrib-$(OPENCV_VERSION).zip

create-virtualenv:
	[ -d $(ENV) ] || pyenv virtualenv $(ENV_NAME)
	. $(ENV)/bin/activate && pip install numpy

increase-swap:
	sudo sed -i 's/CONF_SWAPSIZE=[0-9]\+/CONF_SWAPSIZE=$(SWAP_INCREASED)/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile restart

restore-swap:
	sudo sed -i 's/CONF_SWAPSIZE=[0-9]\+/CONF_SWAPSIZE=$(SWAP_DEFAULT)/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile restart

compile:
	mkdir -p opencv-$(OPENCV_VERSION)/build dist/system dist/python/lib

	. $(ENV)/bin/activate && cd opencv-$(OPENCV_VERSION)/build && \
	  cmake \
	    -Wno-dev \
	    -D CMAKE_BUILD_TYPE=RELEASE \
	    -D CMAKE_INSTALL_PREFIX=/usr/local \
	    -D OPENCV_EXTRA_MODULES_PATH=/home/pi/HedgehogBundle/opencv/opencv_contrib-$(OPENCV_VERSION)/modules \
	    -D ENABLE_NEON=ON \
	    -D ENABLE_VFPV3=ON \
	    -D BUILD_TESTS=OFF \
	    -D OPENCV_ENABLE_NONFREE=ON \
	    -D INSTALL_PYTHON_EXAMPLES=OFF \
	    -D BUILD_EXAMPLES=OFF \
	    -DPYTHON3_EXECUTABLE=/home/pi/.pyenv/versions/$(ENV_NAME)/bin/python \
	    -DPYTHON3_INCLUDE_DIR=/home/pi/.pyenv/versions/$(PYTHON_VERSION)/include/python3.7m \
	    -DPYTHON3_LIBRARY=/home/pi/.pyenv/versions/$(PYTHON_VERSION)/lib/libpython3.so \
	    -DCMAKE_SHARED_LINKER_FLAGS='-latomic' \
	    -D BUILD_opencv_python3=yes \
	    -D BUILD_opencv_python2=no \
	    .. && \
	  make -j4 && \
	  make DESTDIR=/home/pi/HedgehogBundle/opencv/dist/system install

	# extract python parts from the rest of the installable stuff, as we want to put it in a virtualenv of our choice
	mv dist/system/usr/local/lib/python3.7 dist/python/lib/
