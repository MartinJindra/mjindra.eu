.DEFAULT_GOAL := build

HUGO := hugo
DOCKER_COMPOSE := docker-compose

.PHONY: submodules build serve build_with_draft serve_with_draft verify up down

submodules:
	git submodule update --recursive --init

build: submodules
	$(HUGO)

serve: submodules
	$(HUGO) serve

build_with_draft: submodules
	$(HUGO) -D

serve_with_draft: submodules
	$(HUGO) serve -D

verify:
	@if [[ -n "$$($(DOCKER_COMPOSE) config -q)" ]]; then echo "[ERR] docker-compose.yml unvalid"; exit 1; fi

up: build verify
	$(DOCKER_COMPOSE) up -d

down: verify
	$(DOCKER_COMPOSE) down

