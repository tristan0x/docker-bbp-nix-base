ARG DOCKER_ORG=BlueBrain
FROM ${DOCKER_ORG}/nix

ADD files/ssh/config /tmp/ssh_config
ADD files/ssh/id_rsa /root/.ssh/
ADD files/nix-store-path /usr/bin/

ARG BBPCODE_SSH_USER

RUN chmod 711 /root/.ssh \
 && chmod 400 /root/.ssh/id_rsa \
 && </tmp/ssh_config sed -e "s/@BBPCODE_SSH_USER@/${BBPCODE_SSH_USER}/g" \
  | install -m 400 /dev/stdin /root/.ssh/config \
 && rm -f /tmp/ssh_config


# Build and install mpich2
ARG MPICH2_VERSION
ADD mpich-${MPICH2_VERSION}.tar.gz /usr/local/src/
RUN [ -f /usr/local/src/mpich-${MPICH2_VERSION}.tar.gz ] \
 && tar zxf /usr/local/src/mpich-${MPICH2_VERSION}.tar.gz -C /usr/local/src \
 ;  cd /usr/local/src/mpich-${MPICH2_VERSION} \
 && ./configure --enable-fortran=no --prefix=/ --libdir=/lib64 \
 && make && make -j`nproc` all test install \
 && ldconfig

# Install NIX packages
RUN nix-do nix-env -f /root/.nix-defexpr/channels/bbp-pkgs \
 -i python3 binutils patchelf

ARG NIX_PACKAGE

RUN if [ "x$NIX_PACKAGE" = xall ] ;then \
    NIX_PACKAGE="modules.all modules.extra nse-allpkgs modules.benchs" ; \
 fi ; \
 pkgs="" ; \
 for pkg in $NIX_PACKAGE ; do \
    pkgs="-iA $pkg $pkgs" ; \
 done ; \
 nix-do nix-env -f /root/.nix-defexpr/channels/bbp-pkgs $pkgs ; \
 rm -rf /share/man

ADD files/mpi-shifter-post-install /usr/bin/
ADD files/mpi-shifter-patch-executable /usr/bin/
RUN mpi-shifter-post-install "${MPICH2_VERSION}" \
 && rm -rf /root/.ssh /tmp
ENV LD_LIBRARY_PATH=/nix/var/nix/ext/site-mpi/lib
