#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=shfmt
OPT_VERSION="--version"
REPO_PATH=mvdan/sh
MASK=$DEF_MASK_BIN

dst_file=/usr/local/bin/${TOOL_NAME}

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | grep -iPo 'v(\d+.*)' | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
