#!/bin/bash
set -euo pipefail

: ${INSTALL_DIR:="$HOME/.local/bin"}
: ${TEMP_DIR:="$HOME/Downloads/tools-install"}
: ${LOG_FILE:="$TEMP_DIR/install.log"}
: ${NVIM_CONFIG_DIR:="$HOME/.config/fei.nvim"}
: ${PROXY_URL:=""}
: ${AUTO_CONFIRM:=0} # Default: manual confirmation

# ---------------- GitHub tools manifest (all via gh_install_exec) ----------------
# Record format (semicolon-separated):
#   key;repo;asset_tpl;binspec;maps;version
# - maps: optional, comma-separated "bin:target" items. Leave empty for no maps.
# - binspec: space-separated bins inside the archive (as gh_install_exec expects).
# - version: optional. Use "latest" or a fixed version ("1.2.3" or "v1.2.3").
#
# Notes:
# - Use "{INSTALL_DIR}" placeholder in maps to avoid early expansion before --dir overrides.
# - Assets may or may not contain "{ver}". Version control is done via --version (tag), not only filename.
GITHUB_TOOLS=(
	"zellij;zellij-org/zellij;zellij-x86_64-unknown-linux-musl.tar.gz;zellij;;latest"
	"gh;cli/cli;gh_{ver}_linux_amd64.tar.gz;gh;;latest"
	"rg;BurntSushi/ripgrep;ripgrep-{ver}-x86_64-unknown-linux-musl.tar.gz;rg;;latest"
	"fd;sharkdp/fd;fd-v{ver}-x86_64-unknown-linux-musl.tar.gz;fd;;latest"
	"zoxide;ajeetdsouza/zoxide;zoxide-{ver}-x86_64-unknown-linux-musl.tar.gz;zoxide;;latest"
	"starship;starship/starship;starship-x86_64-unknown-linux-musl.tar.gz;starship;;latest"
	"lazygit;jesseduffield/lazygit;lazygit_{ver}_Linux_x86_64.tar.gz;lazygit;;latest"

	# yazi: asset has no {ver}, but versions are still controlled by tag via --version
	"yazi;sxyazi/yazi;yazi-x86_64-unknown-linux-musl.zip;ya yazi;ya:{INSTALL_DIR}/ya,yazi:{INSTALL_DIR}/yazi;latest"

	# wakatime-cli: archive binary name != desired final name
	"wakatime-cli;wakatime/wakatime-cli;wakatime-cli-linux-amd64.zip;wakatime-cli-linux-amd64;wakatime-cli-linux-amd64:{INSTALL_DIR}/wakatime-cli;latest"
)

# ---------------- logging ----------------
log() { echo -e "\033[1;32m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*" >&2; }
err() { echo -e "\033[1;31m[ERR ]\033[0m $*" >&2; }
die() { err "$*"; exit 1; }

# ---------------- file helpers ----------------
append_once() {
	local line="$1"
	local file="$2"
	mkdir -p "$(dirname "$file")"
	touch "$file"
	grep -Fxq "$line" "$file" || echo "$line" >>"$file"
}

download_with_proxy() {
	local url="$1"
	local out="$2"
	local curl_cmd=("curl" "-fsSL" "-L" "--retry" "3" "--retry-delay" "2")
	[[ -n "$PROXY_URL" ]] && curl_cmd+=("-x" "$PROXY_URL")
	"${curl_cmd[@]}" "$url" -o "$out" || die "Download failed: $url"
}

git_with_proxy() {
	if [[ -n "$PROXY_URL" ]]; then
		git -c http.proxy="$PROXY_URL" "$@"
	else
		git "$@"
	fi
}

confirm_install() {
	local tool="$1"
	if [[ "$AUTO_CONFIRM" -eq 1 ]]; then
		echo "Auto-confirmed installation: $tool" | tee -a "$LOG_FILE"
		return 0
	fi
	read -p "Install $tool? [Y/n] " -n 1 -r
	echo
	[[ ! $REPLY =~ ^[Nn]$ ]]
}

