SHELL := /bin/bash

ENV ?= dev

ifeq ($(ENV), prod)
    DOCKER_COMPOSE_FILE := docker-compose.yaml
else ifeq ($(ENV), ci)
    DOCKER_COMPOSE_FILE := docker-compose.ci.yaml
else ifeq ($(ENV), dev)
    DOCKER_COMPOSE_FILE := docker-compose.dev.yaml
else
    DOCKER_COMPOSE_FILE := docker-compose.local.yaml
endif

.PHONY: build
build:
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build -d

.PHONY: down
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans -v --rmi all

.PHONY: re-build
re-build:
	$(MAKE) down
	$(MAKE) build

.PHONY: logs
logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f

.PHONY: test
test:
	docker compose -f $(DOCKER_COMPOSE_FILE) exec python sh -c "pytest -s tests/**/*.py"