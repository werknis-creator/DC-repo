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

WORKDIR /tmp
RUN git clone --depth 1 https://github.com/KallistiOS/KallistiOS.git && \
    cd KallistiOS && \
    export KOS_BASE=$(pwd) && \
    export KOS_TOOLCHAIN=/opt/toolchains/dc && \
    mkdir -p $KOS_TOOLCHAIN && \
    echo "KOS_BASE=$KOS_BASE" >> /etc/environment && \
    echo "KOS_TOOLCHAIN=$KOS_TOOLCHAIN" >> /etc/environment

# Skopiuj ip.bin z repozytorium KallistiOS do workspace
WORKDIR /workspace
RUN cp /tmp/KallistiOS/utils/ipbin/ip.bin /workspace/ip.bin 2>/dev/null || true

CMD ["/bin/bash"]
