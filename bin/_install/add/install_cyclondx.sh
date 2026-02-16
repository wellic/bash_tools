#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=cyclonedx
OPT_VERSION=--version
REPO_PATH=CycloneDX/cyclonedx-cli
MASK=$DEF_MASK_BIN_X64

get_current_tool_dir
DST_FILE=${FOUND_TOOL_DIR:-$DST_DIR}/${TOOL_NAME}

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | grep -Po '^(.*)(?=\+)' | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$DST_FILE"
}

_main