init_setup() {
	mkdir -p "$INSTALL_DIR" "$TEMP_DIR"
	touch "$LOG_FILE"
	echo "$(date) - Installation started" >>"$LOG_FILE"

	if [[ -n "$PROXY_URL" ]]; then
		export HTTP_PROXY="$PROXY_URL"
		export HTTPS_PROXY="$PROXY_URL"
		echo "Using proxy: $PROXY_URL" >>"$LOG_FILE"
		if ! grep -q 'export HTTP_PROXY=' "$HOME/.bashrc" 2>/dev/null; then
			{
				echo "export HTTP_PROXY=\"$PROXY_URL\""
				echo "export HTTPS_PROXY=\"$PROXY_URL\""
			} >>"$HOME/.bashrc"
			echo "Added proxy settings to .bashrc" >>"$LOG_FILE"
		fi
	fi

	append_once 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"
}

check_dependencies() {
	echo "Checking system dependencies..." | tee -a "$LOG_FILE"
	local deps=("git" "curl" "wget" "unzip" "gzip" "tar" "p7zip-full" "poppler-utils" "imagemagick" "python3-venv" "xsel" "ffmpeg" "build-essential")

	if [[ -f /etc/debian_version ]] || grep -qiE "ubuntu|debian" /etc/os-release 2>/dev/null; then
		for d in "${deps[@]}"; do
			dpkg -l | grep -q "^ii  $d " && continue
			echo "Installing dependency: $d" | tee -a "$LOG_FILE"
			sudo apt-get update >>"$LOG_FILE" 2>&1
			sudo apt-get install -y "$d" >>"$LOG_FILE" 2>&1
		done
	else
		warn "Non-Debian system detected; please ensure dependencies are installed: ${deps[*]}"
	fi
}

install_fzf() {
	echo "Installing fzf..." | tee -a "$LOG_FILE"
	[[ -d "$HOME/.fzf" ]] && { echo "fzf already exists at $HOME/.fzf" | tee -a "$LOG_FILE"; return 0; }
	git_with_proxy clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	"$HOME/.fzf/install" --all >>"$LOG_FILE" 2>&1 || true
}

install_fnm() {
	echo "Installing fnm..." | tee -a "$LOG_FILE"
	if command -v fnm >/dev/null 2>&1; then
		echo "fnm is already installed" | tee -a "$LOG_FILE"
		return 0
	fi
	curl -fsSL https://fnm.vercel.app/install -o "/tmp/fnm-install.sh"
	chmod +x "/tmp/fnm-install.sh"
	"/tmp/fnm-install.sh" --install-dir "$INSTALL_DIR" --skip-shell >>"$LOG_FILE" 2>&1

	if ! grep -q "FNM_PATH=" "$HOME/.bashrc" 2>/dev/null; then
		cat <<EOF >>"$HOME/.bashrc"

# fnm
export FNM_PATH="$INSTALL_DIR"
export PATH="\$FNM_PATH:\$PATH"
eval "\$(fnm env --use-on-cd --shell bash)"
EOF
	fi

	# shellcheck disable=SC1090
	source "$HOME/.bashrc" || true
}

install_nodejs() {
	echo "Installing Node.js..." | tee -a "$LOG_FILE"
	command -v fnm >/dev/null 2>&1 || die "fnm not found"
	fnm install --lts >>"$LOG_FILE" 2>&1
	fnm use default >>"$LOG_FILE" 2>&1
	command -v node >/dev/null 2>&1 || die "Node.js installation failed"
	npm config set registry https://registry.npmmirror.com >>"$LOG_FILE" 2>&1
}

install_fonts() {
	echo "Installing fonts..." | tee -a "$LOG_FILE"
	local font_dir="$HOME/.fonts"
	mkdir -p "$font_dir"
	download_with_proxy "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Lilex.zip" "$TEMP_DIR/Lilex.zip"
	unzip -o "$TEMP_DIR/Lilex.zip" -d "$font_dir" >>"$LOG_FILE" 2>&1
	find "$font_dir" -name "*.md" -delete
	find "$font_dir" -name "*.txt" -delete
	fc-cache -fv >>"$LOG_FILE" 2>&1 || true
}

install_neovim() {
	echo "Installing Neovim..." | tee -a "$LOG_FILE"
	local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
	download_with_proxy "$url" "$TEMP_DIR/nvim.tar.gz"
	sudo rm -rf /opt/nvim-linux-x86_64
	sudo tar -C /opt -xzf "$TEMP_DIR/nvim.tar.gz" >>"$LOG_FILE" 2>&1
	append_once 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' "$HOME/.bashrc"
}

