#!/usr/bin/env bash

source "$LIB_DIR/_vars.sh"
#set -ueo pipefail
set -u
#set -x

_main() {
  echo " Tool Name:  $TOOL_NAME"
  echo " Repo Path:  https://github.com/$REPO_PATH/"
  echo " Rate limit: $(_get_rate_limit)"
  local version_current

  url_releases=$(get_url_releases)
  releases=$(fetch_releases)
  release_link=$(get_release_link)
  version_current="$(get_current_version || :)"

  cat <<- EOF
$(_sep_line)
 # Existed releases:
$(echo "$releases" | sed 's/^/ /')
$(_sep_line)
 # Current version: $version_current
 # Download link: $release_link
EOF

  [ -z "$release_link" ] && exit 1
  version_download=$(get_download_version "$release_link")
  DOWNLOADED_FILE="$TMP_DIR/$(basename "$release_link")"
  [ "$version_current" != "$version_download" ] && summary=" # !!! New version '$version_download' exists !!!" || summary=""

  cmd_before=$(prepare_cmd_str " " "${BEFORE_INSTALL_CMD[@]}")
  cmd_main=$(get_main_install_cmd)
  cmd_after=$(prepare_cmd_str " " "${AFTER_INSTALL_CMD[@]}")
  print_show_info="$([[ $APP_SHOW_INFO =~ ^1|true$ ]] && show_info || :)"
  cat <<- EOF
 # Updating version: $version_current -> $version_download
$cmd_before
$cmd_main
$cmd_after
$(_sep_line 0 0)
$(show_completion)
$print_show_info
$(_sep_line 0 0)
$summary
EOF
}

get_url_releases() {
  echo "https://api.github.com/repos/$REPO_PATH/releases"
}

fetch_releases() {
  local response
  response=$(curl -s ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} "$url_releases")
  local api_error
  api_error=$(echo "$response" | jq -r '.message? // empty' 2> /dev/null)
  if [[ -n $api_error ]]; then
    echo "# GitHub API error: $api_error" >&2
    [[ -z ${GITHUB_TOKEN:-} ]] && echo "# Tip: export GITHUB_TOKEN=<token> to avoid rate limiting" >&2
    return 1
  fi
  echo "$response" | jq -r '.[]?.assets[]?.browser_download_url' | grep -E "$MASK" | head -n$LAST_RELEASES
}

get_release_link() {
  #set -x
  echo "$releases" | grep "$VERSION" | head -1 | sed -e 's/^ *//' -e 's/ *$//'
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
  if command -v "$TOOL_NAME" 1> /dev/null 2>&1; then
    "$TOOL_NAME" $OPT_VERSION | _normalize_version
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
  local cmd_start;
  cmd_start="mkdir -p '$TMP_DIR'; \\"
  if [[ ${DOWNLOADER:-curl} == "wget" ]]; then
    echo -e "$cmd_start;\n wget --show-progress -q '$release_link' -O '$DOWNLOADED_FILE'"
  else
    echo -e "$cmd_start;\n curl -L --progress-bar '$release_link' -o '$DOWNLOADED_FILE'"
  fi
}

_install_bin() {
  local DST=$1

  cat <<- EOF
 $(_get_download_cmd); \\
 sudo mv '$DOWNLOADED_FILE' "$DST"; \\
 sudo chmod +x "$DST";
EOF
}

get_main_install_cmd() {
  local cmd
  if [[ $DOWNLOADED_FILE =~ .t?[gx]z$ ]]; then
    cmd="tmpdir=\$(mktemp -d); \\
 tar xvf \"$DOWNLOADED_FILE\" --strip-components=${TAR_STRIP_COMPONENTS} -C \"\$tmpdir\"; \\
 sudo mv \"\$tmpdir/$SRC_BIN_FILE\" \"$DST_BIN_FILE\"; \\
 sudo chmod +x \"$DST_BIN_FILE\"; \\
 rm -vrf \"\$tmpdir\""
  elif [[ $DOWNLOADED_FILE =~ .deb$ ]]; then
    cmd="sudo dpkg -i \"$DOWNLOADED_FILE\""
  else
    cmd="sudo apt install \"$DOWNLOADED_FILE\""
  fi

  cat <<- EOF
$(_sep_line 0 0)
 # Install

 $(_get_download_cmd); \\
 $cmd; \\
 rm -v '$DOWNLOADED_FILE'
EOF
}

_get_rate_limit() {
  local response remaining limit reset_time
  response=$(curl -s ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} "https://api.github.com/rate_limit")
  remaining=$(echo "$response" | jq -r '.rate.remaining')
  limit=$(echo "$response" | jq -r '.rate.limit')
  reset_time=$(date -d "@$(echo "$response" | jq -r '.rate.reset')" "+%H:%M:%S" 2> /dev/null)
  echo "$remaining/$limit (resets at $reset_time)"
}

_sep_line() {
  local before=${1:-1}
  local after=${2:-1}
  [[ $before =~ ^1|true$ ]] && echo
  echo " ################################################################################"
  [[ $after =~ ^1|true$ ]] && echo
}

_completion_cmd() {
  echo "$TOOL_NAME $COMPLETION_OPT $COMPLETION_LNG"
}

show_completion() {
  if [[ ${SHOW_COMPLETION:-} =~ ^(1|true) ]]; then
    cat <<- EOF
 # Check completion
 $(_completion_cmd)

 # Add completion
 source <( $(_completion_cmd) | sudo tee /etc/bash_completion.d/$TOOL_NAME )
EOF
  fi
}

show_info() {
  cat << EOF
$(_sep_line 1 0)
 # Command for running tool:
 $TOOL_NAME
EOF
}
