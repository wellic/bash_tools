#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=dive
REPO_PATH=wagoodman/dive
MASK=$DEF_MASK_AMD64_DEB

_main
