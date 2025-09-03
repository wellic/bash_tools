#!/usr/bin/env bash

set -uEeo pipefail
#set -x

conf_dir="${1:-$HOME/.kube/vms}"
mask_files="${2:-"*.kubeconf"}"

conf_dir="${conf_dir%/*}"

mapfile -t files < <(find "$conf_dir" -name "$mask_files")

for f in "${files[@]}"; do
  fn="$(basename "$f")"
  [[ $f =~ \.orig\. ]] && continue
  fn="${fn%.*}"
  echo "export KUBECONFIG=$f" | tee "${fn}.conf"
done