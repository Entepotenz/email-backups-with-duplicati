#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

find "$SCRIPT_DIR" -type f -iname "Dockerfile" -print0 | xargs -0 hadolint -c "$SCRIPT_DIR/.github/linters/.hadolint.yaml"
