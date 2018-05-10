FROM ubuntu:16.04
LABEL maintainer "Tristan CAREL <tristan.carel@epfl.ch>"


ENV HTTP_PROXY='http://bbpproxy.epfl.ch:80/'
ENV HTTPS_PROXY='http://bbpproxy.epfl.ch:80/'
ENV http_proxy='http://bbpproxy.epfl.ch:80/'
ENV https_proxy='http://bbpproxy.epfl.ch:80/'

ARG NIX_VERSION=1.11.16

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    bzip2 \
    curl \
    git \
    hostname \
    libncurses5-dev \
    libreadline-dev \
    lmod \
    man \
    nano \
    openssh-client \
    patchelf \
    sudo \
    tcl \
    vim \
 && mkdir -m 755 /etc/nix \
 && echo "build-users-group =" > /etc/nix/nix.conf \
 && cd /tmp \
 && curl https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.bz2 | \
    tar jx \
 && cd nix-$NIX_VERSION-x86_64-linux \
 && USER=root ./install \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Prepare Nix environment
ADD files/nix-do /usr/bin/
ADD files/bashrc /root/.bashrc

ARG NIX_CHANNEL_URL="https://bbpobjectstorage.epfl.ch/nix-channel"

RUN nix-do nix-channel --add $NIX_CHANNEL_URL bbp-pkgs \
 && nix-do nix-channel --update

ENV PATH="/root/.nix-profile/bin:$PATH"
