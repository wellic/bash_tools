#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=rg
REPO_PATH=BurntSushi/ripgrep
MASK=$DEF_MASK_AMD64_DEB

OPT_VERSION=--version
COMPLETION_OPT="--generate=complete-bash"
COMPLETION_LNG=""

get_current_version() {
 # shellcheck disable=SC2086
"$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po '^ripgrep \K(\S+)'
}

_main
