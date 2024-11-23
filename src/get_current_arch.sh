# Function to get system architecture
get_current_arch() {
	local arch=$(uname -m)
	case "$arch" in
		x86_64|aarch64) echo "$arch-linux" ;;
		*) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
	esac
}
