#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/lib/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}

tool_name=jq
#OPT_VERSION=version
repo=jqlang/jq
mask="$def_mask_bin"
dst_file=/usr/local/bin/${tool_name}
show_completion=0

get_current_version() {
    "$tool_name" $OPT_VERSION | head -n1 | grep -Po 'jq-\K(\d+.*)$'
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
