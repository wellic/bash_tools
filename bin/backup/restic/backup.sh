#!/usr/bin/env bash

set -u

debug_mode=${1:-0}

./restic_backup_all "$debug_mode"