install_neovim_config() {
	echo "Installing Neovim configuration..." | tee -a "$LOG_FILE"
	if [[ ! -d "$NVIM_CONFIG_DIR" ]]; then
		git_with_proxy clone https://github.com/konosubakonoakua/fei.nvim.git "$NVIM_CONFIG_DIR"
	else
		(cd "$NVIM_CONFIG_DIR" && git_with_proxy pull)
	fi
	append_once 'alias fvim='"'"'NVIM_APPNAME="fei.nvim" nvim'"'"'' "$HOME/.bashrc"
}

install_uv() {
	echo "Installing uv..." | tee -a "$LOG_FILE"
	command -v uv >/dev/null 2>&1 && { echo "uv is already installed" | tee -a "$LOG_FILE"; return 0; }
	curl -LsSf https://astral.sh/uv/install.sh | sh >>"$LOG_FILE" 2>&1 || true
}

install_jq() {
	echo "Installing jq..." | tee -a "$LOG_FILE"
	command -v jq >/dev/null 2>&1 && { echo "jq is already installed" | tee -a "$LOG_FILE"; return 0; }
	local jq_dir="$TEMP_DIR/jq"
	mkdir -p "$jq_dir"
	cd "$jq_dir"
	download_with_proxy "https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64" "jq"
	chmod +x jq
	cp -f jq "$INSTALL_DIR/jq"
}

configure_starship() {
	echo "Configuring starship prompt..." | tee -a "$LOG_FILE"
	append_once '' "$HOME/.bashrc"
	append_once '# starship prompt' "$HOME/.bashrc"
	append_once 'command -v starship &>/dev/null && eval "$(starship init bash)"' "$HOME/.bashrc"
}

configure_zoxide() {
	echo "Configuring zoxide shell integration..." | tee -a "$LOG_FILE"
	append_once '' "$HOME/.bashrc"
	append_once '# zoxide - smarter cd command' "$HOME/.bashrc"
	append_once 'command -v zoxide &>/dev/null && eval "$(zoxide init bash)"' "$HOME/.bashrc"
}

configure_yazi() {
	echo "Configuring yazi shell integration..." | tee -a "$LOG_FILE"
	grep -q "function y()" "$HOME/.bashrc" 2>/dev/null && { echo "yazi integration already exists" | tee -a "$LOG_FILE"; return 0; }
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
}

