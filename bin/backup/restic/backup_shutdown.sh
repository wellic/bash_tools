#!/usr/bin/env bash

set -u


debug_mode=${1:-0}
do_shutdown=${2:-1}

./backup.sh "$debug_mode"

[ "$do_shutdown" = '1' ] && shutdown
