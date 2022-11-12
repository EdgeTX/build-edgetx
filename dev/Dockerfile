ARG OS_CODENAME=bionic
ARG QT_VERSION=5.12.11

#
# Architecture independent
#
FROM ubuntu:${OS_CODENAME} AS base

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
        libfox-1.6-dev libclang-6.0-dev libsdl1.2-dev \
        cmake \
        git \
        zip \
        unzip \
        file \
        # arm64 requires python3-dev to be installed
        python3-pip python3-dev \
        # Install some dependencies required by Qt libs
        libxkbcommon-x11-0 gstreamer1.0-plugins-base && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install \
    asciitree \
    jinja2 \
    pillow==7.2.0 \
    clang==6.0.0 \
    lz4

# Values for next stages
ARG TARGETOS
ARG TARGETARCH

#
# amd64 specific definitions
#
FROM base AS base-amd64
ENV ARM_GCC_ARCH="x86_64"

#
# arm64 specific definitions
#
FROM base AS base-arm64
ENV ARM_GCC_ARCH="aarch64"

#
# Architecture independent
#
# Qt dev image with pre-compiled Qt
FROM carlonluca/qt-dev:${QT_VERSION} AS qt-dev
#
#
FROM base-${TARGETARCH} AS final

ARG QT_VERSION
ARG QT_BASE_DIR=/opt/qt/${QT_VERSION}

ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH

RUN mkdir -p ${QT_BASE_DIR}
COPY --from=qt-dev /opt/Qt-${TARGETARCH}-${QT_VERSION} ${QT_BASE_DIR}

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-${ARM_GCC_ARCH}-linux.tar.bz2 -O - \
        | tar -xj -C /opt

ENV PATH=/opt/gcc-arm-none-eabi-10-2020-q4-major/bin/:${PATH}

VOLUME ["/src"]

ENV ASAN_OPTIONS="detect_leaks=0"

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
