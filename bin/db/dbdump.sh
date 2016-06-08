#!/bin/bash

set -u
set -e
#set -x
#set -v
#mysqldump -u root -p --all-databases > all_dbs.sql

MYSQL_USER=root
MYSQL_PASSWORD=root
BACKUP_DIR=backup

#opt="--force --opt -C --extended-insert=0"
opt="--force --opt -C"

if [ $# -eq 1 ] ; then 
  databases="$1"  
else
  MYSQL_USER=${1:-root}
  MYSQL_PASSWORD=${2:-root}
  BACKUP_DIR=${3:-backup}
  databases=${4:-}  
fi
BACKUP_DIR=$(readlink -m "$BACKUP_DIR")

MYSQL=$(which mysql)
MYSQLDUMP=$(which mysqldump)
[ -z "$MYSQL" -o -z "$MYSQLDUMP" ] && exit 1
 
TIMESTAMP=$(date +"%F_%H%M%S")
BACKUP_DIR="$BACKUP_DIR/$TIMESTAMP"
echo "$BACKUP_DIR"
[ ! -d "$BACKUP_DIR/mysql" ] && mkdir -p "$BACKUP_DIR/mysql"
 
[ -z "$databases" ] && databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
 
set -v
for db in $databases; do
  echo "$MYSQLDUMP $opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db"
  $MYSQLDUMP $opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
done
