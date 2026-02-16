#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

VERSION=${1:-"."}
################################################################################


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

VERSION=${1:-continuous}

TOOL_NAME=ksnip
REPO_PATH=ksnip/ksnip
MASK=$DEF_MASK_DEB

BEFORE_INSTALL_CMD+=("sudo pkill ksnip")
_main

