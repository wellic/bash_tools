#!/usr/bin/env bash

source "$LIB_DIR/_vars.sh"
#set -ueo pipefail
set -u
#set -x

_main() {
  get_current_tool_dir
  DST_FILE=${FOUND_TOOL_DIR:-$DST_DIR}/${TOOL_NAME}

  _sep_line 0 0
  echo " #  Name: $TOOL_NAME"
  echo " #   Dst: $DST_DIR"
  echo " #  Repo: https://github.com/$REPO_PATH/"
  echo " # Limit: $(_get_rate_limit)"
  _sep_line 0 0

  URL_RELEASES=$(get_url_releases)
  RELEASES=$(fetch_releases)
  RELEASE_LINK=$(get_release_link)
  CURRENT_VERSION="$(get_current_version || :)"

  cat <<- EOF
$(_sep_line 1 0)
 # Existed releases:
$(_sep_line 0 0)
$(echo "$RELEASES" | sed 's/^/ /')
$(_sep_line 0 1)
$(_sep_line 1 0)
 #  Current version: $CURRENT_VERSION
 # Destination path: $DST_DIR
 #    Download link: $RELEASE_LINK
EOF
  [ -z "$RELEASE_LINK" ] && exit 1

  local cmd_before cmd_main cmd_after print_show_info version_download summary
  version_download=$(get_download_version "$RELEASE_LINK")
  DOWNLOADED_FILE="$TMP_DIR/$(basename "$RELEASE_LINK")"
  [ "$CURRENT_VERSION" != "$version_download" ] && summary=" # !!! New version '$version_download' exists !!!" || summary=""

  cmd_before=$(prepare_cmd_str " " "${BEFORE_INSTALL_CMD[@]}")
  cmd_main=$(get_main_install_cmd)
  cmd_after=$(prepare_cmd_str " " "${AFTER_INSTALL_CMD[@]}")
  print_show_info="$([[ $APP_SHOW_INFO =~ ^1|true$ ]] && show_info || :)"

  cat <<- EOF
 # Updating version: $CURRENT_VERSION -> $version_download
$(_sep_line 0 1)
$(_sep_line 1 0)
 # Install commands:
$(_sep_line 0 1)
$cmd_before
$cmd_main
$cmd_after
$(show_completion)
$print_show_info
$summary
EOF
}

get_url_releases() {
  echo "https://api.github.com/repos/$REPO_PATH/releases"
}

fetch_releases() {
  local response api_error
  response=$(curl -s ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} "$URL_RELEASES")
  api_error=$(echo "$response" | jq -r '.message? // empty' 2> /dev/null)
  if [[ -n $api_error ]]; then
    echo "# GitHub API error: $api_error" >&2
    [[ -z ${GITHUB_TOKEN:-} ]] && echo "# Tip: export GITHUB_TOKEN=<token> to avoid rate limiting" >&2
    return 1
  fi
  echo "$response" | jq -r '.[]?.assets[]?.browser_download_url' | grep -E "$MASK" | head -n "$SHOW_LAST_RELEASES"
}

get_release_link() {
  #set -x
  echo "$RELEASES" | grep "$VERSION" | head -1 | sed -e 's/^ *//' -e 's/ *$//'
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

get_current_tool_dir() {
  [[ -n "$FOUND_TOOL_DIR" ]] && return 0
  FOUND_TOOL_DIR="$(command -v "$TOOL_NAME" 2>/dev/null || :)"
  [[ -z "$FOUND_TOOL_DIR" ]] && return 0
  FOUND_TOOL_DIR="$(dirname "$FOUND_TOOL_DIR")"
  DST_DIR="$FOUND_TOOL_DIR"
}

# shellcheck disable=SC2086
get_current_version() {
  if [[ -n $FOUND_TOOL_DIR ]]; then
#    "$TOOL_NAME" $OPT_VERSION | _normalize_version
    set -x
    "$TOOL_NAME" $OPT_VERSION | head -n1 | grep -Po "^(?:${TOOL_NAME} )?\K(\S+)" | _normalize_version
    set +x
  fi
}

get_download_version() {
  local fn=$1
  fn=$(dirname "$fn")
  basename "$fn" | _normalize_version
}

prepare_cmd_str() {
  local prefix=$1
  shift
  local cmds=("$@")
  [ "${#cmds[@]}" -ne 0 ] && printf "$prefix"'%s; \\\n' "${cmds[@]}"
}

_get_download_cmd() {
  if [[ ${DOWNLOADER:-curl} == "wget" ]]; then
    echo "wget --show-progress -q '$RELEASE_LINK' -O '$DOWNLOADED_FILE'"
  else
    echo "curl -L --progress-bar '$RELEASE_LINK' -o '$DOWNLOADED_FILE'"
  fi
}

_install_bin() {
  local DST_FILE=$1

  cat <<- EOF
 mkdir -p '$TMP_DIR'; \\
 $(_get_download_cmd); \\
 sudo mv '$DOWNLOADED_FILE' "$DST_FILE"; \\
 sudo chmod +x "$DST_FILE";
EOF
}

get_main_install_cmd() {
  local cmd
  if [[ $DOWNLOADED_FILE =~ .t?[gx]z$ ]]; then
    cmd=" tmpdir=\$(mktemp -d); \\
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
 mkdir -p '$TMP_DIR'; \\
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
