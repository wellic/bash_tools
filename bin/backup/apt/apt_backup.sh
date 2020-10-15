#!/usr/bin/env bash

#sudo apt install apt-clone
#https://itsecforu.ru/2018/09/17/резервное-копирование-установленных/

set -u
#set -x

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(readlink -e "$SCRIPT_DIR")
HOSTNAME=$(hostname -s)

DT=${1:-`date +%Y%m%d`}
FN=${2:-"apt-clone-state-$HOSTNAME"}
BACKDIR=${3:-"$SCRIPT_DIR"}

apt-clone clone --with-dpkg-status --with-dpkg-repack "$BACKDIR/${FN}.${DT}.tgz"
