
get_url_releases() {
    echo "https://api.github.com/repos/$repo/releases"
}

fetch_releases() {
    curl -s "$url_releases" |  grep "$mask" | head -n$last_releases | cut -d : -f 2,3 | tr -d \"
}

get_release_link() {
    echo "$releases" | grep "$version" | head -1 | sed -e 's/^ *//' -e 's/ *$//'
}

get_current_version() {
    "$tool_name" $OPT_VERSION | head -n1 | cut -d ' ' -f 2 | sed -re 's/^v([0-9])/\1/'
}

get_download_version() {
    local l=$1
    l=$(dirname "$l")
    basename "$l" | sed -re 's/^v([0-9])/\1/'
}

prepare_cmd_str() {
    local prefix=$1
    shift
    local cmds=("$@")
    [ "${#cmds[@]}" -ne 0 ] && printf "$prefix"'%s; \\\n' "${cmds[@]}"
}

get_main_install_cmd() {
# dpkg -i '$deb_file'; \\
cat <<- EOF
 wget -q '$release_link' -O '$deb_file'; \\
 sudo apt install '$deb_file'; \\
 rm -v '$deb_file'
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
    deb_file="$tmp_dir/$(basename $release_link)"
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

OPT_VERSION=--version

last_releases=10

before_install_cmd=()
after_install_cmd=()
