ARG OS_CODENAME=bionic

FROM ubuntu:${OS_CODENAME}

# need to redeclare inside FROM with no value assignment
# refer https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG OS_CODENAME

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends software-properties-common gpg wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${OS_CODENAME} main" | \
    tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    add-apt-repository ppa:git-core/ppa --yes && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        dumb-init \
        libfox-1.6-dev python3-clang-10 \
        libsdl1.2-dev libsdl2-dev \
        cmake \
        git \
        zip \
        unzip \
        file \
        python3-pip \
        gawk \
        # Install some dependencies required by Qt libs
        libxkbcommon-x11-0 gstreamer1.0-plugins-base && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install \
    asciitree \
    jinja2 \
    pillow==7.2.0 \
    aqtinstall \
    lz4

# Qt installation adapted from
# see https://github.com/miurahr/aqtinstall/
# see https://github.com/vslotman/docker-aqtinstall

ARG QT_VERSION=5.12.9
# if modules use syntax -m MODULE [MODULE]
ARG QT_MODULES=
# supported versions of dependencies
ARG QT_TOOLS=
ARG QT_HOST=linux
ARG QT_TARGET=desktop
ARG QT_INSTALL_DIR=/opt/qt
ARG QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64

# cmd 1 installs Qt dev
# cmd 2 installs tools to individual directories under ${QT_INSTALL_DIR}/Tools
# cmd 3 Workaround for "libQt5Core.so.5 not found" issue
#		see https://www.gitmemory.com/issue/Microsoft/WSL/3023/488329451

RUN aqt install-qt --outputdir ${QT_INSTALL_DIR} ${QT_HOST} ${QT_TARGET} ${QT_VERSION} ${QT_ARCH} ${QT_MODULES} && \
	aqt install-tool --outputdir ${QT_INSTALL_DIR} ${QT_HOST} ${QT_TARGET} ${QT_TOOLS} && \
	strip --remove-section=.note.ABI-tag ${QT_BASE_DIR}/lib/libQt5Core.so.${QT_VERSION}

ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -O - \
        | tar -xj -C /opt

ENV PATH=/opt/gcc-arm-none-eabi-10-2020-q4-major/bin/:${PATH}

VOLUME ["/src"]

ENV ASAN_OPTIONS="detect_leaks=0"

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
