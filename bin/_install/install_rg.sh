#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=rg
repo=BurntSushi/ripgrep
mask=$def_mask_amd64_deb

OPT_VERSION=--version
COMPLETION_OPT="--generate=complete-bash"
COMPLETION_LNG=""

get_current_version() {
 # shellcheck disable=SC2086
"$tool_name" $OPT_VERSION | head -n1 | grep -Po '^ripgrep \K(\S+)'
}

_main
