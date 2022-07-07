# syntax=docker/dockerfile:1.4
# Ubuntu 20.04 LTS (Focal Fossa) Release Build
FROM ubuntu:focal
LABEL author="Ruben Suarez <rubensa@gmail.com>"

# Architecture component of TARGETPLATFORM (platform of the build result)
ARG TARGETARCH

# Configure apt and install openssl build dependencies
RUN <<EOT
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends curl build-essential zlib1g-dev ca-certificates 2>&1
EOT

# Ubuntu 18.04 comes with OpenSSL 1.1 and Ruby versions earlier than 2.4 uses OpenSSL 1.0
# openssl version to install (https://www.openssl.org/source/old/)
ARG OPENSSL_VERSION_1_0=1.0.2
ARG OPENSSL_VERSION_1_0_PATCH=${OPENSSL_VERSION_1_0}u

# openssl installation directory
ENV OPENSSL_ROOT_1_0=/opt/openssl-1.0

# Install OpenSSL 1.0
ADD patches/${OPENSSL_VERSION_1_0_PATCH}/ /tmp/openssl-patches/${OPENSSL_VERSION_1_0_PATCH}
RUN <<EOT
echo "# Installing OpenSSL 1.0..."
curl -o /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz -sSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz
mkdir -p ${OPENSSL_ROOT_1_0}
mkdir -p /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}
tar xzf /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz -C /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH} --strip-components=1
echo "# Patching OpenSSL 1.0..."
# Patches needed to avoid "relocation R_AARCH64_PREL64 against symbol `OPENSSL_armcap_P'"
# Patches needed to avoid "libssl.so.1.0.0: no version information available"
# adapted from: https://launchpad.net/ubuntu/+source/openssl
find /tmp/openssl-patches/${OPENSSL_VERSION_1_0_PATCH} -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -d /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH} -p1 -i
echo "# Building OpenSSL 1.0..."
cd /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}
./config --prefix=${OPENSSL_ROOT_1_0} --openssldir=${OPENSSL_ROOT_1_0} shared zlib
make
echo "# Installing OpenSSL 1.0..."
make install
cd
echo "# Cleaning OpenSSL 1.0..."
rm -rf /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}
rm /tmp/openssl-${OPENSSL_VERSION_1_0_PATCH}.tar.gz
rm -rf /tmp/openssl-patches
echo "# Linking system certs to OpenSSL 1.0..."
rm -rf ${OPENSSL_ROOT_1_0}/certs
ln -s /etc/ssl/certs ${OPENSSL_ROOT_1_0}
echo "# Configuring OpenSSL 1.0 shared libraries..."
echo "${OPENSSL_ROOT_1_0}/lib" > /etc/ld.so.conf.d/openssl-1.0.conf
ldconfig
EOT

# Clean up apt
RUN <<EOT
#!/usr/bin/env bash
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*
EOT