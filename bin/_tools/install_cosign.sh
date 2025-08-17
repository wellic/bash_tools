#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}


tool_name=cosign
OPT_VERSION=version
repo=sigstore/cosign
mask=$def_mask_bin

dst_file=/usr/local/bin/${tool_name}

get_current_version() {
  "$tool_name" $OPT_VERSION | grep -i 'GitVersion:' | grep -iPo 'v(\d+.*)' | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
