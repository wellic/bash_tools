#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

TOOL_NAME=czkawka_cli
OPT_VERSION="--version"
REPO_PATH=qarmin/czkawka
MASK="${DEF_MASK}.*linux_${TOOL_NAME}_x86_64$"
dst_file=/usr/local/bin/${TOOL_NAME}
SHOW_COMPLETION=0
APP_SHOW_INFO=1

get_current_version() {
  command -v "$TOOL_NAME" 1>/dev/null 2>&1 || return 0
  "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po 'version \K([\d\.]+)' | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
