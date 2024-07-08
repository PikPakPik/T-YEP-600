FROM python:alpine

ENV PIP_ROOT_USER_ACTION=ignore

WORKDIR /usr/src/app

RUN apk add --no-cache git bash pkgconfig mariadb-dev musl-dev gcc libffi-dev python3-dev

RUN pip install --upgrade pip

EXPOSE 5000

CMD [ "bash", "run.sh" ]