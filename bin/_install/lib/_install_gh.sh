#!/usr/bin/env bash

#set -uEeo pipefail
#set -x

get_url_releases() {
    echo "https://api.github.com/repos/$repo/releases"
}

fetch_releases() {
    curl -s "$url_releases" |  grep -E "$mask" | head -n$last_releases | cut -d : -f 2,3 | tr -d \"
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
#set -x
    if command -v "$tool_name" 1>/dev/null 2>&1; then
      "$tool_name" $OPT_VERSION | _normalize_version
    fi
#    local v
#    v=$("$tool_name" $OPT_VERSION || :)
#    echo "$v" | head -n1 | _normalize_version
#    "$tool_name" $OPT_VERSION | head -n1 | cut -d ' ' -f 2 | _normalize_version
#set +x
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

_install_bin() {
  local DST=$1

  local cmd
  if [[ ${DOWNLOADER:-curl} == "wget" ]]; then
    cmd="wget --show-progress -q '$release_link' -O '$downloaded_file'"
  else
    cmd="curl -L --progress-bar '$release_link' -o '$downloaded_file'"
  fi

  cat <<EOF
  $cmd; \\
  sudo mv '$downloaded_file' "$DST"; \\
  sudo chmod +x "$DST";
EOF
}


get_main_install_cmd() {
  local cmd
# dpkg -i '$downloaded_file'; \\
  if [[ $downloaded_file =~ .t?gz$ ]]; then
    cmd="tmpdir=\$(mktemp -d); \\
 tar xvf \"$downloaded_file\" --strip-components=1 -C \"\$tmpdir\"; \\
 sudo mv \"\$tmpdir/$SRC_BIN_FILE\" \"$DST_BIN_FILE\"; \\
 sudo chmod +x \"$DST_BIN_FILE\"; \\
 rm -vrf \"\$tmpdir\""
  elif [[ $downloaded_file =~ .deb$ ]]; then
    cmd="sudo dpkg -i \"$downloaded_file\""
  else
    cmd="sudo apt install \"$downloaded_file\""
  fi

#cat <<- EOF
# wget --show-progress -q '$release_link' -O '$downloaded_file'; \\
# $cmd; \\
# rm -v '$downloaded_file'
#EOF

  local cmd2
  if [[ ${DOWNLOADER:-curl} == "wget" ]]; then
    cmd2="wget --show-progress -q '$release_link' -O '$downloaded_file'"
  else
    cmd2="curl -L --progress-bar '$release_link' -o '$downloaded_file'"
  fi

  cat <<-EOF
  $cmd2; \\
  $cmd; \\
  rm -v '$downloaded_file'
EOF

}

_main() {
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
  if [[ ${show_completion}:-} =~ ^(1|true) ]]; then
    cat <<- EOF
 # Check completion
 $(_completion_cmd)

 # Add completion
 source <( $( echo "$(_completion_cmd) | sudo tee /etc/bash_completion.d/$tool_name") )
EOF
  fi
}

########################
# curl | wget
DOWNLOADER=curl

tmp_dir=/tmp
def_mask=browser_download_url
def_mask_deb=${def_mask}.*.deb
def_mask_amd64_deb=${def_mask}.*amd64.deb
def_mask_bin=${def_mask}'.*[_-][Ll]inux[_-]amd64"'
def_mask_bin_x64=${def_mask}'.*[_-][Ll]inux[_-]x64"'
def_mask_amd64_bz2=${def_mask}.*linux_amd64.bz2
def_mask_x86_64_tar_gz=${def_mask}.*[Ll]inux[_-]x86_64.tar.gz
def_mask_amd64_tar_gz=${def_mask}.*[Ll]inux[_-]amd64.tar.gz

OPT_VERSION=--version
COMPLETION_OPT=completion
COMPLETION_LNG=bash

last_releases=10

before_install_cmd=()
after_install_cmd=()

show_completion=1