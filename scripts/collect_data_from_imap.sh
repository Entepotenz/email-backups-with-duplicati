#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly TEMP_DIR="$SCRIPT_DIR/TEMP_DIR"
mkdir -p "$TEMP_DIR"
trap 'rm -rf -- "$TEMP_DIR"' EXIT SIGTERM SIGINT

source "$SCRIPT_DIR/../secrets/pass_offlineimap.sh"

pull_data_from_imap () {
    local CONFIG_PATH_OFFLINEIMAP="$1"
    local BACKUP_TARGET_FOLDER="$2"
    local REMOTE_HOST="$3"
    local REMOTE_USER="$4"
    local REMOTE_PASS="$5"

    local CONFIG_PATH_OFFLINEIMAP_ENVSUBST="$TEMP_DIR/offlinemaprc"
    touch "$CONFIG_PATH_OFFLINEIMAP_ENVSUBST"
    chmod u=rw,o=,g= "$CONFIG_PATH_OFFLINEIMAP_ENVSUBST"

    REMOTE_HOST="$REMOTE_HOST" \
    REMOTE_USER="$REMOTE_USER" \
    REMOTE_PASS="$REMOTE_PASS" \
    envsubst '$REMOTE_HOST,$REMOTE_USER,$REMOTE_PASS' < "$CONFIG_PATH_OFFLINEIMAP" > "$CONFIG_PATH_OFFLINEIMAP_ENVSUBST"

    mkdir -p "$BACKUP_TARGET_FOLDER"

    docker run --rm -it \
        -v "$CONFIG_PATH_OFFLINEIMAP_ENVSUBST":/root/.offlineimaprc \
        -v "$BACKUP_TARGET_FOLDER":/root/mail \
        fedora:latest bash -c "\
            dnf install -y offlineimap; \
            offlineimap"
}


readonly CONFIG_PATH_OFFLINEIMAP_STANDARD="$SCRIPT_DIR/../configurations/config_standard.conf"

readonly BACKUP_PATH_XXX="$SCRIPT_DIR/backups/backup_XXX"

pull_data_from_imap "$CONFIG_PATH_OFFLINEIMAP_STANDARD" \
    "$BACKUP_PATH_XXX" \
    "$OUTLOOK_REMOTE_HOST" "$OUTLOOK_USER" "$OUTLOOK_PASS"

# ---

readonly BACKUP_PATH_XXX_123="$SCRIPT_DIR/backups/backup_XXX_123"

pull_data_from_imap "$CONFIG_PATH_OFFLINEIMAP_STANDARD" \
    "$BACKUP_PATH_XXX_123" \
    "$OUTLOOK_REMOTE_HOST" "$OUTLOOK_USER_123" "$OUTLOOK_PASS_123"

# ---