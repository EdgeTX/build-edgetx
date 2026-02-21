ARG OS_CODENAME=jammy
ARG QT_VERSION=6.9.3

FROM ubuntu:${OS_CODENAME}

ARG OS_CODENAME
ARG QT_VERSION
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
        libxcb-cursor-dev \
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
RUN wget -q https://download.qt.io/official_releases/qt/6.9/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz \
        -O /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz && \
    tar -xf /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz -C /tmp && \
    rm /tmp/qt-everywhere-src-${QT_VERSION}.tar.xz

RUN mkdir -p /tmp/qt-build && \
    cd /tmp/qt-build && \
    cmake /tmp/qt-everywhere-src-${QT_VERSION} \
        -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/qt \
        -DQT_BUILD_EXAMPLES=OFF \
        -DQT_BUILD_TESTS=OFF \
        -DBUILD_ONLY_NEEDED=ON \
        -DBUILD_qtbase=ON \
        -DBUILD_qtmultimedia=ON \
        -DBUILD_qtserialport=ON \
        -DBUILD_qtsvg=ON \
        -DBUILD_qttools=ON \
        -DBUILD_qtshadertools=ON \
        -DBUILD_qtxmlpatterns=OFF \
        -DFEATURE_dbus=ON \
        -DFEATURE_opengl=ON \
        -DFEATURE_xcb=ON \
        -DFEATURE_xcb_xlib=ON \
        -DFEATURE_xkbcommon=ON \
        -DFEATURE_ffmpeg=ON \
        -DFEATURE_pulseaudio=ON \
        -DFEATURE_gstreamer=OFF \
        -DFEATURE_vulkan=OFF \
        -DFEATURE_wayland=OFF \
        -DFEATURE_cups=ON \
        -DFEATURE_printer=ON \
        -DBUILD_qtwebengine=OFF \
        -DBUILD_qtwebview=OFF \
        -DBUILD_qtlocation=OFF \
        -DBUILD_qtsensors=OFF \
        -DBUILD_qtconnectivity=OFF \
        -DBUILD_qtpositioning=OFF \
        -DBUILD_qtvirtualkeyboard=OFF \
        -DBUILD_qttranslations=OFF \
        -DBUILD_qtdoc=OFF \
        -DBUILD_qt3d=OFF \
        -DBUILD_qtcharts=OFF \
        -DBUILD_qtcoap=OFF \
        -DBUILD_qtdatavis3d=OFF \
        -DBUILD_qtlottie=OFF \
        -DBUILD_qtmqtt=OFF \
        -DBUILD_qtnetworkauth=OFF \
        -DBUILD_qtopcua=OFF \
        -DBUILD_qtquick3d=OFF \
        -DBUILD_qtquick3dphysics=OFF \
        -DBUILD_qtquicktimeline=OFF \
        -DBUILD_qtremoteobjects=OFF \
        -DBUILD_qtscxml=OFF \
        -DBUILD_qtspeech=OFF \
        -DBUILD_qtwaylandcompositor=OFF && \
    cmake --build . --parallel $(nproc) && \
    cmake --install . && \
    rm -rf /tmp/qt-build /tmp/qt-everywhere-src-${QT_VERSION}

ENV QT_INSTALL_DIR=/opt/qt
ENV PATH=${QT_INSTALL_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_INSTALL_DIR}/plugins
ENV QML_IMPORT_PATH=${QT_INSTALL_DIR}/qml
ENV QML2_IMPORT_PATH=${QT_INSTALL_DIR}/qml
ENV LD_LIBRARY_PATH=${QT_INSTALL_DIR}/lib
ENV PKG_CONFIG_PATH=${QT_INSTALL_DIR}/lib/pkgconfig
