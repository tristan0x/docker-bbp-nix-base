include env.mk

DOCKER ?= docker
DBFLAGS ?=

all: upload-packages

build.%: base
	pkg=$(patsubst build.%,%,$@) ;			\
	$(DOCKER) build --squash $(DBFLAGS)				\
     -t $(DOCKER_ORG)/$${pkg}:$(PKG_DTAG).build 	\
	  --build-arg BBPCODE_SSH_USER=$(BBPCODE_SSH_USER) 	\
	  --build-arg NIX_CHANNEL_URL=$(NIX_CHANNEL_URL) 	\
	  --build-arg NIX_PACKAGE=$$pkg 		\
	  --build-arg MPICH2_VERSION=$(MPICH2_VERSION) \
	  build

postbuild.%: build.%
	pkg=$(patsubst postbuild.%,%,$@) ;			\
	mpich2_path=`$(DOCKER) run --rm $(DOCKER_ORG)/$$pkg:$(PKG_DTAG).build nix-store-path mpich2-$(MPICH2_VERSION)` ; \
	$(DOCKER) build $(DBFLAGS)              \
	    -t $(DOCKER_ORG)/$${pkg}:$(PKG_DTAG) 	\
	    --build-arg BASE_IMAGE="$(DOCKER_ORG)/$${pkg}:$(PKG_DTAG).build" \
	    --build-arg MPICH2_INSTALL_PATH=$$mpich2_path \
	    postbuild

push.%: postbuild.%
	pkg=$(patsubst push.%,%,$@) ;		\
	$(DOCKER) push $(DOCKER_ORG)/$$pkg:$(PKG_DTAG)

.PHONY: base
