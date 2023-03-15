FROM docker.io/library/fedora:latest

RUN dnf -y update \
    && dnf install -y offlineimap \
    && dnf clean all

RUN groupadd imapgroup; \
    useradd --create-home --shell /bin/bash --home-dir /home/imapuser imapuser;

COPY --chown=imapuser:imapgroup ./offlineimap_env_helper.py /home/imapuser/offlineimap_env_helper.py
RUN chmod u=rx,g=,o= /home/imapuser/offlineimap_env_helper.py

USER imapuser:imapgroup
WORKDIR /home/imapuser

RUN mkdir -p "/home/imapuser/mail"; \
    chown imapuser:imapgroup "/home/imapuser/mail"

VOLUME ["/home/imapuser/mail"]

ENTRYPOINT [ "offlineimap", "-c", "/home/imapuser/.offlineimaprc"]