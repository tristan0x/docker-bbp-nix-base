FROM fedora:25
LABEL maintainer "Tristan CAREL <tristan.carel@epfl.ch"

ARG NIX_CHANNEL_URL
ARG BBPCODE_SSH_USER
ARG MPICH_VERSION=3.1

RUN echo 'check-update' ; dnf check-update -yv \
 && echo 'distro-sync' ; dnf distro-sync -yv \
 && dnf install -y sudo \
 	bzip2 \
 	findutils \
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
    patchelf \
 && mkdir -m 755 /etc/nix \
 && echo "build-users-group =" > /etc/nix/nix.conf \
 && curl https://nixos.org/nix/install | USER=root sh

# && dnf group install -yv 'C Development Tools and Libraries' \
# RUN dnf install -y gcc-gfortran 
# RUN curl http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
#   | tar -C /var/opt -xz \
#  && cd /var/opt/mpich-${MPICH_VERSION} \
#  && ./configure --prefix=/usr \
#  && make all install \
#  && ldconfig

ADD files/nix-do /usr/bin/
ADD files/bashrc /root/.bashrc
ADD files/ssh/config /tmp/ssh_config
ADD files/ssh/id_rsa /root/.ssh/
ADD files/mpi-shifter-post-install /usr/bin/
ADD files/mpi-shifter-patch-executable /usr/bin/

RUN chmod 711 /root/.ssh \
 && chmod 400 /root/.ssh/id_rsa \
 && </tmp/ssh_config sed -e "s/@BBPCODE_SSH_USER@/${BBPCODE_SSH_USER}/g" \
  | install -m 400 /dev/stdin /root/.ssh/config \
 && rm -f /tmp/ssh_config \
 && nix-do nix-channel --add $NIX_CHANNEL_URL \
 && nix-do nix-channel --update

ENV PATH="/root/.nix-profile/bin:$PATH"
