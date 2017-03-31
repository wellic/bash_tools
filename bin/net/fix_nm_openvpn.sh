#!/bin/bash

#apt install network-manager-openvpn

#set -e
#set -x

if [ "$(whoami)" != "root" ]
then
  echo "You have to run this script as Superuser!"
  exit 1
fi

UP_DIR_SCRIPT=/usr/lib/NetworkManager
UP_FILENAME_SCRIPT=nm-openvpn-service-openvpn-helper
UP_FULLPATH_SCRIPT="$UP_DIR_SCRIPT/$UP_FILENAME_SCRIPT"

DOWN_DIR_SCRIPT=/etc/network/if-post-down.d
DOWN_FILENAME_SCRIPT=zz99_down_openvpn_helper
DOWN_FULLPATH_SCRIPT="$DOWN_DIR_SCRIPT/$DOWN_FILENAME_SCRIPT"

###############################################################################################

installUP() {
  if [ ! -e "$UP_FULLPATH_SCRIPT".orig -a -e "$UP_FULLPATH_SCRIPT" ]; then
      mv "$UP_FULLPATH_SCRIPT" "$UP_FULLPATH_SCRIPT".orig
  fi

#####################UP_SCRIPT1###########################
local script=$(cat <<UP_SCRIPT1
#!/bin/bash

/etc/openvpn/update-resolv-conf \$@
/usr/lib/NetworkManager/nm-openvpn-service-openvpn-helper.orig \$@

UP_SCRIPT1
)
##########################################################
    echo "$script" > "$UP_FILENAME_SCRIPT"
    chmod +x         "$UP_FILENAME_SCRIPT"
    chown root:root  "$UP_FILENAME_SCRIPT"
    mv               "$UP_FILENAME_SCRIPT" "$UP_FULLPATH_SCRIPT"
}

installDOWN() {
  if [ -e "$DOWN_FULLPATH_SCRIPT" ]; then
      rm "$DOWN_FULLPATH_SCRIPT"
  fi

#####################DOWN_SCRIPT1########################
local script=$(cat <<DOWN_SCRIPT1
#!/bin/bash

script_type=down dev=tun0 /etc/openvpn/update-resolv-conf

DOWN_SCRIPT1
)
##########################################################
    echo "$script" > "$DOWN_FILENAME_SCRIPT"
    chmod +x         "$DOWN_FILENAME_SCRIPT"
    chown root:root  "$DOWN_FILENAME_SCRIPT"
    mv               "$DOWN_FILENAME_SCRIPT" "$DOWN_FULLPATH_SCRIPT"
}

install() {
  installUP
  installDOWN
}

###############################################################################################
uninstallUP() {
    [ -e "$UP_FULLPATH_SCRIPT".orig ] && mv "$UP_FULLPATH_SCRIPT".orig "$UP_FULLPATH_SCRIPT"
}

uninstallDOWN() {
    [ -e "$DOWN_FULLPATH_SCRIPT" ] && rm "$DOWN_FULLPATH_SCRIPT"
}

uninstall() {
  uninstallUP
  uninstallDOWN
}
###############################################################################################

#install
if [ $# -gt 0 -a "$1" = 'install' ] || [ $# -gt 0 -a "$1" = 'on' ] || [ $# -gt 0 -a "$1" = '1' ]; then
    install
    exit 0
fi

#uninstall
if [ $# -gt 0 -a "$1" = 'uninstall' ] || [ $# -gt 0 -a "$1" = 'off' ] || [ $# -gt 0 -a "$1" = '0' ]; then
    uninstall
    exit 0
fi

echo "Usage: $0 install|uninstall"
