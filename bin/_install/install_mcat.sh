#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

tool_name=mcat
OPT_VERSION=--version
COMPLETION_OPT="--generate bash"
repo=Skardyy/mcat
#def_mask_x86_64_tar_gz="${def_mask}.*x86_64-unknown-linux-gnu.tar.xz"
mask="${def_mask}.*x86_64-unknown-linux-gnu.tar.xz$"
tar_strip_components=1

SRC_BIN_FILE="$tool_name"
DST_BIN_FILE="${DST_BIN_DIR}/${tool_name}"

show_completion=1

#show_completion() {
#  cat <<- EOF
# # Add completion
#  echo "eval \"\$(fzf --bash)\""
#EOF
#}

get_current_version() {
  "$tool_name" $OPT_VERSION | head -n1 | grep -Po 'mcat \K(\S+)'
}

_main
