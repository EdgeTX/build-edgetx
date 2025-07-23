ARG OS_CODENAME=jammy

FROM ubuntu:${OS_CODENAME}

# Redeclare ARGs after FROM
ARG OS_CODENAME
ARG DEBIAN_FRONTEND=noninteractive
ARG QT_VERSION=5.15.2
ARG QT_MODULES=
ARG QT_HOST=linux
ARG QT_TARGET=desktop
ARG QT_INSTALL_DIR=/opt/qt
ARG GCC_ARM_VERSION=14.2.rel1
ARG NODE_VERSION=20.x

# Setup package repositories and install all dependencies in a single layer
RUN apt-get update && \
    apt-get install --yes --no-install-recommends software-properties-common gpg gpg-agent wget ca-certificates && \
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
    # Install all required packages
    apt-get update && \
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
        # Install dfu-util and libusb
        dfu-util \
        # For font generation and cfn sorting
        nodejs \
        locales \
        # Install dependencies required by Qt libs
        libssl-dev \
        gstreamer1.0-plugins-base \
        # linuxdeploy-plugin-qt requires libxcb1 and supporting libs
        awesome && \
    # Generate all required locales
    locale-gen zh_CN.UTF-8 cs_CZ.UTF-8 da_DK.UTF-8 de_DE.UTF-8 es_ES.UTF-8 \
               en_US.UTF-8 fi_FI.UTF-8 fr_FR.UTF-8 he_IL.UTF-8 it_IT.UTF-8 \
               ja_JP.UTF-8 ko_KR.UTF-8 nl_NL.UTF-8 pl_PL.UTF-8 pt_PT.UTF-8 \
               ru_RU.UTF-8 sv_SE.UTF-8 zh_TW.UTF-8 uk_UA.UTF-8 && \
    # Install global npm package
    npm i lv_font_conv -g && \
    # Set up Rob Savoury's PPA for newer SDL2
    add-apt-repository ppa:savoury1/multimedia --yes && \
    apt-get install --yes --no-install-recommends libsdl2-dev  && \
    # Clean up
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

# Install Qt - adapted from
# https://github.com/miurahr/aqtinstall/
# https://github.com/vslotman/docker-aqtinstall
ENV QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64
ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH

RUN uvx --no-cache aqtinstall install-qt --outputdir ${QT_INSTALL_DIR} ${QT_HOST} ${QT_TARGET} ${QT_VERSION} ${QT_ARCH} ${QT_MODULES} && \
    strip --remove-section=.note.ABI-tag ${QT_BASE_DIR}/lib/libQt5Core.so.${QT_VERSION}

# Install ARM toolchain
RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/${GCC_ARM_VERSION}/binrel/arm-gnu-toolchain-${GCC_ARM_VERSION}-x86_64-arm-none-eabi.tar.xz -O - \
    | tar -xJ -C /opt

ENV PATH=/opt/arm-gnu-toolchain-${GCC_ARM_VERSION}-x86_64-arm-none-eabi/bin/:${PATH}
ENV ASAN_OPTIONS="detect_leaks=0"
# HINTS for cmake find_package
ENV LIBUSB1_ROOT_DIR=/usr/lib/x86_64-linux-gnu
ENV LIBSSL1_ROOT_DIR=/usr/lib/x86_64-linux-gnu

VOLUME ["/src"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
