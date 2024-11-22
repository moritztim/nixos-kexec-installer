#!/usr/bin/env bash
# Outputs a fully built script to be piped to bash, saved to a file, etc.

SOURCE="./src"
DEFAULT_CONFIGURATION_FILE="$SOURCE/default.env"

set -o pipefail -o errexit

cd "$(dirname "$0")"

echo "#! /usr/bin/env bash"
echo "# This script is GENERATED. Do not edit directly."
echo
cat "$DEFAULT_CONFIGURATION_FILE"
cat "$SOURCE/read_config.sh"
cat "$SOURCE/nixos_kexec.sh"
