FROM gitpod/workspace-base:latest

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        dumb-init \
        python3-clang \
        cmake \
        git \
        zip \
        unzip \
        file \
        python3-pip \
        gawk && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -O - \
        | tar -xj -C /opt

USER gitpod

RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install \
    asciitree \
    jinja2 \
    pillow \
    lz4

ENV PATH=/opt/gcc-arm-none-eabi-10-2020-q4-major/bin/:${PATH}

VOLUME ["/src"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
