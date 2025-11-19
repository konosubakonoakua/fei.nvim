#!/bin/bash

: ${INSTALL_DIR:="$HOME/.local/bin"}
: ${TEMP_DIR:="$HOME/Downloads/tools-install"}
: ${LOG_FILE:="$TEMP_DIR/install.log"}
: ${NVIM_CONFIG_DIR:="$HOME/.config/fei.nvim"}
: ${PROXY_URL:=""}
: ${AUTO_CONFIRM:=0} # Default to manual confirmation

show_help() {
	cat <<EOF
Usage: $0 [OPTIONS]

Install development tools and configurations with optional proxy support.

Options:
  -h, --help        Show this help message and exit
  -p, --proxy URL   Set proxy URL for all downloads (e.g. http://proxy:port)
  -d, --dir DIR     Set custom installation directory (default: ~/.local/bin)
  -t, --temp DIR    Set custom temporary directory (default: ~/Downloads/tools-install)
  -l, --log FILE    Set custom log file path
  -y, --yes         Automatically confirm all installations

Environment Variables:
  INSTALL_DIR       Custom installation directory (same as -d option)
  TEMP_DIR          Custom temporary directory (same as -t option)
  LOG_FILE          Custom log file path (same as -l option)
  PROXY_URL         Proxy address (same as -p option)
  AUTO_CONFIRM      Auto-confirm installations (same as -y option)

Examples:
  # Basic installation with confirmations
  $0

  # Automatic installation without confirmations
  $0 --yes

  # With proxy and auto-confirm
  $0 --proxy http://192.168.138.254:7897 --yes
EOF
	exit 0
}

parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-h | --help)
			show_help
			;;
		-p | --proxy)
			PROXY_URL="$2"
			shift 2
			;;
		-d | --dir)
			INSTALL_DIR="$2"
			shift 2
			;;
		-t | --temp)
			TEMP_DIR="$2"
			shift 2
			;;
		-l | --log)
			LOG_FILE="$2"
			shift 2
			;;
		-y | --yes)
			AUTO_CONFIRM=1
			shift
			;;
		*)
			echo "Error: Unknown option $1"
			show_help
			exit 1
			;;
		esac
	done
}

confirm_install() {
	local tool_name="$1"
	if [ "$AUTO_CONFIRM" -eq 1 ]; then
		echo "Auto-confirmed installation of $tool_name" | tee -a "$LOG_FILE"
		return 0
	fi

	read -p "Install $tool_name? [Y/n] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Nn]$ ]]; then
		echo "Skipping $tool_name installation" | tee -a "$LOG_FILE"
		return 1
	fi
	return 0
}

init_setup() {
	mkdir -p "$INSTALL_DIR"
	mkdir -p "$TEMP_DIR"
	touch "$LOG_FILE"
	echo "$(date) - Installation started" >>"$LOG_FILE"

	if [ -n "$PROXY_URL" ]; then
		export HTTP_PROXY="$PROXY_URL"
		export HTTPS_PROXY="$PROXY_URL"
		echo "Using proxy: $PROXY_URL" >>"$LOG_FILE"

		if ! grep -q "HTTP_PROXY=" "$HOME/.bashrc"; then
			echo "export HTTP_PROXY=\"$PROXY_URL\"" >>"$HOME/.bashrc"
			echo "export HTTPS_PROXY=\"$PROXY_URL\"" >>"$HOME/.bashrc"
			echo "Added proxy settings to .bashrc" >>"$LOG_FILE"
		fi
	fi

	if ! grep -q ".local/bin" "$HOME/.bashrc"; then
		echo 'export PATH=$PATH:$HOME/.local/bin' >>"$HOME/.bashrc"
		echo "Updated PATH in .bashrc" >>"$LOG_FILE"
	fi
}

download_with_proxy() {
	local url="$1"
	local output="$2"

	local curl_cmd=("curl" "-L")
	[ -n "$PROXY_URL" ] && curl_cmd+=("-x" "$PROXY_URL")

	if ! "${curl_cmd[@]}" "$url" -o "$output"; then
		echo "Download failed: $url" | tee -a "$LOG_FILE"
		exit 1
	fi
}

git_with_proxy() {
	local args=("$@")
	if [ -n "$PROXY_URL" ]; then
		git -c http.proxy="$PROXY_URL" "${args[@]}"
	else
		git "${args[@]}"
	fi
}

