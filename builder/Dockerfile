ARG OS_CODENAME=jammy

FROM ubuntu:${OS_CODENAME}

ARG DEBIAN_FRONTEND=noninteractive

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
        wget \
        python3-pip \
        gawk && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -O - \
        | tar -xj -C /opt

RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install \
    asciitree \
    jinja2 \
    pillow \
    lz4 \
    pyelftools

# work-around for datacopy build script in 2.8.5
RUN ln -s /usr/lib/x86_64-linux-gnu/libclang-14.so.14.0.0 /usr/lib/libclang-14.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libclang-14.so.14.0.0 /usr/lib/libclang.so

ENV PATH=/opt/gcc-arm-none-eabi-10-2020-q4-major/bin/:${PATH}

VOLUME ["/src"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

RUN useradd --create-home --shell /bin/bash rootless
RUN mkdir -p /home/rootless/src
USER rootless
WORKDIR /home/rootless/src
