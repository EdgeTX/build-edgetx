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

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi.tar.xz -O - \
        | tar -xJ -C /opt

USER gitpod

RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install \
    asciitree \
    jinja2 \
    pillow \
    lz4

ENV PATH=/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin/:${PATH}

VOLUME ["/src"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
