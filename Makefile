include env.mk

DOCKER ?= docker

all: upload-packages

base:
	$(DOCKER) build -t bbp/nix-base 					\
	  --build-arg BBPCODE_SSH_USER=$(BBPCODE_SSH_USER) 	\
	  --build-arg NIX_CHANNEL_URL=$(NIX_CHANNEL_URL) 	\
	  base

pkg.%: base
	pkg=$(patsubst pkg.%,%,$@) ;		\
	$(DOCKER) build 					\
		--squash						\
	    -t $(DOCKER_ORG)/$$pkg 			\
		--build-arg NIX_PACKAGE=$$pkg 	\
		package

push.%: pkg.%
	pkg=$(patsubst push.%,%,$@) ;		\
	$(DOCKER) push $(DOCKER_ORG)/$$pkg

.PHONY: base
