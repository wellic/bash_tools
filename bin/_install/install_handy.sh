#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

OPT_VERSION=--help



TOOL_NAME=handy
REPO_PATH=cjpais/Handy
MASK=$DEF_MASK_AMD64_DEB


get_current_version() {
 dpkg -s $TOOL_NAME | grep "Version:" | _normalize_version
}

SHOW_COMPLETION=0


_main
