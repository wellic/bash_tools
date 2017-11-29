#/bin/bash

#set -x
set -u

PROG_TYPE="PyCharm-P"
INIT_PATH="$HOME/.local/share/JetBrains/Toolbox/apps/$PROG_TYPE"
SETTINGS_NAME=".channel.settings.json"
PROG_NAME="bin/pycharm.sh"

SETTINGS_FILE=$(find "$INIT_PATH" -iname "$SETTINGS_NAME" | sort -nur | head -1)
SETTINGS_DIR=$(dirname "$SETTINGS_FILE")

VER=$(grep -P '\d{3}\.\d{4}\.\d+' "$SETTINGS_FILE" | sed -re 's/[^0-9\.]//g' | sort -ur | head -1)

#exec "$SETTINGS_DIR/$VER/$PROG_NAME" "$1" &>/dev/null &

"$SETTINGS_DIR/$VER/$PROG_NAME" $*
#&
#>/dev/null &
exit 0
