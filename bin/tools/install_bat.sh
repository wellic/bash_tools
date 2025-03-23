#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}

tool_name=bat
repo=sharkdp/bat
def_mask_amd64_deb="${def_mask}.*\/bat_.*amd64.deb"
mask=$def_mask_amd64_deb

_main
