_set_restic_app() {
    local app=$1
    [ -z "$app" ] && return
    [ ! -x "$RESTIC_APP" ] && return
    echo "$app"
}

_find_restic_app() {
    local app

    app=$(_set_restic_app "$RESTIC_APP")
    if [ -n "$app" ]; then
        RESTIC_APP=$(readlink -e "$app")
        return
    fi

    if [ -n "$RESTIC_APP" ] ; then
        app=$(_set_restic_app "${SCRIPT_DIR}/$RESTIC_APP")
        if [ -n "$app" ]; then
            RESTIC_APP=$(readlink -e "$app")
            return
        fi
    fi

    app=$(which "retic")
    if [ -n "$app" ]; then
        RESTIC_APP=$(readlink -e "$app")
        return
    fi

    echo "Error: can't find restic application"
    exit 1
}

_fn_cfg() {
    local TYPE=$1
    local FN=$2

    local fn_cfg="${SCRIPT_DIR}/${DIRNAME_CFG}/${TYPE}/${FN}"
    if [ ! -e "$fn_cfg" ]; then
        echo "Error: Can't find file '$fn_cfg'"
        exit 1
    fi
    echo "$fn_cfg"
}


_fn_cfg_backup_dirs() {
    local TYPE=$1

    local fn_cfg=$(_fn_cfg "$TYPE" "$FN_CFG_DIRS")
    echo "$fn_cfg"
}

_fn_cfg_repo_path() {
    local TYPE=$1

    local fn_cfg=$(_fn_cfg "$TYPE" "$FN_CFG_REPO_PATH")
    echo "$fn_cfg"
}

_fn_cfg_exclude() {
    local TYPE=$1

    local fn_cfg=$(_fn_cfg "$TYPE" "$FN_CFG_EXCLUDE")
    echo "$fn_cfg"
}

_backup_dirs() {
    local TYPE=$1

    local fn_cfg=$(_fn_cfg_backup_dirs "$TYPE")

    local line
    local BACKUP_DIRS=
    while IFS= read -r line || [ -n "$line" ]; do
        [ -z "$line" ] || BACKUP_DIRS+=" $line"
    done < "$fn_cfg"

    if [ -z "$BACKUP_DIRS" ]; then
        echo "Error: File '$fn_cfg' is empty"
        exit 1
    fi

    echo "$BACKUP_DIRS"
}

_repo_path() {
    local TYPE=$1

    local fn_cfg=$(_fn_cfg_repo_path "$TYPE")

    local REPO_PATH=
    local line
    while IFS= read -r line || [ -n "$line" ]; do
        [ -n "$REPO_PATH" ] && break
        [ "${line:0:1}" = '/' ] || line=$(readlink -m "${BACKUP_DIR:-".."}/$line")
        REPO_PATH="$line"
    done < "$fn_cfg"

    if [ -z "$REPO_PATH" ]; then
        echo "Error: File '$fn_cfg' is empty"
        exit 1
    fi

    echo "$REPO_PATH"
}

_passfile_path() {
    local pass_file=$1
    [ "${pass_file:0:1}" = '/' ] || pass_file=$(readlink -m "${SCRIPT_DIR}/$pass_file")

    echo "$pass_file"
}

_restic_task_cmd() {

    local REPO_PATH=$1
    shift
    local pass_file=$(_passfile_path "$PASS_FILE")

    echo "'$RESTIC_APP' -r '$REPO_PATH' -p '$pass_file' -v  $@"
#    echo "'$RESTIC_APP' -r '$REPO_PATH' -p '$PASS_FILE' $@"
}

_restic_task() {
    local REPO_PATH=$1
    shift

    local RESTIC_CMD=$(_restic_task_cmd "$REPO_PATH")

    echo -e '\n============================'
    CMD="${NICE[@]} $RESTIC_CMD $@"
    echo "$CMD"
    echo -e '============================\n'
    eval "$CMD"
}

_restic_task_raw() {
    local REPO_PATH=$1
    shift

    local RESTIC_CMD=$(_restic_task_cmd "$REPO_PATH")

    echo -e '\n============================'
    CMD="$RESTIC_CMD $@"
    echo "$CMD"
    echo -e '============================\n'
    eval "$CMD"
}