install_neovim_config() {
	echo "Installing neovim configuration..." | tee -a "$LOG_FILE"

	if [ ! -d "$NVIM_CONFIG_DIR" ]; then
		git_with_proxy clone https://github.com/konosubakonoakua/fei.nvim.git "$NVIM_CONFIG_DIR"
	else
		cd "$NVIM_CONFIG_DIR" && git_with_proxy pull
	fi

	if ! grep -q "alias fvim=" "$HOME/.bashrc"; then
		echo 'alias fvim='"'"'NVIM_APPNAME="fei.nvim" nvim'"'"'' >>"$HOME/.bashrc"
		echo "Added fvim alias to .bashrc" >>"$LOG_FILE"
	fi
}

install_from_github() {
	local repo="$1"
	local pattern="$2"
	local binary_name="$3"
	local target_name="${4:-$binary_name}"

	echo "Installing $target_name..." | tee -a "$LOG_FILE"
	local tool_dir="$TEMP_DIR/$target_name"
	mkdir -p "$tool_dir"
	cd "$tool_dir" || exit 1

	# Get download URL (exclude .sha256 files)
	local api_url="https://api.github.com/repos/$repo/releases/latest"
	local download_url
	download_url=$(curl ${PROXY_URL:+-x $PROXY_URL} -s "$api_url" |
		grep -Po '"browser_download_url": "\K[^"]*' |
		grep "$pattern" | grep -v "\.sha256")

	[ -z "$download_url" ] && {
		echo "Failed to get download URL for $target_name from $api_url" | tee -a "$LOG_FILE"
		exit 1
	}

	# Download package
	local package_file="${download_url##*/}"
	download_with_proxy "$download_url" "$package_file"

	# Verify file type and extract
	case "$package_file" in
	*.tar.gz | *.tgz)
		echo "Extracting gzip compressed tar archive..." | tee -a "$LOG_FILE"
		if ! tar -xzf "$package_file"; then
			echo "Failed to extract $package_file" | tee -a "$LOG_FILE"
			exit 1
		fi
		;;
	*.zip)
		echo "Extracting zip archive..." | tee -a "$LOG_FILE"
		if ! unzip -o "$package_file"; then
			echo "Failed to extract $package_file" | tee -a "$LOG_FILE"
			exit 1
		fi
		;;
	*.gz)
		echo "Extracting gzip file..." | tee -a "$LOG_FILE"
		if ! gzip -d "$package_file"; then
			echo "Failed to extract $package_file" | tee -a "$LOG_FILE"
			exit 1
		fi
		;;
	*)
		echo "Unsupported archive format: $package_file" | tee -a "$LOG_FILE"
		exit 1
		;;
	esac

	# Find and copy binary (with more flexible search)
	local binary_path=$(find "$tool_dir" -type f \( -name "$binary_name" -o -name "$binary_name.exe" \) | head -1)
	if [ -n "$binary_path" ]; then
		chmod +x "$binary_path"
		cp -f "$binary_path" "$INSTALL_DIR/$target_name"
		echo "Successfully installed $target_name as $INSTALL_DIR/$target_name" | tee -a "$LOG_FILE"
	else
		echo "Binary $binary_name not found in package (looking for: $binary_name, wanted as: $target_name)" | tee -a "$LOG_FILE"
		exit 1
	fi
}

install_fzf() {
	echo "Installing fzf..." | tee -a "$LOG_FILE"
	git_with_proxy clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
}

install_fnm() {
	echo "Installing fnm..." | tee -a "$LOG_FILE"

	# Download fnm
	curl -fsSL https://fnm.vercel.app/install -o "/tmp/fnm-install.sh"
	chmod +x "/tmp/fnm-install.sh"

	# Run installation with custom directory
	"/tmp/fnm-install.sh" --install-dir "$INSTALL_DIR" --skip-shell >>"$LOG_FILE" 2>&1

	# Add to PATH if not present
	if ! grep -q "FNM_PATH=" "$HOME/.bashrc"; then
		cat <<EOF >>"$HOME/.bashrc"

# fnm
export FNM_PATH="$INSTALL_DIR"
export PATH="\$FNM_PATH:\$PATH"
eval "\$(fnm env --use-on-cd --shell bash)"
EOF
	fi

	# Source bashrc to load fnm immediately
	source "$HOME/.bashrc"
}

