# Docker images to build OpenTX 2.4

[![Docker Image CI](https://github.com/raphaelcoeffic/build-opentx/actions/workflows/docker-image.yml/badge.svg)](https://github.com/raphaelcoeffic/build-opentx/actions/workflows/docker-image.yml)

## How to use

In order to build each image, just `cd` into the directory and execute `make`:
```
% cd dev && make
% cd commit-tests && make
```

### opentx-dev

The `opentx-dev` image is meant to be used in interactive mode:
```
% cd ~/src/opentx
% docker run -it --rm -v $(pwd):/src opentx-dev bash
root@02157a542d21:/# cd /src
```

Then you can just do whatever you need to do with your OpenTX source tree (compile, test, whatever).

### opentx-commit-tests

The `opentx-dev` image is meant to be run with specific `FLAVOR`, so you can if the commit tests on Travis would likely pass on github:
```
% docker run -it --rm -v $(pwd):/src -e FLAVOR=COLORLCD opentx-commit-tests
```

You can however run them all by using (beware, this is going to be a very long run):
```
% docker run -it --rm -v $(pwd):/src -e FLAVOR=ALL opentx-commit-tests
```


## Docker repositories

The `opentx-dev` and `opentx-commit-tests` image are hosted at Docker hub & Github Container Repository for your convenience.

Pulling from Docker hub is as simple as:
```
% docker pull pafleraf/opentx-dev
% docker pull pafleraf/opentx-commit-tests
```

Pulling from Github Container Repository uses a slightly longer command:
```
% docker pull ghcr.io/raphaelcoeffic/opentx-dev
% docker pull ghcr.io/raphaelcoeffic/opentx-commit-tests
```
