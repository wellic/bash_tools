#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=dbeaver
repo=dbeaver/dbeaver
mask=$def_mask_amd64_deb

_main
