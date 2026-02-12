#!/usr/bin/env bash

source "$LIB_DIR/_vars.sh"
#set -ueo pipefail
set -u

#set -uEeo pipefail
#set -x

get_url_releases() {
    echo "https://api.github.com/repos/$repo/releases"
}

fetch_releases() {
#    curl -s "$url_releases" |  grep -E "$mask" | head -n$last_releases | cut -d : -f 2,3 | tr -d \"
    curl -s "$url_releases" | jq -r '.[].assets[].browser_download_url' |  grep -E "$mask" | head -n$last_releases
}

get_release_link() {
#set -x
    echo "$releases" | grep "$version" | head -1 | sed -e 's/^ *//' -e 's/ *$//'
#set +x
}

_normalize_version() {
  strip_colors | trim_spaces | sed -re 's/^(.*?(\bv|\s|-)([0-9]+(\.[0-9]+)+).*)$/\3/'
}

strip_colors() {
  sed 's/\x1B\[[0-9;]*[mGKHF]//g'
}

trim_spaces() {
  sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

get_current_version() {
    if command -v "$tool_name" 1>/dev/null 2>&1; then
      "$tool_name" $OPT_VERSION | _normalize_version
    fi

}

get_download_version() {
    local l=$1
    l=$(dirname "$l")
    basename "$l" | _normalize_version
}

prepare_cmd_str() {
    local prefix=$1
    shift
    local cmds=("$@")
    [ "${#cmds[@]}" -ne 0 ] && printf "$prefix"'%s; \\\n' "${cmds[@]}"
}

_get_download_cmd() {
  if [[ ${DOWNLOADER:-curl} == "wget" ]]; then
    echo "wget --show-progress -q '$release_link' -O '$downloaded_file'"
  else
    echo "curl -L --progress-bar '$release_link' -o '$downloaded_file'"
  fi
}

_install_bin() {
  local DST=$1

  cat <<EOF
  $(_get_download_cmd); \\
  sudo mv '$downloaded_file' "$DST"; \\
  sudo chmod +x "$DST";
EOF
}


get_main_install_cmd() {
  local cmd
  if [[ $downloaded_file =~ .t?[gx]z$ ]]; then
    cmd="tmpdir=\$(mktemp -d); \\
 tar xvf \"$downloaded_file\" --strip-components=${tar_strip_components} -C \"\$tmpdir\"; \\
 sudo mv \"\$tmpdir/$SRC_BIN_FILE\" \"$DST_BIN_FILE\"; \\
 sudo chmod +x \"$DST_BIN_FILE\"; \\
 rm -vrf \"\$tmpdir\""
  elif [[ $downloaded_file =~ .deb$ ]]; then
    cmd="sudo dpkg -i \"$downloaded_file\""
  else
    cmd="sudo apt install \"$downloaded_file\""
  fi

  cat <<-EOF
  $(_get_download_cmd); \\
  $cmd; \\
  rm -v '$downloaded_file'
EOF
}

_main() {
  echo "Repo: https://github.com/$repo/"
  echo "Tool: $tool_name"
  echo
  local version_current
#set -x
    url_releases=$(get_url_releases)
    releases=$(fetch_releases)
    release_link=$(get_release_link)
    version_current="$(get_current_version || :)"
#set +x


 cat <<- EOF
 # Existed releases:
$(printf '%s\n' "${releases[@]}")

 # Current version: $version_current
 # Download link: $release_link
EOF

    [ -z "$release_link" ] && exit 1
    version_download=$(get_download_version "$release_link")
    downloaded_file="$tmp_dir/$(basename $release_link)"
    [ "$version_current" != "$version_download" ] && summary="# !!! New version '$version_download' exists !!!" || summary=""

    cmd_before=$(prepare_cmd_str " " "${before_install_cmd[@]}")
    cmd_main=$(get_main_install_cmd)
    cmd_after=$(prepare_cmd_str " " "${after_install_cmd[@]}")
cat <<- EOF
 # Updating version: $version_current -> $version_download
$cmd_before
$cmd_main
$cmd_after
$(show_completion)

$summary
EOF
}

_completion_cmd() {
  echo "$tool_name $COMPLETION_OPT $COMPLETION_LNG"
}

show_completion() {
  if [[ ${show_completion:-} =~ ^(1|true) ]]; then
    cat <<- EOF
 # Check completion
 $(_completion_cmd)

 # Add completion
 source <( $(_completion_cmd) | sudo tee /etc/bash_completion.d/$tool_name )
EOF
  fi
}
