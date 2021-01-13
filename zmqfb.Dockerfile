ARG UBUNTU_VERSION="bionic-20190515"
FROM ubuntu:${UBUNTU_VERSION}

ENV PREFIX_DIR=/usr/local
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV BUILD_OUTPUT=/target

ENV BUILD_OUTPUT=/target

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


RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update && apt -y install ${BUILD_DEPS} ${DEV_DEPS} && \
    rm -rf /var/lib/apt/lists/*
