#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_install_gh.sh"

set -u
#set -x

_tmp() {
echo "

 ok=https://github.com/ksnip/ksnip/releases/download/v1.10.0/ksnip-1.10.0.deb
 sudo pkill ksnip
 echo wget "\$ok" -O /tmp/ksnip.deb
      wget "\$ok" -O /tmp/ksnip.deb
 sudo dpkg -i /tmp/ksnip.deb

 app=https://github.com/ksnip/ksnip/releases/download/continuous/ksnip-1.11.0-continuous-x86_64.AppImage
 sudo pkill ksnip
 ks=\$(which ksnip)
 [[ -n \$ks ]] || ks=/usr/bin/ksnip
 echo "\$ks"
 echo wget "\$app" -O /tmp/ksnip.app
      wget "\$app" -O /tmp/ksnip.app
 sudo cp /tmp/ksnip.app \$ks
 sudo chmod +x \$ks

 sudo rm -fv /tmp/ksnip.{deb,app}
"
}
_tmp

version=${1:-continuous}

tool_name=ksnip
repo=ksnip/ksnip
mask=$def_mask_deb

before_install_cmd+=("sudo pkill ksnip")
_main

