#!/usr/bin/env bash

########################
# curl | wget
DOWNLOADER=curl
GITHUB_TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"

TMP_DIR=$(mktemp -d)
TOOL_NAME=""
REPO_PATH=""
MASK=""
DOWNLOADED_FILE=""
VERSION=""
SRC_BIN_FILE=""
DST_BIN_DIR=/usr/bin
DST_BIN_FILE=""

DEF_MASK='/download/'
DEF_MASK_DEB="${DEF_MASK}.*.deb"
DEF_MASK_AMD64_DEB="${DEF_MASK}.*amd64.deb"
DEF_MASK_BIN="${DEF_MASK}.*[_-][Ll]inux[_-]amd64"
DEF_MASK_BIN_X64="${DEF_MASK}.*[_-][Ll]inux[_-]x64"
DEF_MASK_AMD64_BZ2="${DEF_MASK}.*linux_amd64.bz2"
DEF_MASK_X86_64_TAR_GZ="${DEF_MASK}.*[Ll]inux[_-]x86_64.tar.gz$"
DEF_MASK_AMD64_TAR_GZ="${DEF_MASK}.*[Ll]inux[_-]amd64.tar.gz$"

OPT_VERSION=--version
LAST_RELEASES=10

BEFORE_INSTALL_CMD=()
AFTER_INSTALL_CMD=()

SHOW_COMPLETION=1
COMPLETION_OPT=completion
COMPLETION_LNG=bash

TAR_STRIP_COMPONENTS=1
APP_SHOW_INFO=0
