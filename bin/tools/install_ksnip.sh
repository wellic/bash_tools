#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-continuous}

tool_name=ksnip
repo=ksnip/ksnip
mask=$def_mask_deb

before_install_cmd+=("sudo pkill ksnip")

_main
