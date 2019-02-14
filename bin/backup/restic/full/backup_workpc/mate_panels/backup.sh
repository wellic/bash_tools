#!/usr/bin/env bash

set -u
#set -x

user=wellic
app=/home/$user/bin/backup/backup_mate_panels

[ -x "$app" ] || exit 1

DEF_BACKUP_DIR=/media/$user/ssd_backup_$user/backup_mate_panels

BACKUP_DIR=${1:-$DEF_BACKUP_DIR}
[ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"

BACKUP_DIR=`realpath -s $BACKUP_DIR`

"$app" "$BACKUP_DIR"

chown -R "$user:$user" "$BACKUP_DIR/"
