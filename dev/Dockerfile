ARG OS_CODENAME=jammy

FROM ubuntu:${OS_CODENAME} AS base

# Redeclare ARGs after FROM
ARG OS_CODENAME
ARG DEBIAN_FRONTEND=noninteractive
ARG QT_VERSION=6.9.3
ARG QT_MODULES="-m qtmultimedia qtserialport"
ARG QT_HOST=linux
ARG QT_TARGET=desktop
ARG QT_ARCH=linux_gcc_64
ARG QT_INSTALL_DIR=/opt/qt
ARG GCC_ARM_VERSION=14.2.rel1
ARG NODE_VERSION=20.x

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Setup package repositories in a separate layer for better caching
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        software-properties-common \
        gpg \
        gpg-agent \
        wget \
        ca-certificates && \
    mkdir -p /etc/apt/keyrings && \
    # Set up Kitware repository
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | tee /etc/apt/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${OS_CODENAME} main" | \
    tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    # Set up NodeSource repository
    wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key 2>/dev/null | \
    gpg --dearmor - | tee /etc/apt/keyrings/nodesource.gpg >/dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION} nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list >/dev/null && \
    # Set up Git PPA
    add-apt-repository ppa:git-core/ppa --yes && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install system packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        dumb-init \
        libclang-dev \
        cmake \
        kitware-archive-keyring \
        git \
        zip \
        unzip \
        file \
        python3-dev \
        gawk \
        dfu-util \
        nodejs \
        locales \
        libcups2 \
        libssl-dev \
        awesome && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Generate locales in separate layer (rarely changes)
RUN locale-gen \
        zh_CN.UTF-8 \
        cs_CZ.UTF-8 \
        da_DK.UTF-8 \
        de_DE.UTF-8 \
        es_ES.UTF-8 \
        en_US.UTF-8 \
        fi_FI.UTF-8 \
        fr_FR.UTF-8 \
        he_IL.UTF-8 \
        it_IT.UTF-8 \
        ja_JP.UTF-8 \
        ko_KR.UTF-8 \
        nl_NL.UTF-8 \
        pl_PL.UTF-8 \
        pt_PT.UTF-8 \
        ru_RU.UTF-8 \
        sv_SE.UTF-8 \
        zh_TW.UTF-8 \
        uk_UA.UTF-8

# Install global npm packages
RUN npm i lv_font_conv -g && npm cache clean --force

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

# Install Qt - adapted from
# https://github.com/miurahr/aqtinstall/
# https://github.com/vslotman/docker-aqtinstall
ENV QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64
ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig

RUN uvx --no-cache --from aqtinstall aqt install-qt --outputdir ${QT_INSTALL_DIR} ${QT_HOST} ${QT_TARGET} ${QT_VERSION} ${QT_ARCH} ${QT_MODULES}

# Separate SDL2 build stage - gets cached unless SDL2 source changes
FROM base AS sdl2-builder
ARG SDL2_TAG=release-2.32.4
RUN git clone https://github.com/libsdl-org/SDL.git --depth 1 --branch ${SDL2_TAG} && \
    cd SDL && \
    mkdir build && \
    cd build && \
    ../configure --disable-static --enable-shared && \
    make -j$(nproc) && \
    make install DESTDIR=/sdl2-install && \
    # Clean up build artifacts to reduce layer size
    cd ../.. && rm -rf SDL

# Main base stage with SDL2 installed
FROM base AS base-with-sdl2
COPY --from=sdl2-builder /sdl2-install /
RUN ldconfig

FROM base-with-sdl2 AS base-amd64
ARG GCC_ARM_VERSION
ENV GCC_ARM_ARCH=x86_64
ENV OPENSSL_ROOT_DIR=/usr/lib/x86_64-linux-gnu
# Download ARM toolchain
RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/${GCC_ARM_VERSION}/binrel/arm-gnu-toolchain-${GCC_ARM_VERSION}-${GCC_ARM_ARCH}-arm-none-eabi.tar.xz -O /tmp/gcc-arm.tar.xz && \
    tar -xJ -C /opt -f /tmp/gcc-arm.tar.xz && \
    rm /tmp/gcc-arm.tar.xz

FROM base-with-sdl2 AS base-arm64
ARG GCC_ARM_VERSION
ENV GCC_ARM_ARCH=aarch64
ENV OPENSSL_ROOT_DIR=/usr/lib/aarch64-linux-gnu
# Download ARM toolchain
RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/${GCC_ARM_VERSION}/binrel/arm-gnu-toolchain-${GCC_ARM_VERSION}-${GCC_ARM_ARCH}-arm-none-eabi.tar.xz -O /tmp/gcc-arm.tar.xz && \
    tar -xJ -C /opt -f /tmp/gcc-arm.tar.xz && \
    rm /tmp/gcc-arm.tar.xz

# Finishing up
ARG TARGETARCH

FROM base-${TARGETARCH} AS final

ARG GCC_ARM_VERSION
ENV PATH=/opt/arm-gnu-toolchain-${GCC_ARM_VERSION}-${GCC_ARM_ARCH}-arm-none-eabi/bin/:${PATH}
ENV ASAN_OPTIONS="detect_leaks=0"

VOLUME ["/src"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
