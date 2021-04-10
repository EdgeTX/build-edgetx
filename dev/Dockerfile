FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
        apt-get install --yes \
        software-properties-common \
        build-essential cmake git \
        libfox-1.6-dev clang-10

RUN add-apt-repository ppa:beineri/opt-qt-5.11.3-bionic --yes && \
        apt-get update -qq

ENV QT_BASE=511

RUN apt-get install --yes -qq \
        qt${QT_BASE}base qt${QT_BASE}multimedia qt${QT_BASE}svg qt${QT_BASE}tools && \
        /opt/qt${QT_BASE}/bin/qt${QT_BASE}-env.sh

RUN apt-get install --yes python3-pip && \
        python3 -m pip install pillow clang

RUN apt-get install --yes wget zip unzip && \
        wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 -O - \
        | tar -xj -C /opt

ENV PATH=/opt/gcc-arm-none-eabi-6-2017-q2-update/bin/:${PATH}

# Workaround for "libQt5Core.so.5 not found" issue
# see https://www.gitmemory.com/issue/Microsoft/WSL/3023/488329451
RUN strip --remove-section=.note.ABI-tag /opt/qt511/lib/libQt5Core.so.5.11.3

VOLUME ["/src"]
