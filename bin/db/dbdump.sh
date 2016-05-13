#!/bin/bash

set -e
set -x
#mysqldump -u root -p --all-databases > all_dbs.sql

MYSQL_USER=${1:-root}
MYSQL_PASSWORD=${2:-root}
BACKUP_DIR=${3:-backup}
BACKUP_DIR=$(readlink -m "$BACKUP_DIR")

MYSQL=$(which mysql)
MYSQLDUMP=$(which mysqldump)
[ -z "$MYSQL" -o -z "$MYSQLDUMP" ] && exit 1
 
TIMESTAMP=$(date +"%F")
BACKUP_DIR="$BACKUP_DIR/$TIMESTAMP"
mkdir -p "$BACKUP_DIR/mysql"
 
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
 
for db in $databases; do
  $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
exit 2;
done
