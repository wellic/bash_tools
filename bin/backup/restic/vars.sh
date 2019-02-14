DEBUG=${DEBUG:-1}
SRC_DIR=${SRC_DIR:-"."}

user=wellic
BACKUP_DIR="/media/$user/ssd_backup_$user"

RESTIC_APP=restic
PASS_FILE=/home/$user/.ssh/restic_key/key

MNT_ROOT=/mnt/._restic
MOUNT_TMEOUT=5

DIRNAME_CFG=configs
FN_CFG_DIRS=backup_dirs
FN_CFG_EXCLUDE=exclude
FN_CFG_REPO_PATH=repo_path
FN_CFG_LOG=log_path

# you can redefne in file
#OPT_FORGET="--keep-last=1 --prune"
#OPT_FORGET="--keep-last=1 --keep-hourly=24 --keep-daily=7 --keep-weekly=4 --keep-monthly=12 --keep-yearly=1 --prune"
#OPT_FORGET="--keep-last=1 --keep-daily=7 --keep-weekly=4 --keep-monthly=12 --keep-yearly=1 --prune"

#recomended option for working disk
OPT_FORGET="--keep-last=1 --keep-daily=7 --keep-weekly=2 --keep-monthly=6 --keep-yearly=1 --prune"

#recemended option for externall disk
OPT_FORGET="--keep-last=1 --keep-daily=7 --keep-weekly=4 --keep-monthly=12 --keep-yearly=1 --prune"

[ "$DEBUG" != '0' ] && OPT_FORGET+=' --dry-run'

NICE=(nice -n 19 ionice -c 3)

ARCNAME=$(basename $(dirname "$SCRIPT_DIR"))

LOG_DIR="${BACKUP_DIR:-"$SCRIPT_DIR"}/restic-log"

all_types=(
    root
    home
)
