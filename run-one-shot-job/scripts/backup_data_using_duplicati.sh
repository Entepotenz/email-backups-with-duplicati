#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

readonly SCRIPT_DIR
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck disable=SC1091
source "$SCRIPT_DIR/../secrets/pass_duplicati.sh"

docker run --rm \
    -v "$SCRIPT_DIR/backups":/source \
    duplicati/duplicati bash -c "\
        duplicati-cli repair \"mega:///duplicati_imap_backup/?auth-username=$MEGA_USERNAME&auth-password=$MEGA_PASSWORD\" \
            --dbpath=/config/QKIXOAOTCP.sqlite \
            --passphrase=\"$DUPLICATI_ENCRYPTION_PASSWORD\"; \
        duplicati-cli backup \"mega:///duplicati_imap_backup/?auth-username=$MEGA_USERNAME&auth-password=$MEGA_PASSWORD\" \
            /source \
            --backup-name=Emails \
            --dbpath=/config/QKIXOAOTCP.sqlite \
            --encryption-module=aes \
            --compression-module=zip \
            --dblock-size=50mb \
            --passphrase=\"$DUPLICATI_ENCRYPTION_PASSWORD\" \
            --disable-module=console-password-input
    "
