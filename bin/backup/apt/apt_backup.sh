#!/usr/bin/env bash

#sudo apt install apt-clone
#https://itsecforu.ru/2018/09/17/резервное-копирование-установленных/

set -u
#set -x

SCRIPT=`realpath -s $0`
SCRIPT_DIR=`dirname $SCRIPT`
HOSTNAME=$(hostname -s)

DT=${1:-`date +%Y%m%d`}
FN=${2:-"apt_backup"}
BACKDIR=${3:-"$SCRIPT_DIR"}
ARC_NAME=$BACKDIR/${FN}.$HOSTNAME.${DT}.tgz
exit
apt-clone clone --with-dpkg-status --with-dpkg-repack "$ARC_NAME"
