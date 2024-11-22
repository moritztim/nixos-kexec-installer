# NixOS Kexec Installer Script

Bash script to download and install NixOS using [`kexec`](https://man7.org/linux/man-pages/man8/kexec.8.html) [`NixOS images`](https://github.com/nix-community/nixos-images).

## Features

- Configurable installation source, version tag, architecture and interactivity
- Automatic system architecture detection
- Configuration via environment files
- Generating a download URL
- Booting with kexec

## Usage

1. Generate an installer URL
```bash
./install.sh
```

2. Install NixOS (requires root):
```bash
sudo ./install.sh --install
```

## Configuration

The script uses two configuration files:
- [`default.env`](default.env): Default configuration
- `custom.env`: Optional custom configuration that overrides the defaults set in `default.env`

### Options

The configuration options are documented in the [default configuration file](`default.env`).

## Requirements

### Base requirements
- Bash shell
- curl

### Additional requirements for installation
- Root privileges
- tar

## Best practices

- Backup important data before installation
- Review the URL before proceeding. To do this, run the script without the `--install` flag once and if you're happy, run it again, with the same configuration, and this time with the flag.


> [This documentation was created with non-creative assistance from `Anthropic's Claude 3.5 Sonnet`.](https://declare-ai.org/1.0.0/non-creative.html)