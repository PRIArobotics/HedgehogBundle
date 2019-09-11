PYTHON_VERSION = 3.7.4
OPENCV_VERSION = 4.1.1

ENV_NAME = cv
ENV = ~/.pyenv/versions/$(ENV_NAME)

SWAP_DEFAULT=100
SWAP_INCREASED=2048

build-opencv: get-dependencies get-sources create-virtualenv increase-swap compile restore-swap

get-dependencies:
	sudo apt -y install build-essential
	sudo apt -y install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
	sudo apt -y install python3-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
	sudo apt -y install libv4l-dev libxvidcore-dev libatlas-base-dev gfortran

get-sources:
	wget -O opencv.zip https://github.com/opencv/opencv/archive/$(OPENCV_VERSION).zip && \
	wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$(OPENCV_VERSION).zip && \
	unzip opencv.zip
	unzip opencv_contrib.zip

increase-swap:
	sudo sed -i 's/CONF_SWAPSIZE=[0-9]\+/CONF_SWAPSIZE=$(SWAP_INCREASED)/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile restart

clean:
	rm -rf opencv-$(OPENCV_VERSION)/build dist
	pyenv virtualenv-delete $(ENV_NAME)

create-virtualenv:
	[ -d $(ENV) ] || pyenv virtualenv $(ENV_NAME)
	. $(ENV)/bin/activate && pip install numpy

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
	mv dist/system/lib/python3.7 dist/python/lib/

restore-swap:
	sudo sed -i 's/CONF_SWAPSIZE=[0-9]\+/CONF_SWAPSIZE=$(SWAP_DEFAULT)/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile restart

install-opencv:
