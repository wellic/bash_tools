#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}

tool_name=yq
#OPT_VERSION=version
repo=mikefarah/yq
mask="$def_mask_bin"
dst_file=/usr/local/bin/${tool_name}

get_current_version() {
    "$tool_name" $OPT_VERSION -s yq --version | head -n1 | cut -d ' ' -f 4 | sed -re 's/^v([0-9])/\1/'
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
