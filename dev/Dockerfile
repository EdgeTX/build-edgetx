FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
        apt-get install --yes \
        software-properties-common \
        build-essential cmake \
        libfox-1.6-dev libclang-6.0-dev

RUN add-apt-repository ppa:beineri/opt-qt-5.11.3-bionic --yes && \
        add-apt-repository ppa:git-core/ppa --yes && \
        apt-get update -qq && \
        apt-get install --yes -qq \
        git wget zip unzip \
        python3-pip

ENV QT_BASE=511

RUN apt-get install --yes -qq \
        qt${QT_BASE}base qt${QT_BASE}multimedia qt${QT_BASE}svg qt${QT_BASE}tools && \
        /opt/qt${QT_BASE}/bin/qt${QT_BASE}-env.sh

RUN apt-get install --yes && \
        python3 -m pip install \
        asciitree jinja2 \
        pillow==7.2.0 \
        clang==6.0.0

RUN wget --quiet https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -O - \
        | tar -xj -C /opt

ENV PATH=/opt/gcc-arm-none-eabi-10-2020-q4-major/bin/:${PATH}

# Workaround for "libQt5Core.so.5 not found" issue
# see https://www.gitmemory.com/issue/Microsoft/WSL/3023/488329451
RUN strip --remove-section=.note.ABI-tag /opt/qt511/lib/libQt5Core.so.5.11.3

VOLUME ["/src"]

COPY entrypoint.sh /opt

ENTRYPOINT ["/opt/entrypoint.sh"]