_get_repo_name() {
    local ARCNAME=$1
    local REPO=$2

    echo "${ARCNAME}.${REPO}"

}

_get_cache_dirname() {
    local REPO_NAME=$1

    echo "/tmp/._restic/${REPO_NAME}"
}

_get_mount_dirname() {
    local REPO_NAME=$1

    echo "$MNT_ROOT/${REPO_NAME}"
}

_backup() {
    local REPO="$1"
    shift
    local REPO_PATH=$(_repo_path "$REPO")

    [ "$REPO" = "home" -a ! -e "/home/wellic/.encrypt_wellic" ] && return 1

    REPO_NAME=$(_get_repo_name "$ARCNAME" "$REPO")
    CACHE_DIR=$(_get_cache_dirname "$REPO_NAME")

#    OPT_CACHE=""
    OPT_CACHE="--cache-dir '$CACHE_DIR' --cleanup-cache"
#    OPT_CACHE="--cache-dir '$CACHE_DIR'"

    echo -e '\n****************************'
    echo -e "$REPO: $REPO_PATH"
    echo -e '****************************'

    _restic_task "$REPO_PATH" cache --cleanup $OPT_CACHE --cleanup-cache

    [ ! -d "$REPO_PATH" ] && _restic_task "$REPO_PATH" init $OPT_CACHE

    local BACKUP_DIRS=$(_backup_dirs "$REPO")
    local EXCLUDE_FILE=$(_fn_cfg_exclude "$REPO")

    local TASKS=()
    [ "$DEBUG" = '0' ] && TASKS+=("backup $OPT_CACHE -x --exclude-file '$EXCLUDE_FILE' $BACKUP_DIRS")
#    [ "$DEBUG" = '0' ] && TASKS+=("backup $OPT_CACHE --exclude-file '$EXCLUDE_FILE' $BACKUP_DIRS")
                          TASKS+=("unlock $OPT_CACHE")
                          TASKS+=("forget $OPT_CACHE $OPT_FORGET")
    [ "$DEBUG" = '0' ] && TASKS+=("check $OPT_CACHE")
                          TASKS+=("snapshots $OPT_CACHE -c")

    for task in "${TASKS[@]}"; do
        _restic_task "$REPO_PATH" $task
    done

    _restic_task "$REPO_PATH" cache --cleanup
}


_umount() {
    local REPO="$1"
    shift
    local REPO_PATH=$(_repo_path "$REPO")

    REPO_NAME=$(_get_repo_name "$ARCNAME" "$REPO")
    MOUNT_DIR=$(_get_mount_dirname "$REPO_NAME")

    MOUNT_DIR="$MNT_ROOT/${REPO_NAME}"
    [ -d "$MOUNT_DIR" ] || return 0

    CMD="pkill -SIGINT -f '$MOUNT_DIR'"
    echo "$CMD"
    eval "$CMD"

    if mount | grep -q "$MOUNT_DIR";  then
	CMD="umount -l '$MOUNT_DIR'"
	echo "$CMD"
	eval "$CMD"
    fi
    [ -d "$MOUNT_DIR" ] && rmdir "$MOUNT_DIR" || :
    [ -d "$MNT_ROOT" ] && rmdir "$MNT_ROOT" 2>/dev/null
}

_mount() {
    local REPO="$1"
    shift
    local REPO_PATH=$(_repo_path "$REPO")

    REPO_NAME=$(_get_repo_name "$ARCNAME" "$REPO")
    CACHE_DIR=$(_get_cache_dirname "$REPO_NAME")
    MOUNT_DIR=$(_get_mount_dirname "$REPO_NAME")

#    OPT_CACHE="--cache-dir '$CACHE_DIR' --cleanup-cache"
    OPT_CACHE="--cache-dir '$CACHE_DIR'"
    OPT_MOUNT="--allow-other --no-default-permissions"

    echo -e '\n****************************'
    echo -e "$REPO: $REPO_PATH"
    echo -e '****************************'

    _umount "$REPO"

    [ -d "$MOUNT_DIR" ] || sudo mkdir -p "$MOUNT_DIR"

    _restic_task_raw "$REPO_PATH" mount $OPT_MOUNT $OPT_CACHE "$MOUNT_DIR"
}

