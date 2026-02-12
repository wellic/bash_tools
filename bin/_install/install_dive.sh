#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=dive
repo=wagoodman/dive
mask=$def_mask_amd64_deb

_main
