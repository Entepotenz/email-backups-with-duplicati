#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly BACKUPS_FOLDER="$SCRIPT_DIR/scripts/backups"

"$SCRIPT_DIR/scripts/collect_data_from_imap.sh"
"$SCRIPT_DIR/scripts/backup_data_using_duplicati.sh"

rm -rf "$BACKUPS_FOLDER"