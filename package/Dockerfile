FROM bbp/nix-base

ARG NIX_PACKAGE
ARG MPICH2_VERSION

RUN for pkg in $NIX_PACKAGE ; do \
        nix-do nix-env -i "$pkg" ; \
    done \
 && nix-do nix-env -i python binutils patchelf mpich2-${MPICH2_VERSION} \
 && nix-do nix-store --gc \
 && mpi-shifter-post-install "${MPICH2_VERSION}" \
 && rm -rf /root/.ssh /tmp
