FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalacja wszystkich zależności
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
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Pobranie KallistiOS
WORKDIR /opt
RUN git clone --depth 1 https://github.com/KallistiOS/KallistiOS.git

# Ustawienie zmiennych środowiskowych
ENV KOS_BASE=/opt/KallistiOS
ENV KOS_TOOLCHAIN=/opt/toolchains/dc
ENV PATH="/opt/toolchains/dc/bin:${PATH}"

# Kompilacja toolchaina (to zajmie ~30-40 minut w CI)
RUN mkdir -p $KOS_TOOLCHAIN && \
    cd $KOS_BASE/toolchain && \
    ./build.sh 2>&1 | tee /tmp/toolchain-build.log || true
