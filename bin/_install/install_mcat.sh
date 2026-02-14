#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

TOOL_NAME=mcat
OPT_VERSION=--version
COMPLETION_OPT="--generate bash"
REPO_PATH=Skardyy/mcat
#def_mask_x86_64_tar_gz="${def_mask}.*x86_64-unknown-linux-gnu.tar.xz"
MASK="${DEF_MASK}.*x86_64-unknown-linux-gnu.tar.xz$"
TAR_STRIP_COMPONENTS=1

SRC_BIN_FILE="$TOOL_NAME"
DST_BIN_FILE="${DST_BIN_DIR}/${TOOL_NAME}"

SHOW_COMPLETION=1

#show_completion() {
#  cat <<- EOF
# # Add completion
#  echo "eval \"\$(fzf --bash)\""
#EOF
#}

get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po 'mcat \K(\S+)'
}

_main
