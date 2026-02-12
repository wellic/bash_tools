#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

get_current_version() {
  "$tool_name" $OPT_VERSION -s | grep -P '^Version\s+v(\d+.*)$' | _normalize_version
}

#https://github.com/derailed/k9s/releases/download/v0.50.9/k9s_Linux_amd64.tar.gz

tool_name=k9s
OPT_VERSION=version
repo=derailed/k9s
#mask=$def_mask_amd64_deb

mask=$def_mask_amd64_tar_gz
SRC_BIN_FILE="$tool_name"
DST_BIN_FILE="/usr/local/bin/$tool_name"

_main
