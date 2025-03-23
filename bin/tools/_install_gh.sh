
get_url_releases() {
    echo "https://api.github.com/repos/$repo/releases"
}

fetch_releases() {
    curl -s "$url_releases" |  grep "$mask" | head -n$last_releases | cut -d : -f 2,3 | tr -d \"
}

get_release_link() {
    echo "$releases" | grep "$version" | head -1 | sed -e 's/^ *//' -e 's/ *$//'
}

_normalize_version() {
  sed -re 's/^(.*?(\bv|\s)([0-9]+(\.[0-9]+)+).*)$/\3/'
}

get_current_version() {
    "$tool_name" $OPT_VERSION | head -n1 | _normalize_version
#    "$tool_name" $OPT_VERSION | head -n1 | cut -d ' ' -f 2 | _normalize_version
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
cat <<EOF
 wget -q '$release_link' -O '$downloaded_file'; \\
 sudo mv '$downloaded_file' "$DST"; \\
 sudo chmod +x "$DST";
EOF
}


get_main_install_cmd() {
# dpkg -i '$downloaded_file'; \\
  if [[ $downloaded_file =~ .deb$ ]]; then
    local cmd="sudo dpkg -i '$downloaded_file'"
  else
    local cmd="sudo apt install '$downloaded_file'"
  fi

cat <<- EOF
 wget -q '$release_link' -O '$downloaded_file'; \\
 $cmd; \\
 rm -v '$downloaded_file'
EOF
}

_main() {
    url_releases=$(get_url_releases)
    releases=$(fetch_releases)
    release_link=$(get_release_link)
    version_current=$(get_current_version)

    echo '# Existed releases:'
    printf '%s\n' "${releases[@]}"
cat <<- EOF

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

$summary
EOF
}

########################

tmp_dir=/tmp
def_mask=browser_download_url
def_mask_deb=${def_mask}.*.deb
def_mask_amd64_deb=${def_mask}.*amd64.deb
def_mask_bin=${def_mask}'.*[_-][Ll]inux[_-]amd64"'
def_mask_amd64_bz2=${def_mask}.*linux_amd64.bz2


OPT_VERSION=--version

last_releases=10

before_install_cmd=()
after_install_cmd=()
