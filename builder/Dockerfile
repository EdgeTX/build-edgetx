ARG OS_CODENAME=jammy

FROM ubuntu:${OS_CODENAME}

ARG DEBIAN_FRONTEND=noninteractive
ARG GCC_ARM_VERSION=14.2.rel1

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
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
COPY --from=ghcr.io/astral-sh/uv:0.7.20 /uv /uvx /bin/
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

# Install ARM toolchain
RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/${GCC_ARM_VERSION}/binrel/arm-gnu-toolchain-${GCC_ARM_VERSION}-x86_64-arm-none-eabi.tar.xz -O - \
        | tar -xJ -C /opt

ENV PATH=/opt/arm-gnu-toolchain-${GCC_ARM_VERSION}-x86_64-arm-none-eabi/bin/:${PATH}

VOLUME ["/src"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

RUN useradd --create-home --shell /bin/bash rootless
RUN mkdir -p /home/rootless/src
USER rootless
WORKDIR /home/rootless/src
