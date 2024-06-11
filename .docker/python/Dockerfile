FROM python:alpine

ENV PIP_ROOT_USER_ACTION=ignore

WORKDIR /usr/src/app

RUN apk update && apk add --no-cache \
    build-base \
    mariadb-connector-c-dev \
    mariadb-dev \
    linux-headers \
    python3-dev \
    musl-dev \
    gcc \
    cargo

EXPOSE 5000

CMD [ "sh", "run.sh" ]