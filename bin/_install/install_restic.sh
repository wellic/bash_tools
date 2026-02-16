#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################


TOOL_NAME=restic
REPO_PATH=restic/restic
MASK=${DEF_MASK_AMD64_BZ2}
OPT_VERSION=version

DST=/usr/local/bin/restic

get_main_install_cmd() {
# dpkg2 -i '$downloaded_file'; \\
cat <<- EOF
 wget -q '$release_link' -O '$DOWNLOADED_FILE'; \\
 sudo cp '$DOWNLOADED_FILE' "$DST"; \\
 sudo chmod +x "$DST"; \\
 rm -v '$DOWNLOADED_FILE'
EOF
}


_main
