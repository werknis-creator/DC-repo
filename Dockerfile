FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalacja zależności
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

# Pobranie i budowa KallistiOS
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/KallistiOS/KallistiOS.git && \
    cd KallistiOS && \
    export KOS_BASE=$(pwd) && \
    export KOS_TOOLCHAIN=/opt/toolchains/dc && \
    mkdir -p $KOS_TOOLCHAIN && \
    echo "KOS_BASE=$KOS_BASE" >> /etc/environment && \
    echo "KOS_TOOLCHAIN=$KOS_TOOLCHAIN" >> /etc/environment && \
    echo "KOS_BASE=$KOS_BASE" >> /root/.bashrc && \
    echo "KOS_TOOLCHAIN=$KOS_TOOLCHAIN" >> /root/.bashrc

WORKDIR /workspace

CMD ["/bin/bash"]
