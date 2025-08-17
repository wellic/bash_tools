#!/bin/sh

LOGDIR="$HOME"/sites/var/log

find $LOGDIR -type f -exec sudo truncate -s 0 {} \;
sudo rm -f $LOGDIR/cachegrind.out*

