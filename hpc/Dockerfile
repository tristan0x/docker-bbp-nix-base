ARG DOCKER_ORG=BlueBrain
FROM ${DOCKER_ORG}/hpc

RUN mkdir -p /tmp \
 && nix-do nix-channel --update bbp-pkgs \
 && nix-do nix-env -f /root/.nix-defexpr/channels/bbp-pkgs \
    -iA modules.all \
    -iA modules.extra \
    -iA nse-allpkgs \
    -iA modules.benchs \
&& rm -rf /tmp
