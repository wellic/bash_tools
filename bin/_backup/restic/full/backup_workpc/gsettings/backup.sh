#!/usr/bin/env bash

set -u;
set -e
#set -x;

dt=`date +"%Y%m%d_%H%M%S"`

user=${1:-wellic}

_copy() {
    local dst=$1

    if [ ! -d "$dst" ]; then
        sudo mkdir -p "$dst"
        sudo chown -R "$user:$user" "$dst"
    fi
    dst=`realpath -s $dst`
    sudo cp -vaT "$src" "$dst"
}

dst_root=/media/$user/ssd_backup_$user/backup_gsettings
if [ ! -d "$dst_root" ]; then
    sudo mkdir -p "$dst_root"
    sudo chown -R "$user:$user" "$dst_root"
fi

path=.config/dconf

src=/home/$user/$path
dst=$dst_root/$dt/$path
_copy "$dst"

sudo cp -vaT "$dst_root/$dt" "$dst_root/latest"
