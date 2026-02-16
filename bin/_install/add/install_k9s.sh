#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION -s | grep -P '^Version\s+v(\d+.*)$' | _normalize_version
}

#https://github.com/derailed/k9s/releases/download/v0.50.9/k9s_Linux_amd64.tar.gz

TOOL_NAME=k9s
OPT_VERSION=version
REPO_PATH=derailed/k9s
#MASK=$def_mask_amd64_deb

MASK=$DEF_MASK_AMD64_TAR_GZ
TAR_STRIP_COMPONENTS=0
SRC_BIN_FILE="$TOOL_NAME"
DST_BIN_FILE="${FOUND_TOOL_DIR:-$DST_DIR}/$TOOL_NAME"

_main
