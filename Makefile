include env.mk

DOCKER ?= docker
DBFLAGS ?=

all: base

base:
	$(DOCKER) build -t $(DOCKER_ORG)/nix $(DBFLAGS) \
	--build-arg NIX_CHANNEL_URL=$(NIX_CHANNEL_URL) \
	base

build.%:
	pkg=$(patsubst build.%,%,$@) ;			\
	$(DOCKER) build --squash $(DBFLAGS)				\
	 -t $(DOCKER_ORG)/$${pkg}:$(PKG_DTAG) 	\
	  --build-arg DOCKER_ORG=$(DOCKER_ORG) \
	  --build-arg BBPCODE_SSH_USER=$(BBPCODE_SSH_USER) 	\
	  --build-arg NIX_PACKAGE=$$pkg 		\
	  --build-arg MPICH2_VERSION=$(MPICH2_VERSION) \
	  build

push.%: build.%
	pkg=$(patsubst push.%,%,$@) ;		\
	$(DOCKER) push $(DOCKER_ORG)/$$pkg:$(PKG_DTAG)

.PHONY: base
