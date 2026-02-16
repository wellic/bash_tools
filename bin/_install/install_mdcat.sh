#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

#get_current_version() {
#  local v
#  v="$("$tool_name" $OPT_VERSION || :)"
#  echo "$v" | grep -P '^mdcat\s+(\d+.*)$' | _normalize_version || :
#}

# https://github.com/swsnr/mdcat/releases/download/mdcat-2.7.1/mdcat-2.7.1-x86_64-unknown-linux-gnu.tar.gz

TOOL_NAME=mdcat
REPO_PATH=swsnr/mdcat
MASK="${DEF_MASK}.*x86_64-unknown-linux-gnu.tar.gz$"

OPT_VERSION=--version
COMPLETION_OPT=--completions

SRC_BIN_FILE="$TOOL_NAME"
DST_BIN_FILE="/usr/local/bin/$TOOL_NAME"

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | grep -Po '^mdcat\s+\K(\d+.*)$' | _normalize_version
}

_main
