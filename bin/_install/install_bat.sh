#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=bat
REPO_PATH=sharkdp/bat
DEF_MASK_AMD64_DEB="${DEF_MASK}.*\/bat_.*amd64.deb"
MASK=$DEF_MASK_AMD64_DEB

OPT_VERSION="--version"
COMPLETION_OPT="--completion"

get_current_version() {
 # shellcheck disable=SC2086
 "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po "^($TOOL_NAME )?\K(\S+)"
}

_main
