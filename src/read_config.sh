#!/bin/bash

# Function to read config file
# Adapted from: https://stackoverflow.com/a/30969768/179329
read_config() {
	set -o allexport && source "$1" && set +o allexport
}