# ---------------- gh_install_exec ----------------
gh_install_exec() {
	# Download a GitHub release asset (tar.* or zip) and install one OR multiple executables from it.
	# - Avoids GitHub API:
	#     - For "latest": follows the redirect on "releases/latest" to discover the version
	#     - For a fixed version: downloads from "releases/download/<tag>/<asset>" directly
	# - Supports assets with or without {ver} in filename.
	# - Supports per-bin target mapping via repeatable --map:
	#       --map "foo:/usr/local/bin/x" --map "bar:/opt/bin/y"
	#       --map "foo:/usr/local/bin"   --map "bar:/opt/bin"   (dir targets OK -> auto append bin name)
	# - Auto-detect tag prefix (tries: v<ver> then <ver>) unless user explicitly provides it.
	# - No traps (no nested traps); manual cleanup.
	#
	# Bin spec forms:
	#   A) Plain bins string (space/comma):
	#        "foo bar"  or  "foo,bar"
	#      Target behavior:
	#        - Use --into <dir> to install all bins into a directory (recommended)
	#        - Without --into, default install dir is /usr/local/bin
	#
	#   B) Per-bin mapping (repeatable --map):
	#        --map "foo:/usr/local/bin/x" --map "bar:/opt/bin/y"
	#        --map "foo:/usr/local/bin"   --map "bar:/opt/bin"
	#
	# Usage:
	#   # single bin, install latest into dir (keeps name)
	#   gh_install_exec "BurntSushi/ripgrep" "ripgrep-{ver}-aarch64-unknown-linux-gnu.tar.gz" "rg" --into "/usr/local/bin/"
	#
	#   # single bin, install fixed version into dir
	#   gh_install_exec "BurntSushi/ripgrep" "ripgrep-{ver}-aarch64-unknown-linux-gnu.tar.gz" "rg" --into "/usr/local/bin/" --version "13.0.0"
	#
	#   # multi bin, install all into dir (latest)
	#   gh_install_exec "owner/repo" "pkg_{ver}_Linux_arm64.tar.gz" "foo bar" --into "/usr/local/bin"
	#
	#   # multi bin, per-bin target mapping (latest)
	#   gh_install_exec "sxyazi/yazi" "yazi-aarch64-unknown-linux-gnu.zip" "ya yazi" \
	#     --map "ya:/usr/local/bin/ya" \
	#     --map "yazi:/opt/bin/yazi"
	#
	#   # per-bin mapping to directories (auto appends bin name)
	#   gh_install_exec "sxyazi/yazi" "yazi-aarch64-unknown-linux-gnu.zip" "ya yazi" \
	#     --map "ya:/usr/local/bin" \
	#     --map "yazi:/opt/bin"
	#
	# Args:
	#   1) repo         owner/name
	#   2) asset_tpl    asset filename template (supports {ver})
	#   3) binspec      plain bins list: "bin1 bin2" or "bin1,bin2"
	#
	# Options:
	#   --into <dir>            Directory to install all bins (default: /usr/local/bin)
	#   --map <bin:target>      Repeatable per-bin override. Target can be:
	#                           - directory (exists or ends with '/'): installs to <target>/<bin>
	#                           - file path: installs to that file path (rename)
	#   --tag-prefix <prefix>   Tag prefix override. If omitted, auto-detect by trying "v" then "".
	#                           Use empty string to force no prefix: --tag-prefix ""
	#   --version <ver>         "latest" (default) or a fixed version ("1.2.3" or "v1.2.3")
	#   --                      End of options
	#
	# Behavior:
	# - Does not use GitHub API (no JSON parsing, no rate limit issues).
	# - Version substitution: {ver} uses numeric version without leading "v".
	# - Tag selection: controlled by --tag-prefix; default auto tries "v" then "".

	local repo="${1:-}"
	local asset_tpl="${2:-}"
	local binspec="${3:-}"
	[[ -n "$repo" && -n "$asset_tpl" && -n "$binspec" ]] || {
		log "Usage: gh_install_exec <owner/repo> <asset_template> <binspec> [--into DIR] [--map bin:target ...] [--tag-prefix P] [--version V]" >&2
		return 2
	}
	shift 3 || true

	local into_dir="/usr/local/bin"
	local tag_prefix="__AUTO__"
	local version="latest"
	local map_specs=()
	declare -A map_target=()

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--into) into_dir="${2:-}"; [[ -n "$into_dir" ]] || die "gh_install_exec: --into requires a value"; shift 2 ;;
		--map)  map_specs+=("${2:-}"); [[ -n "${2:-}" ]] || die "gh_install_exec: --map requires bin:target"; shift 2 ;;
		--tag-prefix) tag_prefix="${2-}"; shift 2 ;;
		--version) version="${2:-}"; [[ -n "$version" ]] || die "gh_install_exec: --version requires a value"; shift 2 ;;
		--) shift; break ;;
		*) die "gh_install_exec: unknown option: $1" ;;
		esac
	done

	command -v curl >/dev/null 2>&1 || { err "Missing: curl" >&2; return 127; }
	command -v install >/dev/null 2>&1 || { err "Missing: install" >&2; return 127; }
	command -v sed >/dev/null 2>&1 || { err "Missing: sed" >&2; return 127; }
	command -v find >/dev/null 2>&1 || { err "Missing: find" >&2; return 127; }

	binspec="${binspec//,/ }"
	# shellcheck disable=SC2206
	local bins=($binspec)
	[[ "${#bins[@]}" -gt 0 ]] || { err "[gh_install_exec] ERROR: empty binspec" >&2; return 2; }

	_gh__target_is_dir() { [[ "$1" == */ ]] || [[ -d "$1" ]]; }

	if [[ "${#map_specs[@]}" -gt 0 ]]; then
		local ms b t
		for ms in "${map_specs[@]}"; do
			[[ "$ms" == *:* ]] || die "gh_install_exec: invalid --map '$ms' (expected bin:target)"
			b="${ms%%:*}"; t="${ms#*:}"
			[[ -n "$b" && -n "$t" ]] || die "gh_install_exec: invalid --map '$ms' (expected bin:target)"
			map_target["$b"]="$t"
		done
	fi

	if [[ "${#bins[@]}" -gt 1 ]] && ! _gh__target_is_dir "$into_dir"; then
		die "gh_install_exec: --into must be a directory for multiple bins (got: $into_dir)"
	fi
	_gh__target_is_dir "$into_dir" && mkdir -p "$into_dir" 2>/dev/null || true

	local tmpd ver asset ext archive
	tmpd="$(mktemp -d "/tmp/gh_install.XXXXXX")" || { err "mktemp failed" >&2; return 1; }
	_gh__cleanup() { rm -rf "$tmpd" >/dev/null 2>&1 || true; }

	if [[ -z "$version" || "$version" == "latest" ]]; then
		ver="$(
			curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${repo}/releases/latest" |
				sed -n 's#.*/tag/[^0-9]*##p'
		)"
		[[ -n "$ver" ]] || { err "[gh_install_exec] ERROR: failed to detect latest version for ${repo}" >&2; _gh__cleanup; return 1; }
	else
		ver="${version#v}"
		[[ -n "$ver" ]] || { err "[gh_install_exec] ERROR: invalid version argument: '$version'" >&2; _gh__cleanup; return 1; }
	fi

	asset="${asset_tpl//\{ver\}/$ver}"

	ext=""
	case "$asset" in
	*.tar.gz|*.tgz) ext="tar.gz" ;;
	*.tar.xz|*.txz) ext="tar.xz" ;;
	*.tar.bz2|*.tbz2) ext="tar.bz2" ;;
	*.zip) ext="zip" ;;
	esac
	[[ -n "$ext" ]] || { err "[gh_install_exec] ERROR: unsupported asset type: $asset" >&2; _gh__cleanup; return 1; }

	archive="$tmpd/asset.$ext"

	local prefix_list=() ok=0 url tag
	if [[ "$tag_prefix" == "__AUTO__" ]]; then
		prefix_list=("v" "")
	else
		prefix_list=("$tag_prefix")
	fi

	for p in "${prefix_list[@]}"; do
		tag="${p}${ver}"
		url="https://github.com/${repo}/releases/download/${tag}/${asset}"
		log "[gh_install_exec] repo=${repo} ver=${ver} tag=${tag} asset=${asset}" >&2
		if curl -fsSL --retry 3 --retry-delay 2 -o "$archive" ${PROXY_URL:+-x "$PROXY_URL"} "$url"; then
			ok=1
			break
		fi
	done

	if [[ "$ok" -ne 1 ]]; then
		err "[gh_install_exec] ERROR: failed to download asset" >&2
		_gh__cleanup
		return 1
	fi

	case "$ext" in
	tar.gz|tar.xz|tar.bz2) tar -C "$tmpd" -xf "$archive" || { err "[gh_install_exec] ERROR: extract failed" >&2; _gh__cleanup; return 1; } ;;
	zip) unzip -q "$archive" -d "$tmpd" || { err "[gh_install_exec] ERROR: unzip failed" >&2; _gh__cleanup; return 1; } ;;
	esac

	local b found t dst
	for b in "${bins[@]}"; do
		found="$(find "$tmpd" -type f -name "$b" -perm -u+x 2>/dev/null | head -n1 || true)"
		[[ -n "$found" ]] || found="$(find "$tmpd" -type f -name "$b" 2>/dev/null | head -n1 || true)"
		[[ -n "$found" ]] || { err "[gh_install_exec] ERROR: '$b' not found in extracted archive" >&2; _gh__cleanup; return 1; }

		if [[ -n "${map_target[$b]:-}" ]]; then
			t="${map_target[$b]}"
			if _gh__target_is_dir "$t"; then
				mkdir -p "$t" 2>/dev/null || true
				dst="${t%/}/${b}"
			else
				mkdir -p "$(dirname "$t")" 2>/dev/null || true
				dst="$t"
			fi
		else
			dst="${into_dir%/}/${b}"
		fi

		install -m 0755 "$found" "$dst" || { err "[gh_install_exec] ERROR: install failed: $dst" >&2; _gh__cleanup; return 1; }
		log "[gh_install_exec] Installed: ${dst}" >&2
	done

	_gh__cleanup
	return 0
}

