#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################

TOOL_NAME=restic
REPO_PATH=restic/restic
MASK=${DEF_MASK_AMD64_BZ2}
OPT_VERSION=version

get_current_tool_dir
DST_FILE=${FOUND_TOOL_DIR:-$DST_DIR}/restic

get_main_install_cmd() {
cat <<- EOF
 wget -q '$RELEASE_LINK' -O '$DOWNLOADED_FILE'; \\
 sudo mv '$DOWNLOADED_FILE' '${DST_FILE}.bz2'; \\
 sudo bzip2 -fd "${DST_FILE}.bz2"; \\
 sudo chmod +x "$DST_FILE"; \\
 rm -rfv '$DOWNLOADED_FILE'
EOF
}

_main
