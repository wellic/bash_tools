#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=yq
REPO_PATH=mikefarah/yq
MASK="$DEF_MASK_AMD64_TAR_GZ"

SRC_BIN_FILE="${TOOL_NAME}_linux_amd64"
DST_BIN_FILE="${DST_BIN_DIR}/${TOOL_NAME}"

get_current_version() {
    "$TOOL_NAME" $OPT_VERSION -s yq --version | head -n1 | cut -d ' ' -f 4 | sed -re 's/^v([0-9])/\1/'
}

_main
