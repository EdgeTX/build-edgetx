FROM ghcr.io/edgetx/edgetx-dev:2.5.1

RUN useradd --create-home --shell /bin/bash rootless
RUN mkdir -p /home/rootless/src
USER rootless
WORKDIR /home/rootless/src
