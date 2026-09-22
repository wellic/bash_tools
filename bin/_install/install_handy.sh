#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

OPT_VERSION=--help

get_current_version() {
 dpkg -s handy | grep Version 
}


TOOL_NAME=handy
REPO_PATH=cjpais/Handy
MASK=$DEF_MASK_AMD64_DEB


SHOW_COMPLETION=0


_main
