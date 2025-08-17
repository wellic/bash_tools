#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}

tool_name=restic
repo=restic/restic
mask=${def_mask_amd64_bz2}
OPT_VERSION=version

DST=/usr/local/bin/restic

get_main_install_cmd() {
# dpkg2 -i '$downloaded_file'; \\
cat <<- EOF
 wget -q '$release_link' -O '$downloaded_file'; \\
 sudo cp '$downloaded_file' "$DST"; \\
 sudo chmod +x "$DST"; \\
 rm -v '$downloaded_file'
EOF
}


_main
