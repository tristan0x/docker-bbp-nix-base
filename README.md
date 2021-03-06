# Blue Brain Project Nix base Docker image

This repository provides:
1. a Docker recipe to build a minimalist NIX image based on Ubuntu 16.04,
  located in the [base](./base) directory.
1. a Docker recipe to build images containing Blue Brain HPC software stack
  base on the previous image, located in the [build](./build) directory.

## Installation prerequisites

* Docker 17.06 or higher with experimental mode enabled.
* GNU Make

## How to use this repository

### Prepare your environment

Use the `./bootstrap` script to setup proper settings. Type `./bootstrap --help` for more details.

### Makefile targets

A Makefile allows you to build desired Docker images. Available targets:

* `base`: Build `bbp/nix-base` base Docker image
* `build.<expr>`: Build the dedicated Docker image with NIX expression `<expr>` shipped inside the image. for instance: `pkg.functionalizer`
* `push.<expr>`: Push to Docker Hub the Docker image associated with the NIX expression.

### Makefile environment variables

Some environment variables can be specified to override location of some executables:

* `DOCKER`
* `CURL`
* `SED`
* `SHA256SUM`

Additional environment variables can be specified to control behavior:

* `DBFLAGS`, used to add arguments to *docker build* commands.
  For instance: `DBFLAGS=--no-cache make build.touchdetector`

# LICENSE

MIT License. See [LICENSE](./LICENSE) file for more information.
