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

### edgetx-builder

The `edgetx-builder` image is meant to be used in [cloudbuild](https://github.com/EdgeTX/cloudbuild) project. It favours
rootless user by default, other than that it is exactly the same as `edgetx-dev`.

## Docker repositories

The `edgetx-dev` and `edgetx-builder` image are hosted at Docker hub & Github Container Repository for your convenience.

Pulling from Github Container Repository with this command:

```
% docker pull ghcr.io/edgetx/edgetx-dev
% docker pull ghcr.io/edgetx/edgetx-builder
```

# References

https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-using-docker-and-Windows-10
