#!/usr/bin/env bash
SOURCE="./src"
DEFAULT_CONFIGURATION_FILE="$SOURCE/default.env"

set -o pipefail -o errexit

cd "$(dirname "$0")"

source "$SOURCE/read_config.sh"
source "$SOURCE/nixos_kexec.sh" "$@"
