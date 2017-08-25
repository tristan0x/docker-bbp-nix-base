include env.mk

DOCKER ?= docker
DBFLAGS ?=

all: upload-packages

base:
	$(DOCKER) build --pull $(DBFLAGS) 				\
	  -t bbp/nix-base									\
	  --build-arg BBPCODE_SSH_USER=$(BBPCODE_SSH_USER) 	\
	  --build-arg NIX_CHANNEL_URL=$(NIX_CHANNEL_URL) 	\
	  --build-arg MPICH2_VERSION=$(MPICH2_VERSION) \
	  base

build.%: base
	pkg=$(patsubst build.%,%,$@) ;			\
	$(DOCKER) build $(DBFLAGS)				\
	    -t $(DOCKER_ORG)/$${pkg}:$(PKG_DTAG).build 	\
		--build-arg NIX_PACKAGE=$$pkg 		\
		--build-arg MPICH2_VERSION=$(MPICH2_VERSION) \
		package

postbuild.%: build.%
	pkg=$(patsubst postbuild.%,%,$@) ;			\
	mpich2_path=`$(DOCKER) run --rm $(DOCKER_ORG)/$$pkg:$(PKG_DTAG).build nix-store-path mpich2-$(MPICH2_VERSION)` ; \
	$(DOCKER) build $(DBFLAGS)              \
	    -t $(DOCKER_ORG)/$${pkg}:$(PKG_DTAG) 	\
	    --build-arg BASE_IMAGE="$(DOCKER_ORG)/$${pkg}:$(PKG_DTAG).build" \
	    --build-arg LD_LIBRARY_PATH=$$mpich2_path \
	    postbuild


push.%: postbuild.%s
	pkg=$(patsubst push.%,%,$@) ;		\
	$(DOCKER) push $(DOCKER_ORG)/$$pkg:$(PKG_DTAG)

.PHONY: base
