#!/usr/bin/env bash

set -o pipefail -o errexit

cd "$(dirname "$0")"

DEFAULT_CONFIGURATION_FILE="./default.env"

# Function to get system architecture
get_current_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|aarch64) echo "$arch-linux" ;;
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
    esac
}

# Function to read config file
read_config() {
    set -o allexport && source "$1" && set +o allexport
}

# Function to prompt for missing values
prompt_missing_values() {
    if [[ -z "${SOURCE:-}" ]]; then
        read -p "Enter source URL [$SOURCE]: " SOURCE
        SOURCE=${SOURCE:-$SOURCE}
    fi

    if [[ -z "${TAG:-}" ]]; then
        read -p "Enter tag [$TAG]: " TAG
        TAG=${TAG:-$TAG}
    fi

    if [[ -z "${ARCH:-}" ]]; then
        ARCH=$(get_current_arch)
    fi

    if [[ -z "${INTERACTIVE:-}" ]]; then
        read -p "Use interactive installer? [y/N]: " INTERACTIVE
        INTERACTIVE=${INTERACTIVE:-$INTERACTIVE}
    fi
}

# Function to parse script arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install)
                INSTALL=true
                shift
                ;;
            *)
                echo "Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done
}

# Load default configuration
read_config "$DEFAULT_CONFIGURATION_FILE"

# Load custom configuration, overriding defaults where applicable
if [[ -f "$CONFIGURATION_FILE" ]]; then
    read_config "$CONFIGURATION_FILE"
fi

# Parse the arguments
parse_args "$@"

# Prompt for missing values
prompt_missing_values

# Construct the URL
if [[ "$INTERACTIVE" == "y" ]]; then
    INTERACTIVE=""
else
    INTERACTIVE="-noninteractive"
fi

if [[ "$TAG" == "latest" ]]; then
    TAG="$TAG/download"
else
    SOURCE="${SOURCE}/download"
fi

URL="${SOURCE}/${TAG}/nixos-kexec-installer${INTERACTIVE}-${ARCH}.tar.gz"

# If the --install flag is set, perform the installation
if $INSTALL; then
    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root if the --install flag is set" >&2
        exit 1
    fi
    echo "Downloading and executing kexec installer from: $URL"
    curl -L "$URL" | tar --extract --gzip --file=- -C /root
    /root/kexec/run
else
    if curl --output /dev/null --silent --head --fail "$URL"; then
        echo "$URL"
    else
        echo "URL does not exist: $URL" >&2
        exit 1
    fi
fi