install_nodejs() {
	echo "Installing Node.js..." | tee -a "$LOG_FILE"

	# Check if fnm is available
	if ! command -v fnm &>/dev/null; then
		echo "Error: fnm command not found" | tee -a "$LOG_FILE"
		exit 1
	fi

	# Install Node.js
	fnm install --lts >>"$LOG_FILE" 2>&1
	fnm use default >>"$LOG_FILE" 2>&1

	# Verify installation
	if ! command -v node &>/dev/null; then
		echo "Error: Node.js installation failed" | tee -a "$LOG_FILE"
		exit 1
	fi

	# Set npm registry
	npm config set registry https://registry.npmmirror.com >>"$LOG_FILE" 2>&1

	echo "Node.js $(node --version) installed successfully" | tee -a "$LOG_FILE"
	echo "npm $(npm --version) configured" | tee -a "$LOG_FILE"
}

install_fonts() {
	echo "Installing fonts..." | tee -a "$LOG_FILE"
	local font_dir="$HOME/.fonts"
	mkdir -p "$font_dir"

	download_with_proxy \
		https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Lilex.zip \
		"$TEMP_DIR/Lilex.zip"

	unzip -o "$TEMP_DIR/Lilex.zip" -d "$font_dir"
	find "$font_dir" -name "*.md" -delete
	find "$font_dir" -name "*.txt" -delete
	fc-cache -fv
}

install_neovim() {
	echo "Installing neovim..." | tee -a "$LOG_FILE"
	download_with_proxy \
		https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
		"$TEMP_DIR/nvim.tar.gz"

	sudo rm -rf /opt/nvim-linux-x86_64
	sudo tar -C /opt -xzf "$TEMP_DIR/nvim.tar.gz"

	if ! grep -q "/opt/nvim-linux-x86_64/bin" "$HOME/.bashrc"; then
		echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >>"$HOME/.bashrc"
	fi
}

check_dependencies() {
	echo "Checking system dependencies..." | tee -a "$LOG_FILE"
	local dependencies=("python3-venv" "xsel" "ffmpeg" "7zip" "poppler-utils" "imagemagick")

	# Check if system is Debian-based
	local is_debian_based=false
	if [ -f /etc/debian_version ] || grep -q "Ubuntu" /etc/os-release 2>/dev/null || grep -q "Debian" /etc/os-release 2>/dev/null; then
		is_debian_based=true
		echo "Detected Debian-based system" | tee -a "$LOG_FILE"
	fi

	# Check basic dependencies
	for dep in "${dependencies[@]}"; do
		local is_installed=false

		if [ "$is_debian_based" = true ] && command -v dpkg &>/dev/null; then
			if dpkg -l | grep -q "^ii  $dep "; then
				is_installed=true
			fi
		else
			is_installed=false
		fi

		if [ "$is_installed" = false ]; then
			echo "$dep not found" | tee -a "$LOG_FILE"

			if [ "$is_debian_based" = true ] && command -v apt &>/dev/null; then
				echo "Installing $dep using apt..." | tee -a "$LOG_FILE"
				sudo apt-get update >>"$LOG_FILE" 2>&1
				sudo apt-get install -y "$dep" >>"$LOG_FILE" 2>&1 || {
					echo "Failed to install $dep" | tee -a "$LOG_FILE"
					exit 1
				}
				echo "$dep installed successfully" | tee -a "$LOG_FILE"
			else
				echo "Please install $dep manually for your system" | tee -a "$LOG_FILE"
				echo "On Debian/Ubuntu: sudo apt install $dep" | tee -a "$LOG_FILE"
				echo "On Red Hat/Fedora: sudo dnf install $dep" | tee -a "$LOG_FILE"
				echo "On Arch Linux: sudo pacman -S $dep" | tee -a "$LOG_FILE"
				exit 1
			fi
		fi
	done

	# Check libc version
	echo "Verifying libc version..." | tee -a "$LOG_FILE"
	local min_libc_version="2.27" # Minimum required by neovim
	local current_libc_version=$(ldd --version | head -n1 | grep -oE 'GLIBC[[:space:]]+[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+')

	if [ -z "$current_libc_version" ]; then
		echo "Warning: Could not determine libc version" | tee -a "$LOG_FILE"
		return
	fi

	echo "Current libc version: $current_libc_version" | tee -a "$LOG_FILE"
	echo "Required minimum libc version: $min_libc_version" | tee -a "$LOG_FILE"

	if ! printf '%s\n%s\n' "$min_libc_version" "$current_libc_version" | sort -V -C; then
		echo "Error: libc version $current_libc_version is lower than required $min_libc_version" | tee -a "$LOG_FILE"
		echo "Please upgrade your system or use a different installation method" | tee -a "$LOG_FILE"
		exit 1
	fi
}

