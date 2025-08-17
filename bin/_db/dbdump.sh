#!/usr/bin/env bash

set -u
set -e
#set -x
#set -v
SCRIPT_NAME=$(basename "$0")

declare DB_DEF_USER=root
declare DB_DEF_PASS=root
declare BACKUP_DIR="backup/sql"

_lc() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

_help() {
local opt=${1:-}
if [ "$opt" = '-h' -o "$opt" = '--help' ] ; then
cat<<HELP
Usage: 
1) dump database 'dbname' using default of the script params: DB_USER, DB_PASS
   $ $SCRIPT_NAME dbname
2) dump all databases or dbname
   $ $SCRIPT_NAME dbuser dbpass [dbname]

HELP
exit 0
fi
}

if [ $# -ne 0 ] ; then
_help $1
fi

MYSQL=$(which mysql)
MYSQLDUMP=$(which mysqldump)
[ -z "$MYSQL" -o -z "$MYSQLDUMP" ] && exit 1

opt="--force --opt --compress --lock-tables"
#opt="--force --opt --compress --extended-insert=0"

if [ $# -eq 1 ] ; then 
  DBS="$1"  
  DB_USER="$DB_DEF_USER"
  DB_PASS="$DB_DEF_PASS"
else
  DB_USER=${1:-$DB_DEF_USER}
  DB_PASS=${2:-$DB_DEF_PASS}
  DBS=${3:-}  
fi
BACKUP_DIR=$(readlink -m "$BACKUP_DIR")

[ -z "$DB_USER" ] && exit 2

if [ -z "$DBS" ]; then  
echo -n -e "Do you want dump all databases for user $DB_USER? (Y/N)[N]: "
  read -n 2 YN
  YN=$(_lc ${YN:-N})
  [ "$YN" = 'y' ] || exit 3
  DBS=`$MYSQL -u$DB_USER -p$DB_PASS -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
fi

TIMESTAMP=$(date +"%F_%H%M%S")
BACKUP_DIR="$BACKUP_DIR/$TIMESTAMP"

echo -e "\nCreate folder: $BACKUP_DIR\n"
[ ! -d "$BACKUP_DIR" ] && mkdir -p "$BACKUP_DIR"
 
for db in $DBS; do
  echo "$MYSQLDUMP $opt --user=$DB_USER -p$DB_PASS --databases $db"
  $MYSQLDUMP $opt --user=$DB_USER -p$DB_PASS --databases $db | gzip > "$BACKUP_DIR/$db.gz"
done
