#!/usr/bin/env bash

set -u

debug_mode=${1:-0}

SCRIPT=$(readlink -e "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

RET_DIR=$PWD

cd "$SCRIPT_DIR"

dt=`date +"%Y%m%d_%H%M%S"`

./restic_backup_all $debug_mode | tee "log/${dt}.log"

cd "$RET_DIR"

