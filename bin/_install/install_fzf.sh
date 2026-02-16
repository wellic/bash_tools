#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################


TOOL_NAME=fzf
OPT_VERSION=--version
REPO_PATH=junegunn/fzf
MASK="$DEF_MASK_AMD64_TAR_GZ"
TAR_STRIP_COMPONENTS=0

SRC_BIN_FILE="$TOOL_NAME"
DST_BIN_FILE="${DST_BIN_DIR}/${TOOL_NAME}"

SHOW_COMPLETION=1

show_completion() {
  cat <<- EOF
 # Add completion
 echo "eval \"\$(fzf --bash)\""
EOF
}

get_current_version() {
 "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Eo '^(\S+)'
}

_main
