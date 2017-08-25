FROM fedora:25
LABEL maintainer "Tristan CAREL <tristan.carel@epfl.ch"

ARG NIX_CHANNEL_URL
ARG BBPCODE_SSH_USER
ARG MPICH2_VERSION

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

RUN dnf group install -yv 'C Development Tools and Libraries'
RUN dnf install -y gcc gcc-gfortran make
ADD mpich-${MPICH2_VERSION}.tar.gz /usr/local/src/
RUN [ -f /usr/local/src/mpich-${MPICH2_VERSION}.tar.gz ] \
 && tar zxf /usr/local/src/mpich-${MPICH2_VERSION}.tar.gz -C /usr/local/src \
 ;  cd /usr/local/src/mpich-${MPICH2_VERSION} \
 && ./configure --prefix=/ --libdir=/lib64 \
 && make && make -j`nproc` all test install \
 && ldconfig

ADD files/nix-do /usr/bin/
ADD files/bashrc /root/.bashrc
ADD files/ssh/config /tmp/ssh_config
ADD files/ssh/id_rsa /root/.ssh/
ADD files/mpi-shifter-post-install /usr/bin/
ADD files/mpi-shifter-patch-executable /usr/bin/
ADD files/nix-store-path /usr/bin/

RUN chmod 711 /root/.ssh \
 && chmod 400 /root/.ssh/id_rsa \
 && </tmp/ssh_config sed -e "s/@BBPCODE_SSH_USER@/${BBPCODE_SSH_USER}/g" \
  | install -m 400 /dev/stdin /root/.ssh/config \
 && rm -f /tmp/ssh_config \
 && nix-do nix-channel --add $NIX_CHANNEL_URL bbp-pkgs \
 && nix-do nix-channel --update

ENV PATH="/root/.nix-profile/bin:$PATH"
