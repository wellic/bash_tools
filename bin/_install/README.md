# bin/_install — GitHub Release Install Scripts

Scripts that **print ready-to-run shell commands** to stdout for installing tools from GitHub Releases.
They do not install anything themselves — the user copies and runs the output.

## Usage

```bash
./install_<tool>.sh [version_pattern]
```

- Without arguments — installs the latest release
- With a version pattern — filters releases matching that string (e.g. `./install_fzf.sh 0.60`)

**Example output:**

```
Repo: https://github.com/junegunn/fzf/
Tool: fzf

 # Existed releases:
 https://github.com/.../fzf-0.67.0-linux_amd64.tar.gz
 ...

 # Current version: 0.65.0
 # Download link:   https://github.com/.../fzf-0.67.0-linux_amd64.tar.gz
 # Updating version: 0.65.0 -> 0.67.0

 # Install
 curl -L --progress-bar '...' -o '/tmp/fzf-0.67.0-linux_amd64.tar.gz'; \
 tmpdir=$(mktemp -d); \
 tar xvf "/tmp/..." --strip-components=0 -C "$tmpdir"; \
 sudo mv "$tmpdir/fzf" "${CURRENT_TOOL_DIR:-$DST_TOOL_DIR}/fzf"; \
 sudo chmod +x "${CURRENT_TOOL_DIR:-$DST_TOOL_DIR}/fzf"; \
 rm -vrf "$tmpdir"; \
 rm -v '/tmp/fzf-0.67.0-linux_amd64.tar.gz'

 # !!! New version '0.67.0' exists !!!
```

## Available Scripts

| Script | Tool | Repo | Archive type |
|---|---|---|---|
| `install_bat.sh` | bat | sharkdp/bat | `.deb` |
| `install_dbeaver.sh` | dbeaver | dbeaver/dbeaver | `.deb` |
| `install_dive.sh` | dive | wagoodman/dive | `.deb` |
| `install_fzf.sh` | fzf | junegunn/fzf | `.tar.gz` |
| `install_jq.sh` | jq | jqlang/jq | binary |
| `install_ksnip.sh` | ksnip | ksnip/ksnip | `.deb` |
| `install_mcat.sh` | mcat | Skardyy/mcat | `.tar.xz` |
| `install_mdcat.sh` | mdcat | swsnr/mdcat | `.tar.gz` |
| `install_restic.sh` | restic | restic/restic | `.bz2` |
| `install_rg.sh` | rg (ripgrep) | BurntSushi/ripgrep | `.deb` |
| `install_shfmt.sh` | shfmt | mvdan/sh | binary |
| `install_yamlfmt.sh` | yamlfmt | google/yamlfmt | `.tar.gz` |
| `install_yq.sh` | yq | mikefarah/yq | `.tar.gz` |

Additional scripts in `add/`: `install_cdxgen.sh`, `install_cdx-verify.sh`, `install_cosign.sh`, `install_cyclondx.sh`, `install_k9s.sh`, `install_zarf.sh`.

## Architecture

```
bin/_install/
├── install_<tool>.sh   # tool-specific scripts
├── _lib.sh             # entry point: sources lib/_install_gh.sh
├── lib/
│   ├── _install_gh.sh  # core functions
│   └── _vars.sh        # default variables
└── add/                # additional scripts
```

### Flow

Each install script:
1. Sources `_lib.sh` → loads `lib/_vars.sh` + `lib/_install_gh.sh`
2. Sets tool variables (`TOOL_NAME`, `REPO_PATH`, `MASK`, etc.)
3. Optionally overrides functions (`get_current_version`, `get_main_install_cmd`, `show_completion`)
4. Calls `_main`

`_main` fetches GitHub Releases API → filters by MASK → prints download + install commands.

## Key Variables (`lib/_vars.sh`)

