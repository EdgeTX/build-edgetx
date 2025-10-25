ARG OS_CODENAME=jammy

FROM ubuntu:${OS_CODENAME}

ARG DEBIAN_FRONTEND=noninteractive
ARG GCC_ARM_VERSION=14.2.rel1

# Install system packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        ca-certificates \
        build-essential \
        dumb-init \
        libclang-dev \
        cmake \
        git \
        zip \
        unzip \
        file \
        wget \
        python3-dev \
        gawk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Python packages installation
COPY --from=ghcr.io/astral-sh/uv:0.8.24 /uv /uvx /bin/
ENV VIRTUAL_ENV=/opt/venv
RUN uv venv \
        --python-preference system --no-python-downloads \
        ${VIRTUAL_ENV} && \
    uv pip install --no-cache \
        asciitree \
        clang \
        jinja2 \
        pillow \
        lz4 \
        pyelftools \
        pydantic
# Add venv to PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Create user in base layer (rarely changes)
RUN useradd --create-home --shell /bin/bash rootless && \
    mkdir -p /home/rootless/src

FROM base AS base-amd64
ARG GCC_ARM_VERSION
ENV GCC_ARM_ARCH=x86_64
# Download and extract ARM toolchain
RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/${GCC_ARM_VERSION}/binrel/arm-gnu-toolchain-${GCC_ARM_VERSION}-${GCC_ARM_ARCH}-arm-none-eabi.tar.xz -O /tmp/gcc-arm.tar.xz && \
    tar -xJ -C /opt -f /tmp/gcc-arm.tar.xz && \
    rm /tmp/gcc-arm.tar.xz

FROM base AS base-arm64
ARG GCC_ARM_VERSION
ENV GCC_ARM_ARCH=aarch64
# Download and extract ARM toolchain
RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/${GCC_ARM_VERSION}/binrel/arm-gnu-toolchain-${GCC_ARM_VERSION}-${GCC_ARM_ARCH}-arm-none-eabi.tar.xz -O /tmp/gcc-arm.tar.xz && \
    tar -xJ -C /opt -f /tmp/gcc-arm.tar.xz && \
    rm /tmp/gcc-arm.tar.xz

ARG TARGETARCH

FROM base-${TARGETARCH} AS final

ARG GCC_ARM_VERSION
ENV PATH=/opt/arm-gnu-toolchain-${GCC_ARM_VERSION}-${GCC_ARM_ARCH}-arm-none-eabi/bin/:${PATH}

VOLUME ["/src"]
WORKDIR /home/rootless/src
USER rootless
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
