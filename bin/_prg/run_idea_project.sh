#!/usr/bin/env bash

set -uEeo pipefail
set -x

ide="$1"
shift

START_DIR="$(pwd)"
dir="$START_DIR"
[[ $dir =~ "$HOME" ]] || exit 111

params=( "$@" )
files=()
for f in "${params[@]}"; do
    [[ -d $f ]] || files+=("$f")
done

while [[ "$dir" != "$HOME" ]] && [[ "$dir" != "/" ]]; do
  if [[ -d "$dir/.idea" ]]; then
    echo "Opening project in: $dir"
    nohup $ide "$dir" ${files[@]} >/dev/null 2>&1 &
    exit 0
  fi
  dir=$(dirname "$dir")
done

#if (( ${#files[@]} > 0 )); then
    nohup $ide --temp-project ${files[@]} >/dev/null 2>&1 &
#else
#    nohup $ide --temp-project $START_DIR  >/dev/null 2>&1 &
#fi

echo "No $ide project (.idea) found up to $START_DIR"
