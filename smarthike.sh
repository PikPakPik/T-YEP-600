#!/bin/bash
ENV=${1:-dev}

case $ENV in
prod)
  DOCKER_COMPOSE_FILE=docker-compose.yaml
  ;;
ci)
  DOCKER_COMPOSE_FILE=docker-compose.ci.yaml
  ;;
dev)
  DOCKER_COMPOSE_FILE=docker-compose.dev.yaml
  ;;
*)
  DOCKER_COMPOSE_FILE=docker-compose.local.yaml
  ;;
esac

function build() {
  docker compose -f $DOCKER_COMPOSE_FILE up --build -d
}

function down() {
  docker compose -f $DOCKER_COMPOSE_FILE down --remove-orphans -v --rmi all
}

function re_build() {
  down
  build
}

function logs() {
  docker compose -f $DOCKER_COMPOSE_FILE logs -f
}

function initialize() {
  echo "### BACKEND ###"
  echo "Create database ..."
  docker compose -f $DOCKER_COMPOSE_FILE exec backend_python sh -c "flask database:create"
  echo "Create fixtures ..."
  docker compose -f $DOCKER_COMPOSE_FILE exec backend_python sh -c "flask database:fixtures"
  echo "Import hikes ..."
  docker compose -f $DOCKER_COMPOSE_FILE exec backend_python sh -c "flask import:hikes all_france_hiking_no_geom.csv"
  echo "### FRONTEND ###"
  echo "Install dependencies ..."
  cd smarthike
  flutter pub get
  cd ..
  echo "### DONE ###"
}

function test() {
  echo "### BACKEND ###"
  docker compose -f $DOCKER_COMPOSE_FILE exec backend_python sh -c "pytest -s tests/**/*.py"
  echo "### FRONTEND ###"
  cd smarthike
  flutter test
  cd ..
  echo "### DONE ###"
}

case $2 in
build)
  build
  ;;
down)
  down
  ;;
re-build)
  re_build
  ;;
logs)
  logs
  ;;
initialize)
  initialize
  ;;
test)
  test
  ;;
*)
  echo "Usage: $0 {env(local|dev|ci|prod)} {build|down|re-build|logs|initialize|test}"
  ;;
esac
