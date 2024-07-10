# Docker image based on ubuntu with old openssl version builds.

This is a Docker image based on [ubuntu](https://hub.docker.com/_/ubuntu/) 24.04 with [old openssl](https://www.openssl.org/source/old/) version builds.  Is image is intended to provide the old openssl builds for [rubensa/ubuntu-tini-dev](https://github.com/rubensa/docker-ubuntu-tini-dev).

## Building

You can build the image like this:

```
#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="rubensa"
DOCKER_IMAGE_NAME="ubuntu-openssl-old"
DOCKER_IMAGE_TAG="24.04"

docker buildx build --platform=linux/amd64,linux/arm64 --no-cache \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  --label "maintainer=Ruben Suarez <rubensa@gmail.com>" \
  .

docker buildx build --load \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  .
```
