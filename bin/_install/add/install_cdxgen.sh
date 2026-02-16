#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=cdxgen
OPT_VERSION=--version
REPO_PATH=cdxgen/cdxgen
MASK="${DEF_MASK}.*${TOOL_NAME}[_-][Ll]inux[_-]amd64$"

dst_file=/usr/local/bin/${TOOL_NAME}

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | grep -Po "CycloneDX Generator\s+\K([^\s]+)$" | _normalize_version
}

get_main_install_cmd() {
  _install_bin "$dst_file"
}

_main
