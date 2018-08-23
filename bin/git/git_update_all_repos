#!/bin/bash

set -e 

MAX_DEPTH=${1:-1}

FETCH_OPT="--prune --tags"
PULL_OPT="--rebase"

for f in $(find -maxdepth $MAX_DEPTH -type d -name .git -exec dirname {} \;)
do
  cd "$f"
  echo "$PWD"
#  git checkout -q master
  git fetch $FETCH_OPT && git pull $PULL_OPT
  cd - >/dev/null
done