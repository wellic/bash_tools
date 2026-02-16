#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=zarf
OPT_VERSION=version
REPO_PATH=zarf-dev/zarf
MASK="$DEF_MASK_BIN"
dst_file=/usr/bin/${TOOL_NAME}

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
