ARG OS_CODENAME=jammy
ARG QT_VERSION=6.9.3
# From https://download.qt.io/archive/qt/<major.minor>/<version>/single/md5sums.txt
ARG QT_MD5=d8fab224d072df8ffa09f99f6245e446
# NVIDIA codec headers, as used by Qt's own FFmpeg build (sdk/11.1 for 470 driver compat)
ARG NV_CODEC_TAG=n11.1.5.4
ARG NV_CODEC_COMMIT=85f332a190555b56a1d5d4c070a076c871c0dcea

FROM ubuntu:${OS_CODENAME}

ARG OS_CODENAME
ARG QT_VERSION
ARG QT_MD5
ARG NV_CODEC_TAG
ARG NV_CODEC_COMMIT
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
        # FFmpeg build (Qt Multimedia backend)
        nasm \
        patchelf \
        libva-dev \
        libdrm-dev \
        libbz2-dev \
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

# Build FFmpeg the same way the official Qt binaries do: the version, checksum
# and configure options come from Qt's own CI provisioning scripts, and
# fix_ffmpeg_dependencies.sh redirects the OpenSSL/VA-API dependencies to the
# Qt6FFmpegStub-* libraries that Qt Multimedia builds (loaded at runtime).
RUN QT_PROVISIONING=/tmp/qt-everywhere-src-${QT_VERSION}/coin/provisioning/common && \
    FFMPEG_VERSION=$(sed -n 's/.*local version="${1:-\(.*\)}".*/\1/p' ${QT_PROVISIONING}/unix/ffmpeg-installation-utils.sh) && \
    FFMPEG_SHA1=$(sed -n 's/.*local sha1="${2:-\(.*\)}".*/\1/p' ${QT_PROVISIONING}/unix/ffmpeg-installation-utils.sh) && \
    test -n "${FFMPEG_VERSION}" && test -n "${FFMPEG_SHA1}" && \
    git clone --quiet --depth 1 --branch ${NV_CODEC_TAG} https://github.com/FFmpeg/nv-codec-headers.git /tmp/nv-codec-headers && \
    test "$(git -C /tmp/nv-codec-headers rev-parse HEAD)" = "${NV_CODEC_COMMIT}" && \
    make -C /tmp/nv-codec-headers install && \
    wget -q https://github.com/FFmpeg/FFmpeg/archive/refs/tags/${FFMPEG_VERSION}.tar.gz -O /tmp/ffmpeg.tar.gz && \
    echo "${FFMPEG_SHA1}  /tmp/ffmpeg.tar.gz" | sha1sum -c - && \
    tar -xf /tmp/ffmpeg.tar.gz -C /tmp && \
    cd /tmp/FFmpeg-${FFMPEG_VERSION} && \
    ./configure $(cat ${QT_PROVISIONING}/shared/ffmpeg_config_options.txt) \
        --enable-shared --disable-static --enable-openssl --prefix=/opt/ffmpeg && \
    make -j$(nproc) && \
    make install && \
    bash ${QT_PROVISIONING}/shared/fix_ffmpeg_dependencies.sh /opt/ffmpeg && \
    cd / && rm -rf /tmp/ffmpeg.tar.gz /tmp/FFmpeg-${FFMPEG_VERSION} /tmp/nv-codec-headers

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
        # Use the FFmpeg built above and install its libs alongside Qt's
        -DFFMPEG_DIR=/opt/ffmpeg \
        -DQT_DEPLOY_FFMPEG=ON \
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
