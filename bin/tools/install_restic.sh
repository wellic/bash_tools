#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u;
#set -x;

version=${1:-"."}

tool_name=restic
repo=restic/restic
mask=${def_mask}.*linux_amd64.bz2
OPT_VERSION=version

DST=/usr/local/bin/restic

get_main_install_cmd() {
# dpkg2 -i '$deb_file'; \\
cat <<- EOF
 wget -q '$release_link' -O '$deb_file'; \\
 sudo cp '$deb_file' "$DST"; \\
 sudo chmod +x "$DST"; \\
 rm -v '$deb_file'
EOF
}


_main
