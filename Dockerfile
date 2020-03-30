FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
MAINTAINER Antonio Sapuppo <antoniosapuppo@yahoo.it>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        python-pip \
        nano \
        curl \
        tmux \
        htop \
        mc \
        libeigen3-dev libhdf5-dev libopenblas-dev libopenblas-base liblapacke-dev \
        libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python3-dev python-numpy python3-numpy \
        libtbb2 libtbb-dev libdc1394-22-dev \
        ocl-icd-opencl-dev libcanberra-gtk3-module \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/include/lapacke.h /usr/include/x86_64-linux-gnu

RUN pip install --upgrade pip
RUN pip install numpy
RUN pip install ipython
RUN pip install scipy
RUN pip install jupyter
RUN pip install matplotlib

WORKDIR /
ENV OPENCV_VERSION="4.2.0"
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& rm ${OPENCV_VERSION}.zip
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib-${OPENCV_VERSION}/modules \
  -DWITH_CUDA=ON \
  -DCUDA_ARCH_BIN=6.1 \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3.6 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3.6) \
  -DPYTHON_INCLUDE_DIR=$(python3.6 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.6 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  .. \
&& make install \
&& rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION}
RUN python --version
RUN python3 --version
RUN ln -s \
  /usr/lib/python3.6/dist-packages/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so \
  /usr/lib/python3/dist-packages/cv2.so
