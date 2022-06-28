.DEFAULT_GOAL := build

HUGO := hugo
DOCKER_COMPOSE := docker-compose
DOCKER := docker
GIT := git

.PHONY: submodules build serve build_with_draft serve_with_draft verify up down

submodules:
	$(GIT) submodule update --recursive --init

build: submodules
	@if [  -x "$$(which $(HUGO))" ]; then hugo; else $(DOCKER) build . -t mjindra.eu:latest; $(DOCKER) run --name build_mjindra.eu mjindra.eu; $(DOCKER) cp build_mjindra.eu:/www/public .; $(DOCKER) stop build_mjindra.eu; $(DOCKER) rm build_mjindra.eu; $(DOCKER) rmi mjindra.eu:latest; fi

serve: submodules
	$(HUGO) serve

build_with_draft: submodules
	$(HUGO) -DF

serve_with_draft: submodules
	$(HUGO) serve -DF

verify:
	@if [ -n "$$($(DOCKER_COMPOSE) config -q)" ]; then echo "[ERR] docker-compose.yml unvalid"; exit 1; fi

up: build verify
	$(DOCKER_COMPOSE) up -d

down: verify
	$(DOCKER_COMPOSE) down

