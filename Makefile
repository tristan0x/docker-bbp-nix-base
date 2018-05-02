include env.mk

DOCKER ?= docker
DBFLAGS ?=
HPC_IMAGE = $(DOCKER_ORG)/hpc:latest

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

hpc:
	base=`docker images -q --filter="reference=$(HPC_IMAGE)"` ; \
	if [ "x$$base" = x ] ;then \
		$(MAKE) build.all ; \
		$(DOCKER) tag $(DOCKER_ORG)/all:$(PKG_DTAG) $(HPC_IMAGE) ;\
	else \
		$(DOCKER) build --squash $(DBFLAGS) \
		  -t $(HPC_IMAGE) \
		  --build-arg DOCKER_ORG=$(DOCKER_ORG) \
		  hpc ; \
	fi


.PHONY: base hpc
