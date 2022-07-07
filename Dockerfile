# Ubuntu 20.04 LTS (Focal Fossa) Release Build
FROM ubuntu:focal
LABEL author="Ruben Suarez <rubensa@gmail.com>"

# Architecture component of TARGETPLATFORM (platform of the build result)
ARG TARGETARCH

# Configure apt and install openssl build dependencies
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends curl build-essential zlib1g-dev ca-certificates 2>&1

# Ubuntu 18.04 comes with OpenSSL 1.1 and Ruby versions earlier than 2.4 used OpenSSL 1.0
# openssl version to install (https://www.openssl.org/source/old/)
ARG OPENSSL_VERSION_1_0=1.0.2
ARG OPENSSL_VERSION_1_0_PATCH=${OPENSSL_VERSION_1_0}u

# openssl installation directory
ENV OPENSSL_ROOT_1_0=/opt/openssl-1.0

# Install OpenSSL 1.0
RUN curl -o /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz -sSL https://www.openssl.org/source/old/${OPENSSL_VERSION_1_0}/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz \
  && mkdir -p ${OPENSSL_ROOT_1_0} \
  && mkdir -p /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH} \
  && tar xzf /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz -C /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH} --strip-components=1 \
  && cd /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH} && ./config --prefix=${OPENSSL_ROOT_1_0} --openssldir=${OPENSSL_ROOT_1_0} shared zlib && make && make install \
  && cd \
  && rm -rf /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH} \
  && rm /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz \
  # Link the system's certs to OpenSSL directory
  && rm -rf ${OPENSSL_ROOT_1_0}/certs \
  && ln -s /etc/ssl/certs ${OPENSSL_ROOT_1_0}

# Clean up apt
RUN apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
