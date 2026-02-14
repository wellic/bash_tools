#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

TOOL_NAME=bat
REPO_PATH=sharkdp/bat
DEF_MASK_AMD64_DEB="${DEF_MASK}.*\/bat_.*amd64.deb"
MASK=$DEF_MASK_AMD64_DEB


COMPLETION_OPT=--completion

_main