install_jq() {
	echo "Installing jq JSON processor..." | tee -a "$LOG_FILE"

	# Check if jq is already installed
	if command -v jq &>/dev/null; then
		echo "jq is already installed" | tee -a "$LOG_FILE"
	fi

	# Create temporary directory
	local jq_dir="$TEMP_DIR/jq"
	mkdir -p "$jq_dir"
	cd "$jq_dir" || exit 1

	# Direct download URL
	local jq_url="https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64"

	# Download jq binary
	echo "Downloading jq binary..." | tee -a "$LOG_FILE"
	download_with_proxy "$jq_url" "jq"

	# Install jq
	chmod +x jq
	cp -f jq "$INSTALL_DIR/jq"

	echo "jq installed successfully to $INSTALL_DIR/jq" | tee -a "$LOG_FILE"
}

install_yazi() {
	echo "Installing yazi file manager..." | tee -a "$LOG_FILE"

	# Check if yazi is already installed
	if command -v yazi &>/dev/null; then
		echo "yazi is already installed" | tee -a "$LOG_FILE"
	fi

	# Create temporary directory
	local yazi_dir="$TEMP_DIR/yazi"
	mkdir -p "$yazi_dir"
	cd "$yazi_dir" || exit 1

	# Direct download URL
	local yazi_url="https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip"

	# Download yazi
	local package_file="yazi.zip"
	download_with_proxy "$yazi_url" "$package_file"

	# Extract package
	echo "Extracting yazi package..." | tee -a "$LOG_FILE"
	if ! unzip -o "$package_file"; then
		echo "Failed to extract yazi package" | tee -a "$LOG_FILE"
		exit 1
	fi

	# Install both yazi and ya binaries
	local binaries_installed=0

	# Install yazi binary
	local yazi_binary=$(find "$yazi_dir" -name "yazi" -type f | head -1)
	if [ -n "$yazi_binary" ]; then
		chmod +x "$yazi_binary"
		cp -f "$yazi_binary" "$INSTALL_DIR/yazi"
		echo "Installed yazi binary to $INSTALL_DIR/yazi" | tee -a "$LOG_FILE"
		binaries_installed=1
	else
		echo "Warning: yazi binary not found in package" | tee -a "$LOG_FILE"
	fi

	# Install ya binary
	local ya_binary=$(find "$yazi_dir" -name "ya" -type f | head -1)
	if [ -n "$ya_binary" ]; then
		chmod +x "$ya_binary"
		cp -f "$ya_binary" "$INSTALL_DIR/ya"
		echo "Installed ya binary to $INSTALL_DIR/ya" | tee -a "$LOG_FILE"
		binaries_installed=1
	else
		echo "Warning: ya binary not found in package" | tee -a "$LOG_FILE"
	fi

	if [ "$binaries_installed" -eq 0 ]; then
		echo "Error: No yazi binaries found in package" | tee -a "$LOG_FILE"
		exit 1
	fi

	# Install bash completions
	local completion_file=$(find "$yazi_dir" -name "ya.bash" | head -1)
	if [ -n "$completion_file" ]; then
		local completion_dir="$HOME/.config/bash_completion"
		mkdir -p "$completion_dir"
		cp -f "$completion_file" "$completion_dir/yazi.bash"
		echo "Installed yazi bash completions to $completion_dir/yazi.bash" | tee -a "$LOG_FILE"
	else
		echo "Warning: yazi bash completions not found" | tee -a "$LOG_FILE"
	fi

	echo "yazi installed successfully" | tee -a "$LOG_FILE"
}

configure_yazi() {
	echo "Configuring yazi shell integration..." | tee -a "$LOG_FILE"

	# Check if yazi is installed
	if ! command -v yazi &>/dev/null; then
		echo "Warning: yazi not found, skipping configuration" | tee -a "$LOG_FILE"
		return 0
	fi

	# Check if yazi configuration already exists
	if grep -q "function y()" "$HOME/.bashrc"; then
		echo "yazi configuration already exists in .bashrc" | tee -a "$LOG_FILE"
		return 0
	fi

	# Add yazi configuration to .bashrc
	cat <<'EOF' >>"$HOME/.bashrc"

# yazi - terminal file manager
if command -v yazi &>/dev/null; then
    alias yz="y"
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi
EOF

	# Source bash completions
	local completion_dir="$HOME/.config/bash_completion"
	if [ -f "$completion_dir/yazi.bash" ]; then
		source "$completion_dir/yazi.bash"
		echo "Loaded yazi bash completions" | tee -a "$LOG_FILE"
	fi

	echo "yazi shell integration configured" | tee -a "$LOG_FILE"
}

