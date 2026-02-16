#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=jq
#OPT_VERSION=version
REPO_PATH=jqlang/jq
MASK="$DEF_MASK_BIN"
DST_FILE="${DST_DIR}/${TOOL_NAME}"
SHOW_COMPLETION=0

get_current_version() {
    "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po 'jq-\K(\d+.*)$'
}

get_main_install_cmd() {
  _install_bin "$DST_FILE"
}

_main
