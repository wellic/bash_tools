########################
# curl | wget
DOWNLOADER=curl

tmp_dir=/tmp
DST_BIN_DIR=/usr/local/bin
tool_name=""

#def_mask=browser_download_url
def_mask='/download/'
def_mask_deb="${def_mask}.*.deb"
def_mask_amd64_deb="${def_mask}.*amd64.deb"
#def_mask_bin=${def_mask}'.*[_-][Ll]inux[_-]amd64"'
#def_mask_bin_x64=${def_mask}'.*[_-][Ll]inux[_-]x64"'
def_mask_bin="${def_mask}.*[_-][Ll]inux[_-]amd64"
def_mask_bin_x64="${def_mask}.*[_-][Ll]inux[_-]x64"
def_mask_amd64_bz2="${def_mask}.*linux_amd64.bz2"
def_mask_x86_64_tar_gz="${def_mask}.*[Ll]inux[_-]x86_64.tar.gz$"
def_mask_amd64_tar_gz="${def_mask}.*[Ll]inux[_-]amd64.tar.gz$"

OPT_VERSION=--version
COMPLETION_OPT=completion
COMPLETION_LNG=bash

last_releases=10

before_install_cmd=()
after_install_cmd=()

show_completion=1

tar_strip_components=1
