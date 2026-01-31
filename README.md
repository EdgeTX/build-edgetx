# Docker images to build EdgeTX

[![Docker Image CI](https://github.com/EdgeTX/build-edgetx/actions/workflows/docker-image.yml/badge.svg)](https://github.com/EdgeTX/build-edgetx/actions/workflows/docker-image.yml)

This repository contains Dockerfiles for container images that provide
consistent isolated environments for building EdgeTX firmwares.
It is a potentially easier alternative to setting up the build environments
natively on the host operating system using instructions
at https://github.com/EdgeTX/edgetx/wiki.

## edgetx-dev

The `edgetx-dev` image is intended as build environment for local
firmware builds. It is meant to be used in interactive mode together
with the EdgeTX sources.

Assuming you have a clone checkout of the https://github.com/EdgeTX/edgetx
repository or its fork in `~/src/edgetx`, you can build the `edgetx-dev`
image locally
```
% make edgetx-dev
```

and then run the container with the EdgeTX sources mounted
```
% docker run -it --rm -w /src -v ~/src/edgetx:/src edgetx-dev bash
```

On an SELinux-enabled system, you may need to add
`--security-opt label=disable` argument to `docker run` to give the
container access to your home directory.

On the container shell prompt like
```
root@64e263539532:/src#
```
you can then just do whatever you need to do with your EdgeTX source
tree (checkout the desired branch, compile, test).

If unsure, start with the instructions at
https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-using-docker-and-Windows-10
or https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-22.04.

You can skip the step of building the container image and instead use
the image built from this repository, stored in the GitHub
Container Registry:
```
% docker run -it --rm -w /src -v ~/src/edgetx:/src ghcr.io/edgetx/edgetx-dev bash
```

## edgetx-builder

The `edgetx-builder` image is meant to be used in
[cloudbuild](https://github.com/EdgeTX/cloudbuild) project. It favours
rootless user by default, other than that it is exactly the same
as `edgetx-dev`.

You can build it locally using
```
% make edgetx-builder
```
or just use `ghcr.io/edgetx/edgetx-builder`.

## References

- https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-22.04
- https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-using-docker-and-Windows-10
