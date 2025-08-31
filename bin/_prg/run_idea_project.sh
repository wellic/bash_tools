#!/usr/bin/env bash

set -uEeo pipefail
#set -x

ide="$1"
shift

START_DIR="$(pwd)"
dir="$(realpath "$START_DIR")"
[[ $dir =~ $HOME ]] || exit 123

params=( "$@" )
files=()
for f in "${params[@]}"; do
    [[ -d $f ]] || files+=("$f")
done

while [[ "$dir" != "$HOME" ]] && [[ "$dir" != "/" ]]; do
  dir="$(realpath "$dir")"
  if [[ -d "$dir/.idea" ]]; then
    echo "Opening project in: $dir"
    # shellcheck disable=SC2145
    echo "$ide $dir ${files[@]} >/dev/null 2>&1"
    # shellcheck disable=SC2068
    nohup "$ide" "$dir" ${files[@]} >/dev/null 2>&1 &
    exit 0
  fi
  dir=$(dirname "$dir")
done


#if (( ${#files[@]} > 0 )); then
#    nohup $ide --temp-project ${files[@]} >/dev/null 2>&1 &
#else
#    nohup $ide --temp-project $START_DIR  >/dev/null 2>&1 &
#fi

menu=(
  "Only open $ide"
  "Create project"
  "Quit"
)

echo "No $ide project (.idea) found in: $START_DIR"
PS3="Enter number or type 'q' to quit: "

select opt in "${menu[@]}"; do
  [[ "$REPLY" == 3 || $opt =~ ^[qQ]$ ]] && exit 0
  case $REPLY in
    1)
    # shellcheck disable=SC2145
      echo "$ide ${files[@]} >/dev/null 2>&1"
      # shellcheck disable=SC2068
      nohup "$ide" ${files[@]} >/dev/null 2>&1 &
      exit 0
      ;;
    2)
    # shellcheck disable=SC2145
      echo "$ide $START_DIR ${files[@]} >/dev/null 2>&1"
      # shellcheck disable=SC2068
      nohup "$ide" "$START_DIR" ${files[@]} >/dev/null 2>&1 &
      exit 0
      ;;
    *) 
      echo "Invalid selection."
      exit 1
      ;;
  esac
done
