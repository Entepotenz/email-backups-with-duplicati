FROM docker.io/library/fedora:latest as base

# s6-overlay auto selection of architecture inspired from https://github.com/padhi-homelab/docker_s6-overlay/blob/4cdb04131112a8d89e7ed2102083a062c8168d89/Dockerfile
ARG TARGETARCH

FROM base AS base-amd64
ENV S6_OVERLAY_ARCH=x86_64

FROM base AS base-386
ENV S6_OVERLAY_ARCH=i686

FROM base AS base-arm64
ENV S6_OVERLAY_ARCH=aarch64

FROM base AS base-armv7
ENV S6_OVERLAY_ARCH=armhf

FROM base AS base-armv6
ENV S6_OVERLAY_ARCH=arm

FROM base AS base-ppc64le
ENV S6_OVERLAY_ARCH=ppc64le

FROM base-${TARGETARCH}${TARGETVARIANT}

ARG S6_OVERLAY_VERSION=3.1.6.0

RUN dnf -y update \
    && dnf install -y xz offlineimap inotify-tools \
    && dnf clean all

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256 /tmp
RUN tar -C / -Jxpf "/tmp/s6-overlay-noarch.tar.xz"
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz.sha256 /tmp
RUN tar -C / -Jxpf "/tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz"

# add s6 optional symlinks
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz.sha256 /tmp
RUN tar -C / -Jxpf "/tmp/s6-overlay-symlinks-noarch.tar.xz"
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz.sha256 /tmp
RUN tar -C / -Jxpf "/tmp/s6-overlay-symlinks-arch.tar.xz"

# Verifying s6-overlay Downloads
# hadolint ignore=DL3003
RUN cd /tmp && sha256sum -c -- *.sha256

RUN groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false --home /home/abc abc && \
    usermod -G users abc && \
    mkdir -p \
        /app \
        /config \
        /defaults

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/home/abc" \
    TERM="xterm" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
    S6_VERBOSITY=1

VOLUME ["/data"]

# copy local files
COPY root/ /
COPY config_standard.conf /defaults/offlineimap.conf

# Using CMD is a convenient way to take advantage of the overlay.
# Your CMD can be given at build time in the Dockerfile, or at run time on the command line, either way is fine.
# It will be run as a normal process in the environment set up by s6; when it fails or exits, the container will shut down cleanly and exit
CMD [ "/etc/s6-overlay/s6-rc.d/svc-offlineimap/run" ]

ENTRYPOINT ["/init"]
