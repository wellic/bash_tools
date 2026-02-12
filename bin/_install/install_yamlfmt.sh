#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=yamlfmt
repo=google/yamlfmt
mask=${def_mask_x86_64_tar_gz}
OPT_VERSION=-version

tar_strip_components=0
SRC_BIN_FILE="$tool_name"
DST_BIN_FILE="/usr/local/bin/$tool_name"

_main
