FROM bbp/nix-base

ARG NIX_PACKAGE

RUN nix-do nix-env -i $NIX_PACKAGE
RUN nix-do nix-store --gc
RUN rm -rf /root/.ssh
