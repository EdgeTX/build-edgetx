ARG OS_CODENAME=jammy

FROM ghcr.io/edgetx/edgetx-qt-arm64-linux:latest AS qt-image

FROM ubuntu:${OS_CODENAME}

ARG OS_CODENAME
ARG DEBIAN_FRONTEND=noninteractive
ARG QT_VERSION=6.9.3

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Copy prebuilt Qt from the dedicated Qt image
COPY --from=qt-image /opt/qt /opt/qt

# Set up Qt environment variables
ENV QT_INSTALL_DIR=/opt/qt
ENV QT_BASE_DIR=${QT_INSTALL_DIR}/${QT_VERSION}/gcc_64
ENV PATH=${QT_BASE_DIR}/bin:$PATH
ENV QT_PLUGIN_PATH=${QT_BASE_DIR}/plugins/
ENV QML_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV QML2_IMPORT_PATH=${QT_BASE_DIR}/qml/
ENV LD_LIBRARY_PATH=${QT_BASE_DIR}/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=${QT_BASE_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH

# Verify Qt installation
RUN if [ -f "${QT_BASE_DIR}/bin/qmake" ]; then echo "Qt installed successfully"; else echo "Warning: Qt qmake not found"; fi
