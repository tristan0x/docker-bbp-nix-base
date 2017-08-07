# Blue Brain Project Nix base Docker image

This repository provides:
* a Docker recipe to build a minimalist NIX image based on Fedora,
  located in the [base](./base) directory.
* a Docker recipe to build images containing Blue Brain HPC software stack base on
  the previous image, located in the [package](./package) directory.

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

You can specify the following environment variables to customize executed commands:

* `DOCKER`, path to *docker_ executable. default is "docker"
* `DBFLAGS`, used to add arguments to *docker build* commands.
  For instance: `DBFLAGS=--no-cache make base`
* `DTAG`, used to customize the tag version of Docker images built
  by the `pkg.<expr>` make targets.

# LICENSE

MIT License. See [LICENSE](./LICENSE) file for more information.
