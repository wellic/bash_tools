#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u
#set -x

version=${1:-continuous}

tool_name=ksnip
repo=ksnip/ksnip
mask=$def_mask_deb

before_install_cmd+=("sudo pkill ksnip")
_main

ok=https://github.com/ksnip/ksnip/releases/download/v1.10.0/ksnip-1.10.0.deb
app=https://github.com/ksnip/ksnip/releases/download/continuous/ksnip-1.11.0-continuous-x86_64.AppImage
echo "
 sudo pkill ksnip
 wget '$ok' -O /tmp/ksnip.deb

 sudo dpkg -i /tmp/ksnip.deb
 ks=\$(which ksnip)
 echo "\$ks"

 wget '$app' -O /tmp/ksnip.app
 sudo cp /tmp/ksnip.app \$ks
 sudo chmod +x \$ks

 sudo rm -v /tmp/ksnip.{deb,app}

"
