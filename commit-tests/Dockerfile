FROM ghcr.io/raphaelcoeffic/opentx-dev

ENV ASAN_OPTIONS=detect_leaks=0

#
# Set the variables manually as Github Actions are overloading the entrypoint
#
ENV LD_LIBRARY_PATH=/opt/qt${QT_BASE}/lib/x86_64-linux-gnu:/opt/qt${QT_BASE}/lib
ENV PATH=/opt/qt${QT_BASE}/bin:${PATH}
ENV PKG_CONFIG_PATH=/opt/qt${QT_BASE}/lib/pkgconfig

WORKDIR /src
CMD /src/tools/commit-tests.sh
