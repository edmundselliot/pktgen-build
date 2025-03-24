# Use an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        meson \
        ninja-build \
        libglib2.0-dev \
        libssl-dev \
        libzip-dev \
        libjson-c-dev \
        libbsd-dev \
        libnuma-dev \
        libpcap-dev \
        python3 \
        python3-pip \
        python3-pyelftools \
        lshw \
        pciutils \
        pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for building projects
RUN mkdir /build
WORKDIR /build

# Clone all repos
WORKDIR /build
RUN git config --global advice.detachedHead false && \
    git clone https://github.com/DPDK/dpdk --depth 1 --branch v24.11 && \
    git clone https://github.com/pktgen/Pktgen-DPDK --depth 1 --branch pktgen-24.10.3

# Build and install dpdk
WORKDIR /build/dpdk
RUN meson build -Ddisable_apps=* && \
    ninja -C build install

ENV PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig"

# Build dpdk-pktgen
WORKDIR /build/Pktgen-DPDK
RUN ./tools/pktgen-build.sh clean build && \
    ldconfig

# Set the entrypoint
ENTRYPOINT ["/bin/bash"]
WORKDIR /build/Pktgen-DPDK/builddir/app
