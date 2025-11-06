#!/usr/bin/env bash

#set -ueo pipefail
#set -x

#################################################
# Idea gets from https://github.com/ffcrus/garlic
#################################################

SAVED_CLIPBOARD=$(xsel -ob)
sleep 0.1s

layout=$(setxkbmap -query | awk '/layout:/ {print $2}')
case $layout in
  *ru*) map="y/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]{};':\",.\/<>?@#\$^&\`~фисвуапршолдьтщзйкыегмцчняФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯхъХЪжэЖЭбюБЮ№ёЁіІєЄїЇ/фисвуапршолдьтщзйкыегмцчняФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯхъХЪжэЖЭбю.БЮ,\"№;:?ёЁabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]{};':\",.<>#\`~sS'\"]}/" ;;
     *) map="y/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]{};':\",.\/<>?@#\$^&\`~фисвуапршолдьтщзйкіегмцчняФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯхїХЇжєЖЄбюБЮ№'~ыЫэЭъЪёЁ/фисвуапршолдьтщзйкіегмцчняФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯхїХЇжєЖЄбю.БЮ,\"№;:?ёЁabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]{};':\",.<>#\`~sS'\"]}\`~/" ;;
esac

xsel -op | sed "$map" | xsel -ib
xdotool key Mode_switch keyup Insert key --clearmodifiers Shift+Insert
xsel --clear

printf %s "$SAVED_CLIPBOARD" | xsel -ib
xdotool keyup Shift_L Shift_R Control_L Control_R Alt_L Alt_R Insert
