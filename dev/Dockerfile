ARG OS_CODENAME=focal

FROM ubuntu:${OS_CODENAME}

# need to redeclare inside FROM with no value assignment
# refer https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG OS_CODENAME

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends software-properties-common gpg wget ca-certificates && \
    mkdir -p /etc/apt/keyrings && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | tee /etc/apt/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${OS_CODENAME} main" | \
    tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key 2>/dev/null | \
    gpg --dearmor - | tee /etc/apt/keyrings/nodesource.gpg >/dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list >/dev/null && \
    apt-get update && \
    apt-get install kitware-archive-keyring && \
    add-apt-repository ppa:git-core/ppa --yes --no-update && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        dumb-init \
        libfox-1.6-dev python3-clang-10 \
        libsdl2-dev \
        cmake \
        git \
        zip \
        unzip \
        file \
        python3-pip \
        python3-dev \
        gawk \
        # for font generation and cfn sorting
        nodejs \
        locales\
        # Install dfu-util and libusb
        dfu-util \
        # Install dependencies required by Qt libs
        libssl-dev \
        gstreamer1.0-plugins-base \
        # linuxdeploy-plugin-qt requires libxcb1 and supporting libs
        awesome && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Generate locales for cfn sorting and install lv_font_conv
RUN locale-gen zh_CN.UTF-8 cs_CZ.UTF-8 da_DK.UTF-8 de_DE.UTF-8 es_ES.UTF-8 \
               en_US.UTF-8 fi_FI.UTF-8 fr_FR.UTF-8 he_IL.UTF-8 it_IT.UTF-8 \
               ja_JP.UTF-8 ko_KR.UTF-8 nl_NL.UTF-8 pl_PL.UTF-8 pt_PT.UTF-8 \
               ru_RU.UTF-8 sv_SE.UTF-8 zh_TW.UTF-8 uk_UA.UTF-8 && \
    npm i lv_font_conv -g

RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install \
    asciitree \
    jinja2 \
    pillow==7.2.0 \
    aqtinstall \
    lz4 \
    pyelftools

# Qt installation adapted from
# see https://github.com/miurahr/aqtinstall/
# see https://github.com/vslotman/docker-aqtinstall

ARG QT_VERSION=5.15.2
# if modules use syntax -m MODULE [MODULE]
ARG QT_MODULES=
# supported versions of dependencies
ARG QT_HOST=linux
ARG QT_TARGET=desktop
ARG QT_INSTALL_DIR=/opt/qt
ARG QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64

# cmd 1 installs Qt dev
# cmd 2 Workaround for "libQt5Core.so.5 not found" issue
#		see https://www.gitmemory.com/issue/Microsoft/WSL/3023/488329451

RUN aqt install-qt --outputdir ${QT_INSTALL_DIR} ${QT_HOST} ${QT_TARGET} ${QT_VERSION} ${QT_ARCH} ${QT_MODULES} && \
	strip --remove-section=.note.ABI-tag ${QT_BASE_DIR}/lib/libQt5Core.so.${QT_VERSION}

ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi.tar.xz -O - \
        | tar -xJ -C /opt

ENV PATH=/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin/:${PATH}

VOLUME ["/src"]

ENV ASAN_OPTIONS="detect_leaks=0"

# HINTS for cmake find_package
ENV LIBUSB1_ROOT_DIR=/usr/lib/x86_64-linux-gnu
ENV LIBSSL1_ROOT_DIR=/usr/lib/x86_64-linux-gnu

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
