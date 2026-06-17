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
    && rm -rf /var/lib/apt/lists/*

# Pobranie gotowego toolchaina KallistiOS
RUN mkdir -p /opt/toolchains/dc && \
    cd /opt/toolchains/dc && \
    wget -q https://github.com/KallistiOS/kos-toolchain/releases/download/continuous/kos-toolchain-linux-x86_64.tar.xz && \
    tar -xf kos-toolchain-linux-x86_64.tar.xz && \
    rm kos-toolchain-linux-x86_64.tar.xz

ENV KOS_BASE=/opt/KallistiOS
ENV KOS_TOOLCHAIN=/opt/toolchains/dc
ENV PATH="/opt/toolchains/dc/bin:${PATH}"

# Pobranie samego KallistiOS (bez kompilacji toolchaina)
RUN git clone --depth 1 https://github.com/KallistiOS/KallistiOS.git /opt/KallistiOS

WORKDIR /workspace
