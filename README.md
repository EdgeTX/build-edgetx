# Docker images to build EdgeTX

[![Docker Image CI](https://github.com/EdgeTX/build-edgetx/actions/workflows/docker-image.yml/badge.svg)](https://github.com/EdgeTX/build-edgetx/actions/workflows/docker-image.yml)

## How to use

In order to build each image, just `cd` into the directory and execute `make`:
```
% cd dev && make
% cd commit-tests && make
```

### edgetx-dev

The `edgetx-dev` image is meant to be used in interactive mode:
```
% cd ~/src/edgetx
% docker run -it --rm -v $(pwd):/src ghcr.io/edgetx/edgetx-dev bash
root@02157a542d21:/# cd /src
```

Then you can just do whatever you need to do with your EdgeTX source tree (compile, test, whatever).

### edgetx-commit-tests

The `edgetx-commit-tests` image is meant to be run with specific `FLAVOR`, so you can if the commit tests on Travis would likely pass on github:
```
% docker run -it --rm -v $(pwd):/src -e FLAVOR=COLORLCD ghcr.io/edgetx/edgetx-commit-tests
```

You can however run them all by using (beware, this is going to be a very long run):
```
% docker run -it --rm -v $(pwd):/src -e FLAVOR=ALL ghcr.io/edgetx/edgetx-commit-tests
```


## Docker repositories

The `edgetx-dev` and `edgetx-commit-tests` image are hosted at Docker hub & Github Container Repository for your convenience.

Pulling from Github Container Repository with this command:
```
% docker pull ghcr.io/edgetx/edgetx-dev
% docker pull ghcr.io/edgetx/edgetx-commit-tests
```
