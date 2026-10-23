ARG OS_CODENAME=jammy
ARG QT_VERSION=6.9.3
# From https://download.qt.io/archive/qt/<major.minor>/<version>/single/md5sums.txt
ARG QT_MD5=d8fab224d072df8ffa09f99f6245e446

FROM ubuntu:${OS_CODENAME}

ARG OS_CODENAME
ARG QT_VERSION
ARG QT_MD5
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        # Build tools
        build-essential \
        cmake \
        ninja-build \
        git \
        wget \
        ca-certificates \
        pkg-config \
        python3 \
        perl \
        # Qt core dependencies
        libssl-dev \
        libdbus-1-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libharfbuzz-dev \
        libpng-dev \
        libjpeg-dev \
        libzstd-dev \
        libdouble-conversion-dev \
        libpcre2-dev \
        libicu-dev \
        zlib1g-dev \
        # Qt XCB/X11 platform plugin (Widgets)
        libx11-dev \
        libx11-xcb-dev \
        libxext-dev \
        libxrandr-dev \
        libxfixes-dev \
        libxi-dev \
        libxcb-cursor-dev \
        libxcb-glx0-dev \
        libxcb-icccm4-dev \
        libxcb-image0-dev \
        libxcb-keysyms1-dev \
        libxcb-randr0-dev \
        libxcb-render0-dev \
        libxcb-render-util0-dev \
        libxcb-shape0-dev \
        libxcb-shm0-dev \
        libxcb-sync-dev \
        libxcb-util-dev \
        libxcb-xfixes0-dev \
        libxcb-xinerama0-dev \
        libxcb-xkb-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        libgl1-mesa-dev \
        libvulkan-dev \
        # Qt Wayland platform plugin
        libwayland-dev \
        # Qt GTK3 platform theme
        libgtk-3-dev \
        # Qt Multimedia (audio for voice packs/beeps)
        libpulse-dev \
        libasound2-dev \
        libavformat-dev \
        libavcodec-dev \
        libavdevice-dev \
        libswresample-dev \
        libswscale-dev \
        # Qt SerialPort
        libudev-dev \
        # Qt PrintSupport
        libcups2-dev \
        # Qt Svg / Xml - no extra system deps needed \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download Qt source as a separate layer so it can be cached independently
RUN wget -q https://download.qt.io/archive/qt/${QT_VERSION%.*}/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz \
        -O /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz && \
    echo "${QT_MD5}  /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz" | md5sum -c - && \
    tar -xf /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz -C /tmp && \
    rm /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz

RUN mkdir -p /tmp/qt-build && \
    cd /tmp/qt-build && \
    cmake /tmp/qt-everywhere-src-${QT_VERSION} \
        -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/qt/${QT_VERSION}/gcc_64 \
        -DQT_BUILD_EXAMPLES=OFF \
        -DQT_BUILD_TESTS=OFF \
        # Match the module set of the official aqt linux_gcc_64 install (base +
        # qtmultimedia + qtserialport). qtshadertools is a build-time dependency
        # of qtmultimedia; qtlanguageserver provides qmlls.
        -DQT_BUILD_SUBMODULES="qtbase;qtshadertools;qtdeclarative;qtlanguageserver;qtsvg;qttools;qttranslations;qtwayland;qtmultimedia;qtserialport" \
        # Optional dependencies that QT_BUILD_SUBMODULES would otherwise pull in
        -DBUILD_qtactiveqt=OFF \
        -DBUILD_qtimageformats=OFF \
        -DBUILD_qtquick3d=OFF \
        -DBUILD_qtquicktimeline=OFF \
        -DFEATURE_dbus=ON \
        -DFEATURE_opengl=ON \
        -DFEATURE_xcb=ON \
        -DFEATURE_xcb_xlib=ON \
        -DFEATURE_xkbcommon=ON \
        -DFEATURE_gtk3=ON \
        -DFEATURE_wayland_client=ON \
        -DFEATURE_wayland_server=OFF \
        -DFEATURE_ffmpeg=ON \
        -DFEATURE_pulseaudio=ON \
        -DFEATURE_gstreamer=OFF \
        -DFEATURE_cups=ON \
        -DFEATURE_printer=ON && \
    cmake --build . --parallel $(nproc) && \
    cmake --install . && \
    rm -rf /tmp/qt-build /tmp/qt-everywhere-src-${QT_VERSION}

ENV QT_INSTALL_DIR=/opt/qt
ENV QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64
ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig
