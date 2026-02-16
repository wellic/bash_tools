#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=yamlfmt
REPO_PATH=google/yamlfmt
MASK=${DEF_MASK_X86_64_TAR_GZ}
OPT_VERSION=-version

TAR_STRIP_COMPONENTS=0
SRC_BIN_FILE="$TOOL_NAME"
DST_BIN_FILE="${FOUND_TOOL_DIR:-$DST_DIR}/$TOOL_NAME"

_main
