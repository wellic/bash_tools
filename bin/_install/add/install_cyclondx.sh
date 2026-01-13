#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/../_install/lib/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}


tool_name=cyclonedx
OPT_VERSION=--version
repo=CycloneDX/cyclonedx-cli
mask=$def_mask_bin_x64

dst_file=/usr/local/bin/${tool_name}

get_current_version() {
  "$tool_name" $OPT_VERSION | grep -Po '^(.*)(?=\+)' | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
