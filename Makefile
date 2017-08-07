include env.mk

DOCKER ?= docker
DBFLAGS ?=

all: upload-packages

base:
	$(DOCKER) build $(DBFLAGS) 				\
	  -t bbp/nix-base									\
	  --build-arg BBPCODE_SSH_USER=$(BBPCODE_SSH_USER) 	\
	  --build-arg NIX_CHANNEL_URL=$(NIX_CHANNEL_URL) 	\
	  base

build.%: base
	pkg=$(patsubst build.%,%,$@) ;			\
	$(DOCKER) build $(DBFLAGS)				\
		--squash							\
	    -t $(DOCKER_ORG)/$$pkg:$(PKG_DTAG) 	\
		--build-arg NIX_PACKAGE=$$pkg 		\
		package

push.%: build.%
	pkg=$(patsubst push.%,%,$@) ;		\
	$(DOCKER) push $(DOCKER_ORG)/$$pkg:$(PKG_DTAG)

.PHONY: base
