FROM ubuntu:16.04
LABEL maintainer "Tristan CAREL <tristan.carel@epfl.ch>"

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    bzip2 \
    curl \
    git \
    hostname \
    libncurses5-dev \
    libreadline-dev \
    man \
    nano \
    openssh-client \
    patchelf \
    sudo \
    vim \
 && mkdir -m 755 /etc/nix \
 && echo "build-users-group =" > /etc/nix/nix.conf \
 && curl https://nixos.org/nix/install | USER=root sh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Prepare Nix environment
ADD files/nix-do /usr/bin/
ADD files/bashrc /root/.bashrc

ARG NIX_CHANNEL_URL="https://bbpobjectstorage.epfl.ch/nix-channel"

RUN nix-do nix-channel --add $NIX_CHANNEL_URL bbp-pkgs \
 && nix-do nix-channel --update

ENV PATH="/root/.nix-profile/bin:$PATH"
