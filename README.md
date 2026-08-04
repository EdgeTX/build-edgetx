# Docker images to build EdgeTX

[![Docker Image CI](https://github.com/EdgeTX/build-edgetx/actions/workflows/docker-image.yml/badge.svg)](https://github.com/EdgeTX/build-edgetx/actions/workflows/docker-image.yml)

This repository contains Dockerfiles for container images that provide consistent isolated environments for building EdgeTX firmwares. It is a potentially easier alternative to setting up the build environments natively on the host operating system using instructions at https://github.com/EdgeTX/edgetx/wiki.

## edgetx-dev

The `edgetx-dev` image is intended as build environment for local firmware builds. It is meant to be used in interactive mode together with the EdgeTX sources.

Assuming you have a clone checkout of the https://github.com/EdgeTX/edgetx repository or its fork in `~/src/edgetx`, you can build the `edgetx-dev` image locally
```
% make edgetx-dev
```

and then run the container with the EdgeTX sources mounted
```
% docker run -it --rm -w /src -v ~/src/edgetx:/src edgetx-dev bash
```

On an SELinux-enabled system, you may need to add `--security-opt label=disable` argument to `docker run` to give the container access to your home directory.

On the container shell prompt like
```
root@64e263539532:/src#
```
you can then just do whatever you need to do with your EdgeTX source tree (checkout the desired branch, compile, test).

If unsure, start with the instructions at https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-using-docker-and-Windows-10 or https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-22.04.

You can skip the step of building the container image and instead use the image built from this repository, stored in the GitHub Container Registry:
```
% docker run -it --rm -w /src -v ~/src/edgetx:/src ghcr.io/edgetx/edgetx-dev bash
```

## edgetx-builder

The `edgetx-builder` image is meant to be used in [cloudbuild](https://github.com/EdgeTX/cloudbuild) project. It is likely of little use if you want to do local builds.

If you have a need for the image, you can build it locally using
```
% make edgetx-builder
```
or just use `ghcr.io/edgetx/edgetx-builder`.

## edgetx-wasi

The `edgetx-wasi` image is meant to be used for building platform agnostic Companion simulator plugins. This functionality is still a work in progress.

You can build it locally using
```
% make edgetx-wasi
```
or just use `ghcr.io/edgetx/edgetx-wasi`.

## Troubleshooting

### `NO_PUBKEY` / "repository is not signed" errors from apt.kitware.com

If you run `apt update` inside an `edgetx-dev` (or `edgetx-builder`/`edgetx-wasi`) container
and see something like:

```
W: GPG error: https://apt.kitware.com/ubuntu <codename> InRelease: The following signatures
   couldn't be verified because the public key is not available: NO_PUBKEY ...
E: The repository 'https://apt.kitware.com/ubuntu <codename> InRelease' is not signed.
```

these images bake in Kitware's apt signing key at build time, and nothing refreshes it
afterwards. Two things can make an older image's copy go stale: Kitware periodically
rotates/reissues their signing key upstream, so any image built before a rotation will be
missing the new key; and separately, the exact keyring path has changed across versions of
this repo, so an older pulled/tagged image can end up with
`/etc/apt/sources.list.d/kitware.list` pointing at a path nothing keeps current. Either way,
apt reports it the same way: a missing key.

**Preferred fix**, if you don't need a specific pinned version: pull or rebuild a fresh image
(`docker pull ghcr.io/edgetx/edgetx-dev` or `make edgetx-dev`) — a new build always writes a
matching key and path together. If you're intentionally on an older tag (e.g. building
against an older EdgeTX release), a newer image may not be an option.

**One-off fix**, without rebuilding, run inside the container (it runs as root by default, so
no `sudo` needed):
```
KEYRING=$(grep -oP '(?<=signed-by=)[^]]+' /etc/apt/sources.list.d/kitware.list) && mkdir -p "$(dirname "$KEYRING")" && wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor | tee "$KEYRING" >/dev/null
```
This reads the keyring path your container's `kitware.list` actually references and writes
the current Kitware key there, rather than assuming a fixed path.

## References

- https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-22.04
- https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-using-docker-and-Windows-10
