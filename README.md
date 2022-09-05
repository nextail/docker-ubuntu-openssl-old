# Docker image based on ubuntu with old openssl version builds.

This is a Docker image based on [ubuntu](https://hub.docker.com/_/ubuntu/) with [old openssl](https://www.openssl.org/source/old/) version builds.  Is image is intended to provide the old openssl builds for [nextail/ubuntu-tini-dev](https://github.com/nextail/docker-ubuntu-tini-dev).

## Building

You can build the image like this:

```
#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="nextail"
DOCKER_IMAGE_NAME="ubuntu-openssl-old"
DOCKER_IMAGE_TAG="latest"

docker buildx build --platform=linux/amd64,linux/arm64 --no-cache \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  --label "maintainer=Ruben Suarez <rubensa@gmail.com>" \
  .

docker buildx build --load \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  .
```
