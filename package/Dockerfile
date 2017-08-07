FROM bbp/nix-base

ARG NIX_PACKAGE

RUN for pkg in $NIX_PACKAGE ; do \
        nix-do nix-env -i "$pkg" ; \
    done \
 && nix-do nix-env -i python \
 && nix-do nix-env -i binutils \
 && nix-do nix-env -i patchelf \
 && nix-do nix-store --gc \
 && rm -rf /root/.ssh \
 && mpi-shifter-post-install
RUN dnf group install -yv 'C Development Tools and Libraries'
RUN dnf install -y gcc gcc-gfortran make
ARG MPICH=3.1.4
ADD http://www.mpich.org/static/downloads/${MPICH}/mpich-${MPICH}.tar.gz /usr/local/src/
RUN cd /usr/local/src/mpich-${MPICH} && \
    ./configure --prefix=/ --libdir=/lib64 && \
    make && make install && \
    cd /usr/local/src && \
    rm -rf mpich-${MPICH} && \
    ldconfig
RUN rm -rf /tmp
