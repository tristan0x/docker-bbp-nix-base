# Blue Brain Project Nix base Docker image

This repositories provides:
* the docker recipe to build a minimalist Fedora Docker image with NIX installed,
  located in the [base](./base) directory.
* the Docker recipe to build Docker images containing Blue Brain HPC software stack,
  located in the [package](./package) directory.

## Installation prerequisites

* Docker 17.06 or higher with experimental mode enabled.
* GNU Make

## How to use this repository

### Prepare your environment

Use the `./bootstrap` script to setup proper settings. Type `./bootstrap --help` for more details.

### Makefile targets

A Makefile allows you to build desired Docker images:

* `base`: Build `bbp/nix-base` base Docker image
* `pkg.<expr>`: Build the dedicated Docker image with NIX expression `<expr>` shipped inside the image. for instance: `make pkg.functionalizer`
* `push.<expr>`: Push to Docker Hub the Docker image associated to the NIX expression.

# LICENSE

MIT License. See [LICENSE](./LICENSE) file for more information.
