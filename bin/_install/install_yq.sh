#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=yq
repo=mikefarah/yq
mask="$def_mask_amd64_tar_gz"

SRC_BIN_FILE="${tool_name}_linux_amd64"
DST_BIN_FILE="${DST_BIN_DIR}/${tool_name}"

get_current_version() {
    "$tool_name" $OPT_VERSION -s yq --version | head -n1 | cut -d ' ' -f 4 | sed -re 's/^v([0-9])/\1/'
}

_main
