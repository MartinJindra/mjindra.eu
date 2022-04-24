.DEFAULT_GOAL := build

HUGO := hugo
DOCKER := docker
DOCKER_COMPOSE := docker-compose

.PHONY: clean submodules build dummy verify serve down

clean:
	git clean -dxf

submodules:
	git submodule update --recursive --init

build: clean submodules
	$(HUGO)

verify:
	@if [[ -n "$(DOCKER_COMPOSE) config -q" ]]; then echo "[ERR] docker-compose.yml unvalid"; exit 1; fi

dummy: build
	@if [[ ! -e "$(PWD).env" ]]; then\
		echo "# website settings" >> .env;\
		echo "REMARK_URL=http://remark42.localhost" >> .env;\
		echo "SECRET=mysecret" >> .env;\
		echo "SITE=remark" >> .env;\
		echo "" >> .env;\
		echo "# admin settings" >> .env;\
		echo "ADMIN_SHARED_ID=mysecretid" >> .env;\
		echo "ADMIN_SHARED_EMAIL=max@mustermann.com" >> .env;\
		echo "ADMIN_PASSWD=password" >> .env;\
		echo "" >> .env;\
		echo "# authentications" >> .env;\
		echo "AUTH_GITHUB_CID=secret_token" >> .env;\
		echo "AUTH_GITHUB_CSEC=secret_token" >> .env;\
		echo "AUTH_GOOGLE_CID=secret_token" >> .env;\
		echo "AUTH_GOOGLE_CSEC=secret_token" >> .env;\
	fi
	$(DOCKER_COMPOSE) up -d

serve: build verify
	$(DOCKER_COMPOSE) up -d

down: verify
	$(DOCKER_COMPOSE) down

