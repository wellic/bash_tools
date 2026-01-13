#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/lib/_install_gh.sh"

set -u
#set -ueo pipefail;
#set -x;

version=${1:-"."}

#get_current_version() {
#  local v
#  v="$("$tool_name" $OPT_VERSION || :)"
#  echo "$v" | grep -P '^mdcat\s+(\d+.*)$' | _normalize_version || :
#}

# https://github.com/swsnr/mdcat/releases/download/mdcat-2.7.1/mdcat-2.7.1-x86_64-unknown-linux-gnu.tar.gz

tool_name=mdcat
repo=swsnr/mdcat
mask='browser_download_url.*[Ll]inux[_-]gnu.tar.gz'

OPT_VERSION=--version
COMPLETION_OPT=--completions

SRC_BIN_FILE="$tool_name"
DST_BIN_FILE="/usr/local/bin/$tool_name"

get_current_version() {
set -x
  "$tool_name" $OPT_VERSION | grep -Po '^mdcat\s+\K(\d+.*)$' | _normalize_version
set +x
}

_main
