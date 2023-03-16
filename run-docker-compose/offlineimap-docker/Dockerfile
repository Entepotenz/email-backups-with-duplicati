FROM docker.io/library/fedora:latest

ARG S6_OVERLAY_VERSION=3.1.4.1
ARG S6_OVERLAY_ARCH="x86_64"

RUN dnf -y update \
    && dnf install -y xz offlineimap inotify-tools \
    && dnf clean all

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

# add s6 optional symlinks
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

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