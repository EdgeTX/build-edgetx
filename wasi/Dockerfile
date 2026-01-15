ARG WASI_SDK_RELEASE=25

FROM ghcr.io/webassembly/wasi-sdk:wasi-sdk-${WASI_SDK_RELEASE}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        ca-certificates \
        build-essential \
        dumb-init \
        libclang-dev \
        cmake \
        git \
        zip \
        unzip \
        file \
        python3-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Python packages installation
COPY --from=ghcr.io/astral-sh/uv:0.8.24 /uv /uvx /bin/
ENV VIRTUAL_ENV=/opt/venv
RUN uv venv \
        --python-preference system --no-python-downloads \
        ${VIRTUAL_ENV} && \
    uv pip install --no-cache \
        asciitree \
        clang \
        jinja2 \
        pillow \
        lz4 \
        pydantic
# Add venv to PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

VOLUME ["/src"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
