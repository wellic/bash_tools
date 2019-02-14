#!/usr/bin/env bash

set -u
#set -x

user=wellic
app=/home/$user/bin/backup/apt_backup

[ -x "$app" ] || exit 1

DEF_BACKUP_DIR=/media/$user/ssd_backup_$user/backup_apt_clone

BACKUP_DIR=${1:-$DEF_BACKUP_DIR}
[ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"

BACKUP_DIR=`realpath -s $BACKUP_DIR`

"$app" -s "$BACKUP_DIR"
#"$app" -l "$BACKUP_DIR"
"$app" -s "$BACKUP_DIR" latest
#"$app" -f "$BACKUP_DIR"

#/home/wellic/bin/backup/apt_backup -s "$BACKUP_DIR" latest
#/home/wellic/bin/backup/apt_backup -f "$BACKUP_DIR

chown -R "$user:$user" "$BACKUP_DIR/"
