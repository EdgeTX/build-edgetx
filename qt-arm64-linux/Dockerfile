ARG OS_CODENAME=jammy
ARG QT_VERSION=6.9.3

FROM ubuntu:${OS_CODENAME}

ARG OS_CODENAME
ARG QT_VERSION
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install build dependencies for QT 6
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        git \
        wget \
        ca-certificates \
        pkg-config \
        libssl-dev \
        libvulkan-dev \
        libdbus-1-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libx11-dev \
        libx11-xcb-dev \
        libxcb-cursor0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-randr0 \
        libxcb-render0 \
        libxcb-shape0 \
        libxcb-xfixes0 \
        libxcb-sync-dev \
        libxcb-xinerama0-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libharfbuzz-dev \
        libpng-dev \
        libjpeg-dev \
        libpulse-dev \
        libasound2-dev \
        libavformat-dev \
        libavcodec-dev \
        libswresample-dev \
        gstreamer1.0-dev \
        gstreamer1.0-tools \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libopenal-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and build Qt with BuildKit cache mount for build artifacts
RUN --mount=type=cache,target=/tmp/qt-build \
    mkdir -p /tmp/qt-build && \
    cd /tmp/qt-build && \
    if [ ! -d qt-everywhere-src-${QT_VERSION} ]; then \
        wget -q https://download.qt.io/official_releases/qt/6.9/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz && \
        tar -xf qt-everywhere-src-${QT_VERSION}.tar.xz; \
    fi && \
    cd qt-everywhere-src-${QT_VERSION} && \
    ./configure \
        -prefix /opt/qt \
        -release \
        -shared \
        -nomake examples \
        -nomake tests \
        -skip qtwebengine \
        -skip qtwebview \
        -skip qttools \
        -skip qtdoc \
        -skip qtlocation \
        -skip qtsensors \
        -skip qtconnectivity \
        -skip qtpositioning \
        -skip qtvirtualkeyboard \
        -skip qttranslations \
        -skip qtdocumentation \
        -DFEATURE_dbus=OFF \
        -opensource -confirm-license && \
    cmake --build . --parallel $(nproc) && \
    cmake --install .

# Set up Qt environment for runtime use
ENV QT_INSTALL_DIR=/opt/qt
ENV QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64
ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH
