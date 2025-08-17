#!/usr/bin/env bash

set -uEeo pipefail
#set -x

DST=/usr/local/bin/move-to-next-monitor
sudo rm -rf $DST
sudo ln -s $HOME/bin/_device/move-to-next-monitor $DST

