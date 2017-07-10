FROM fedora:25
LABEL maintainer "Tristan CAREL <tristan.carel@epfl.ch"

ARG NIX_CHANNEL_URL
ARG BBPCODE_SSH_USER

RUN echo 'check-update' ; dnf check-update -yv \
 && echo 'distro-sync' ; dnf distro-sync -yv \
 && dnf install -y sudo \
 	bzip2 \
 	git \
 	hostname \
 	nano \
 	openssh-clients \
 	vim \
    ncurses \
    ncurses-devel \
    ncurses-libs \
    readline \
    readline-devel \
 && mkdir -m 755 /etc/nix \
 && echo "build-users-group =" > /etc/nix/nix.conf \
 && curl https://nixos.org/nix/install | USER=root sh

ADD files/nix-do /usr/bin/
ADD files/bashrc /root/.bashrc
ADD files/ssh/config /tmp/ssh_config
ADD files/ssh/id_rsa /root/.ssh/

RUN chmod 711 /root/.ssh \
 && chmod 400 /root/.ssh/id_rsa \
 && </tmp/ssh_config sed -e "s/@BBPCODE_SSH_USER@/${BBPCODE_SSH_USER}/g" \
  | install -m 400 /dev/stdin /root/.ssh/config \
 && rm -f /tmp/ssh_config \
 && nix-do nix-channel --add $NIX_CHANNEL_URL \
 && nix-do nix-channel --update

ENV PATH="/root/.nix-profile/bin:$PATH"
