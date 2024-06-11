SHELL := /bin/bash
DOCKER_COMPOSE_FILE := docker-compose.dev.yaml

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
