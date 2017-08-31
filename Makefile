include env.mk

DOCKER ?= docker
DBFLAGS ?=

all: upload-packages

build.%: base
	pkg=$(patsubst build.%,%,$@) ;			\
	$(DOCKER) build --squash $(DBFLAGS)				\
     -t $(DOCKER_ORG)/$${pkg}:$(PKG_DTAG) 	\
	  --build-arg BBPCODE_SSH_USER=$(BBPCODE_SSH_USER) 	\
	  --build-arg NIX_CHANNEL_URL=$(NIX_CHANNEL_URL) 	\
	  --build-arg NIX_PACKAGE=$$pkg 		\
	  --build-arg MPICH2_VERSION=$(MPICH2_VERSION) \
	  build

push.%: build.%
	pkg=$(patsubst push.%,%,$@) ;		\
	$(DOCKER) push $(DOCKER_ORG)/$$pkg:$(PKG_DTAG)

.PHONY: base
