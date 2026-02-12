#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################


tool_name=fzf
OPT_VERSION=--version
repo=junegunn/fzf
mask="$def_mask_amd64_tar_gz"
tar_strip_components=0

SRC_BIN_FILE="$tool_name"
DST_BIN_FILE="${DST_BIN_DIR}/${tool_name}"

show_completion=1

show_completion() {
  cat <<- EOF
 # Add completion
  echo "eval \"\$(fzf --bash)\""
EOF
}

get_current_version() {
 "$tool_name" $OPT_VERSION | head -n1 | grep -Eo '^(\S+)'
}

_main