configure_starship() {
	echo "Configuring starship prompt..." | tee -a "$LOG_FILE"

	# Check if starship init is already in bashrc
	if grep -q "starship init bash" "$HOME/.bashrc"; then
		echo "starship configuration already exists in .bashrc" | tee -a "$LOG_FILE"
		return 0
	fi

	# Add starship configuration to bashrc
	cat <<EOF >>"$HOME/.bashrc"

# starship prompt
if command -v starship &>/dev/null; then
    eval "\$(starship init bash)"
fi
EOF

	echo "starship prompt configured" | tee -a "$LOG_FILE"
}

configure_zoxide() {
	echo "Configuring zoxide shell integration..." | tee -a "$LOG_FILE"

	# Check if zoxide is installed
	if ! command -v zoxide &>/dev/null; then
		echo "Warning: zoxide not found, skipping configuration" | tee -a "$LOG_FILE"
		return 0
	fi

	# Check if zoxide init is already in bashrc
	if grep -q "zoxide init bash" "$HOME/.bashrc"; then
		echo "zoxide configuration already exists in .bashrc" | tee -a "$LOG_FILE"
		return 0
	fi

	# Remove any existing zoxide configuration (cleanup)
	sed -i '/zoxide init bash/d' "$HOME/.bashrc"

	# Add zoxide configuration as the last line in bashrc
	echo -e "\n# zoxide - smarter cd command\nif command -v zoxide &>/dev/null; then\n    eval \"\$(zoxide init bash)\"\nfi" >>"$HOME/.bashrc"

	echo "zoxide shell integration configured (added to end of .bashrc)" | tee -a "$LOG_FILE"
}

main() {
	parse_args "$@"
	init_setup
	check_dependencies

	if confirm_install "fzf"; then
		install_fzf
	fi

	if confirm_install "fnm"; then
		install_fnm
	fi

	if confirm_install "node.js"; then
		install_nodejs
	fi

	if confirm_install "fonts"; then
		install_fonts
	fi

	declare -A github_tools=(
		["tree-sitter/tree-sitter"]="tree-sitter-linux-x64.gz tree-sitter-linux-x64 tree-sitter"
		["zellij-org/zellij"]="zellij-x86_64-unknown-linux-musl.tar.gz zellij zellij"
		["cli/cli"]="linux_amd64.tar.gz gh gh"
		["BurntSushi/ripgrep"]="x86_64-unknown-linux-musl.tar.gz rg rg"
		["sharkdp/fd"]="x86_64-unknown-linux-musl.tar.gz fd fd"
		["ajeetdsouza/zoxide"]="x86_64-unknown-linux-musl.tar.gz zoxide zoxide"
		["starship/starship"]="starship-x86_64-unknown-linux-musl.tar.gz starship starship"
		["jesseduffield/lazygit"]="linux_x86_64.tar.gz lazygit lazygit"
		["wakatime/wakatime-cli"]="wakatime-cli-linux-amd64.zip wakatime-cli-linux-amd64 wakatime-cli"
	)

	for repo in "${!github_tools[@]}"; do
		IFS=' ' read -r pattern binary_name target_name <<<"${github_tools[$repo]}"
		if confirm_install "$target_name"; then
			install_from_github "$repo" "$pattern" "$binary_name" "$target_name"
		fi
	done

	if confirm_install "neovim"; then
		install_neovim
	fi

	if confirm_install "yazi"; then
		install_yazi
		install_jq
	fi

	if command -v nvim &>/dev/null; then
		if confirm_install "neovim configuration"; then
			install_neovim_config
		fi
	fi

	if command -v starship &>/dev/null; then
		if confirm_install "starship prompt configuration"; then
			configure_starship
		fi
	fi

	if command -v yazi &>/dev/null; then
		if confirm_install "yazi shell integration"; then
			configure_yazi
		fi
	fi

	if command -v zoxide &>/dev/null; then
		if confirm_install "zoxide shell integration"; then
			configure_zoxide
		fi
	fi

	source "$HOME/.bashrc"
	echo "$(date) - Installation completed" >>"$LOG_FILE"
	echo "All selected tools installed successfully!" | tee -a "$LOG_FILE"
	echo "Use 'fvim' for configured neovim, and 'nvim' for vanilla neovim"
}

main "$@"
