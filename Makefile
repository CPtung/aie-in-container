.PHONY: build up down clean

APP_NAME           ?= $(shell grep -E ' +name:' metadata.yml | awk -F: '{print $$2}'| tr -d " ")
DRONE_BUILD_NUMBER ?= unknown
BUILD_NUMBER       ?= $(DRONE_BUILD_NUMBER)
VERSION            := 0.0.2-$(BUILD_NUMBER)
ARCH               ?= $(ARCH)
DOCKERFILE_SUFFIX  ?= .$(ARCH)
DOCKERFILE         ?= ./Dockerfile$(DOCKERFILE_SUFFIX)
ENV                := ARCH=$(ARCH) VERSION=$(VERSION)


build:
	docker build \
		-f ./Dockerfile$(DOCKERFILE_SUFFIX) \
		-t docker.moxa.online/moxaisd/${APP_NAME}:${VERSION}-${ARCH} \
		.

up:
	$(ENV) \
		docker-compose -f docker-compose.$(ARCH).yml up -d

down:
	$(ENV) \
		docker-compose -f docker-compose.$(ARCH).yml down

clean:
	rm -rf tmp.*
	docker rmi docker.moxa.online/moxaisd/${APP_NAME}:${VERSION}-${ARCH}
