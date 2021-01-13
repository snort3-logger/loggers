ARG UBUNTU_VERSION="bionic-20190515"
FROM ubuntu:${UBUNTU_VERSION}

ENV PREFIX_DIR=/usr/local
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV BUILD_OUTPUT=/target
ENV SNORT_VERSION=3.0.0
ENV SNORT_RELEASE=264
ENV SNORT_IMAGE=snort3

ENV DAQ_RELEASE=alpha3
ENV DAQ_VERSION=3.0.0
ENV HYPERSCAN_VERSION=5.1.1
ENV DAQ_TAG=${DAQ_VERSION}-${DAQ_RELEASE}
ENV BUILD_OUTPUT=/target
ENV ZMQ_TAG=4.2.2-1
ENV ZMQFB_VERSION=1
ENV ZMQFB_RELEASE=3

ENV BUILD_DEPS=" \
    autoconf \
    cmake \
    g++ \
    checkinstall \
    gawk \
    libdumbnet1 \
    iproute2 \
    make \
    net-tools \
    pkg-config \
    libtool \
    build-essential \
    autoconf \
    automake \
    uuid \
    "
# Packages to install via APT for testing/developement.
ENV DEV_DEPS=" \
    iproute2 \
    net-tools \
    iputils-ping \
    traceroute \
    iptables \
    bridge-utils \
    tcpdump \
    curl \
    wget \
    git \
    gdb \
    vim \
    "
ENV ZMQFB_SRC=/plugin
COPY plugin /plugin

ADD https://github.com/loadbalancer-api/apis/releases/download/1.0/hyperscan5_${HYPERSCAN_VERSION}-SLS_amd64.deb /packages/
ADD https://github.com/loadbalancer-api/apis/releases/download/1.0/libdaq-${DAQ_VERSION}_${DAQ_TAG}_amd64.deb /packages/
ADD https://github.com/loadbalancer-api/apis/releases/download/1.0/${SNORT_IMAGE}_${SNORT_VERSION}-${SNORT_RELEASE}_amd64.deb  /packages/
ADD https://github.com/loadbalancer-api/apis/releases/download/1.0/libzmq_${ZMQ_TAG}_amd64.deb /packages/

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update && apt -y install ${BUILD_DEPS} ${DEV_DEPS} && chmod -R 777 /packages/*.deb && \
    apt-get install -y -f /packages/hyperscan5_${HYPERSCAN_VERSION}-SLS_amd64.deb \
    /packages/${SNORT_IMAGE}_${SNORT_VERSION}-${SNORT_RELEASE}_amd64.deb \
    /packages/libdaq-${DAQ_VERSION}_${DAQ_TAG}_amd64.deb /packages/libzmq_${ZMQ_TAG}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