install_github_tools() {
	local rec key repo asset_tpl binspec maps ver
	for rec in "${GITHUB_TOOLS[@]}"; do
		IFS=';' read -r key repo asset_tpl binspec maps ver <<<"$rec"
		[[ -n "$key" ]] || continue

		if ! confirm_install "$key"; then
			echo "Skipping: $key" | tee -a "$LOG_FILE"
			continue
		fi

		[[ -z "${ver:-}" ]] && ver="latest"
		maps="${maps//\{INSTALL_DIR\}/$INSTALL_DIR}"

		echo "Installing ${key} (version: ${ver})..." | tee -a "$LOG_FILE"

		local args=( "$repo" "$asset_tpl" "$binspec" "--into" "$INSTALL_DIR" )
		[[ "$ver" != "latest" ]] && args+=( "--version" "$ver" )

		if [[ -n "$maps" ]]; then
			local IFS=',' m
			for m in $maps; do
				[[ -n "$m" ]] || continue
				args+=( "--map" "$m" )
			done
		fi

		gh_install_exec "${args[@]}"
	done
}

install_tree_sitter() {
	echo "Installing tree-sitter..." | tee -a "$LOG_FILE"
	local repo="tree-sitter/tree-sitter"
	local tag="$(
		curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${repo}/releases/latest" |
			sed -n 's#.*/tag/##p'
	)"
	[[ -n "$tag" ]] || die "Failed to detect latest tree-sitter tag"
	mkdir -p "$TEMP_DIR/tree-sitter"
	cd "$TEMP_DIR/tree-sitter"
	download_with_proxy "https://github.com/${repo}/releases/download/${tag}/tree-sitter-linux-x64.gz" "tree-sitter-linux-x64.gz"
	gzip -df "tree-sitter-linux-x64.gz"
	chmod +x "tree-sitter-linux-x64"
	cp -f "tree-sitter-linux-x64" "$INSTALL_DIR/tree-sitter"
}

parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-h|--help)
			cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -p, --proxy URL      Proxy for downloads (curl/git)
  -d, --dir DIR        Install directory (default: ~/.local/bin)
  -t, --temp DIR       Temp directory (default: ~/Downloads/tools-install)
  -l, --log FILE       Log file path
  -y, --yes            Auto-confirm
  --set KEY=VERSION    Override a manifest version (e.g. --set rg=15.1.0)

Example:
  $0 --yes --proxy http://127.0.0.1:7890
  $0 --set rg=15.1.0 --set yazi=v0.3.2
EOF
			exit 0
			;;
		-p|--proxy) PROXY_URL="$2"; shift 2 ;;
		-d|--dir) INSTALL_DIR="$2"; shift 2 ;;
		-t|--temp) TEMP_DIR="$2"; shift 2 ;;
		-l|--log) LOG_FILE="$2"; shift 2 ;;
		-y|--yes) AUTO_CONFIRM=1; shift ;;
		--set)
			# Override manifest version in-place: KEY=VER
			local kv="${2:-}"
			[[ "$kv" == *=* ]] || die "--set expects KEY=VERSION"
			local k="${kv%%=*}"
			local v="${kv#*=}"
			[[ -n "$k" && -n "$v" ]] || die "--set expects KEY=VERSION"
			# Rewrite GITHUB_TOOLS line for that key (keep other fields)
			local i rec key repo asset_tpl binspec maps ver
			for i in "${!GITHUB_TOOLS[@]}"; do
				rec="${GITHUB_TOOLS[$i]}"
				IFS=';' read -r key repo asset_tpl binspec maps ver <<<"$rec"
				if [[ "$key" == "$k" ]]; then
					GITHUB_TOOLS[$i]="${key};${repo};${asset_tpl};${binspec};${maps};${v}"
				fi
			done
			shift 2
			;;
		*) die "Unknown option: $1" ;;
		esac
	done
}

main() {
	parse_args "$@"
	init_setup
	check_dependencies

	if confirm_install "fzf"; then install_fzf; fi
	if confirm_install "fnm"; then install_fnm; fi
	if confirm_install "node.js"; then source "$HOME/.bashrc" || true; install_nodejs; fi
	if confirm_install "fonts"; then install_fonts; fi

	# GitHub tools (manifest)
	install_github_tools

	# Extras
	if confirm_install "tree-sitter"; then install_tree_sitter; fi
	if confirm_install "neovim"; then install_neovim; fi
	if confirm_install "jq"; then install_jq; fi
	if confirm_install "uv"; then install_uv; fi

	# Configs
	if command -v nvim >/dev/null 2>&1 && confirm_install "neovim configuration"; then install_neovim_config; fi
	if command -v starship >/dev/null 2>&1 && confirm_install "starship prompt configuration"; then configure_starship; fi
	if command -v yazi >/dev/null 2>&1 && confirm_install "yazi shell integration"; then configure_yazi; fi
	if command -v zoxide >/dev/null 2>&1 && confirm_install "zoxide shell integration"; then configure_zoxide; fi

	source "$HOME/.bashrc" || true
	echo "$(date) - Installation completed" >>"$LOG_FILE"
	echo "Done." | tee -a "$LOG_FILE"
}

main "$@"