| Variable | Default | Description |
|---|---|---|
| `TOOL_NAME` | `""` | Binary name (used for version check and completion) |
| `REPO_PATH` | `""` | GitHub repo in `owner/name` format |
| `MASK` | — | `grep -E` pattern to filter release asset URLs (set in each install script) |
| `DOWNLOADER` | `curl` | `curl` or `wget` |
| `DST_BIN_DIR` | `${CURRENT_TOOL_DIR:-$DST_TOOL_DIR}` | Installation directory |
| `TMP_DIR` | `$(mktemp -d)` | Temporary download directory |
| `LAST_RELEASES` | `10` | Number of releases to show |
| `TAR_STRIP_COMPONENTS` | `1` | `--strip-components` for tar extraction |
| `SRC_BIN_FILE` | — | Binary name inside the archive |
| `DST_BIN_FILE` | — | Full destination path |
| `OPT_VERSION` | `--version` | Version flag |
| `COMPLETION_OPT` | `completion` | Completion subcommand |
| `COMPLETION_LNG` | `bash` | Completion language |
| `SHOW_COMPLETION` | `1` | Show completion commands (`0` to disable) |
| `BEFORE_INSTALL_CMD` | `()` | Array of commands to run before install |
| `AFTER_INSTALL_CMD` | `()` | Array of commands to run after install |
| `APP_SHOW_INFO` | `0` | Print extra "how to run tool" info block (`1` to enable) |

### Predefined masks

```bash
DEF_MASK='/download/'                                     # base pattern
DEF_MASK_BIN="${DEF_MASK}.*[_-][Ll]inux[_-]amd64"        # bare binary
DEF_MASK_BIN_X64="${DEF_MASK}.*[_-][Ll]inux[_-]x64"      # bare binary (x64)
DEF_MASK_DEB="${DEF_MASK}.*.deb"                         # any .deb
DEF_MASK_AMD64_DEB="${DEF_MASK}.*amd64.deb"              # amd64 .deb
DEF_MASK_AMD64_TAR_GZ="${DEF_MASK}.*[Ll]inux[_-]amd64.tar.gz$"
DEF_MASK_X86_64_TAR_GZ="${DEF_MASK}.*[Ll]inux[_-]x86_64.tar.gz$"
DEF_MASK_AMD64_BZ2="${DEF_MASK}.*linux_amd64.bz2"
```

## Override Points

### `get_current_version`

Override when the default `tool --version | _normalize_version` doesn't work:

```bash
get_current_version() {
  "$TOOL_NAME" $OPT_VERSION | grep -Po 'v\K([0-9]+\.[0-9]+\.[0-9]+)'
}
```

### `get_main_install_cmd`

Override for non-standard install (e.g. direct binary without tar):

```bash
get_main_install_cmd() {
  _install_bin "${CURRENT_TOOL_DIR:-$DST_TOOL_DIR}/$TOOL_NAME"
}
```

### `show_completion`

Override to print custom completion instructions:

```bash
show_completion() {
  cat <<-EOF
 # Add completion
  echo "eval \"\$(fzf --bash)\""
EOF
}
```

## Archive `TAR_STRIP_COMPONENTS`

| Value | When to use | Example |
|---|---|---|
| `1` (default) | Archive has a top-level subdirectory | `mdcat-2.7.1-x86_64/.../mdcat` |
| `0` | Files are at archive root | `fzf`, `k9s`, `yamlfmt` |

## GitHub API Rate Limiting

Scripts work **without** `GITHUB_TOKEN` but are limited to **60 requests/hour** per IP.
When the limit is exceeded, the script shows an error and exits:

```
# GitHub API error: API rate limit exceeded for 1.2.3.4. ...
# Tip: export GITHUB_TOKEN=<token> to avoid rate limiting
```

To increase the limit to **5000 requests/hour**, set `GITHUB_TOKEN`:

```bash
export GITHUB_TOKEN=ghp_...
./install_fzf.sh
```

## Adding a New Script

```bash
#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/_lib.sh"

version=${1:-"."}
################################################################################

TOOL_NAME=mytool
REPO_PATH=owner/mytool
MASK="$DEF_MASK_AMD64_TAR_GZ"

SRC_BIN_FILE="$TOOL_NAME"
DST_BIN_FILE="${DST_BIN_DIR}/${TOOL_NAME}"

_main
```

Make executable:
```bash
chmod +x bin/_install/install_mytool.sh
```
