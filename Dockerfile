FROM python:3.9-alpine3.13
LABEL maintainer="helev"

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /tmp/requirements.txt
COPY requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN apk update &&\
    apk add gcc musl-dev postgresql-dev && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
    pip install -r /tmp/requirements.dev.txt; \
    fi  && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user
RUN if [ "$DEV" = "true" ]; then \
    echo "Development mode" > /var/log/mode.log; \
    else \
    echo "Production mode" > /var/log/mode.log; \
    fi
USER django-user