FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    genisoimage \
    make \
    git \
    wget \
    xz-utils \
    patch \
    texinfo \
    flex \
    bison \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    autoconf \
    automake \
    libtool \
    pkg-config \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Pobranie KallistiOS
WORKDIR /opt
RUN git clone --depth 1 https://github.com/KallistiOS/KallistiOS.git

ENV KOS_BASE=/opt/KallistiOS
ENV KOS_TOOLCHAIN=/opt/toolchains/dc
ENV PATH="/opt/toolchains/dc/bin:${PATH}"

# Budowa toolchaina używając dc-chain z repo KallistiOS
RUN mkdir -p $KOS_TOOLCHAIN && \
    cd $KOS_BASE/utils/dc-chain && \
    ./configure --prefix=$KOS_TOOLCHAIN && \
    make -j$(nproc)

WORKDIR /workspace
