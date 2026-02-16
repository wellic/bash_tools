#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=czkawka_cli
OPT_VERSION="--version"
REPO_PATH=qarmin/czkawka
MASK="${DEF_MASK}.*linux_${TOOL_NAME}_x86_64$"
get_current_tool_dir
DST_FILE=${FOUND_TOOL_DIR:-$DST_DIR}/${TOOL_NAME}
SHOW_COMPLETION=0
APP_SHOW_INFO=1

get_current_version() {
  [[ -n $FOUND_TOOL_DIR ]] || return 0
  "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po 'czkawka \K([\d\.]+)' | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$DST_FILE"
}

_main
