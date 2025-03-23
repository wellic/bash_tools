#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}

get_current_version() {
  "$tool_name" $OPT_VERSION -s | grep -P '^Version\s+v(\d+.*)$' | _normalize_version
}

tool_name=k9s
OPT_VERSION=version
repo=derailed/k9s
mask=$def_mask_amd64_deb

_main
