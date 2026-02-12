#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=cdxgen
OPT_VERSION=--version
repo=cdxgen/cdxgen
mask=$def_mask_bin

mask='browser_download_url.*'${tool_name}'[_-][Ll]inux[_-]amd64"'

dst_file=/usr/local/bin/${tool_name}

get_current_version() {
  "$tool_name" $OPT_VERSION | grep -Po "CycloneDX Generator\s+\K([^\s]+)$" | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
