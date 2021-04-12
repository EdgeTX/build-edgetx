# Docker images to build OpenTX 2.4

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

The `opentx-dev` image is meant to be run in full, so you can if the commit tests on Travis would likely pass on github:
```
% docker run -it --rm -v /Users/rco/Src/taranis/opentx:/src opentx-commit-tests
```

## Docker hub repository

The dev image is also hosted at Docker hub for your convenience.
