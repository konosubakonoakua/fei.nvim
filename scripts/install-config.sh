#!/bin/bash
# Install / update the fei.nvim *config only* (no tools, no fonts, no shell rc).
#
# Usage:
#   ./scripts/install-config.sh [--dir DIR] [--src URL] [--alias] [--no-alias]
#
#   --dir        target config dir (default: ~/.config/fei.nvim)
#   --src        source repo      (default: https://github.com/konosubakonoakua/fei.nvim.git)
#   --alias      add the `fvim` shell alias (default)
#   --no-alias   do not touch the shell rc (useful in CI)
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.config/fei.nvim}"
SRC_URL="${SRC_URL:-https://github.com/konosubakonoakua/fei.nvim.git}"
WRITE_ALIAS=1

log() { echo -e "\033[1;32m[INFO]\033[0m $*"; }

while [[ $# -gt 0 ]]; do
	case "$1" in
	-d | --dir) INSTALL_DIR="$2"; shift 2 ;;
	-s | --src) SRC_URL="$2"; shift 2 ;;
	--alias) WRITE_ALIAS=1; shift ;;
	--no-alias) WRITE_ALIAS=0; shift ;;
	-h | --help)
		grep '^#' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		exit 1
		;;
	esac
done

mkdir -p "$(dirname "$INSTALL_DIR")"
if [[ -d "$INSTALL_DIR/.git" ]]; then
	log "Updating existing config in $INSTALL_DIR"
	git -C "$INSTALL_DIR" pull --ff-only
else
	log "Cloning config into $INSTALL_DIR"
	git clone "$SRC_URL" "$INSTALL_DIR"
fi

if [[ "$WRITE_ALIAS" -eq 1 ]]; then
	RC_FILE="$HOME/.bashrc"
	touch "$RC_FILE"
	if ! grep -Fq 'NVIM_APPNAME="fei.nvim" nvim' "$RC_FILE"; then
		echo "alias fvim='NVIM_APPNAME=\"fei.nvim\" nvim'" >>"$RC_FILE"
		log "Added 'fvim' alias to $RC_FILE"
	fi
fi

log "Config installed at $INSTALL_DIR"
