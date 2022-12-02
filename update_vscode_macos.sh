#!/bin/bash

# Update VSCode and all extensions from the command line
#
# Usage: update_vscode_macos.sh [stable|insider]
# Default version is insider
#
# See comments below on further customization, like skipping the
# update of an extension or for installing a prelease version of
# an extension.

VERSION="${1:-insider}"
SHA_VERSION="${2:-}"

if [[ $VERSION != "insider" ]] && [[ $VERSION != "stable" ]]; then
  echo "Usage: $0 <insider|stable>"
  exit 1
fi

set -e

# Where to install VSCode
APP_DIR="$HOME/Dev"

# stable
URL="https://code.visualstudio.com/sha/download?build=stable&os=darwin"
CURRENT_APP="$APP_DIR/Visual Studio Code.app"

# insider
if [ "$VERSION" = "insider" ]; then
  echo "updating insider version"
  URL="https://go.microsoft.com/fwlink/?LinkId=723966"
  CURRENT_APP="$APP_DIR/Visual Studio Code - Insiders.app"
fi

# path to CLI
CODE="$CURRENT_APP/Contents/Resources/app/bin/code"

# Some extensions complain when being updated, so add them here
# to avoid the error.
SKIP_EXTENSIONS=(
)

# Extensions listed here will have --pre-release added to the installation
# If you already have a prerelease extension and you don't add it here,
# then every time that extension is activated, VSCode will prompt you to
# update to the prerelease version.
INSTALL_PRERELEASE=(
  GitHub.vscode-pull-request-github
  GitHub.remotehub
  ms-toolsai.jupyter
  ms-vscode-remote.vscode-remote-extensionpack
)

function in_array() {
  local needle="$1"
  shift
  local haystack=("$@")
  for item in "${haystack[@]}"; do
    if [[ $item == "$needle" ]]; then
      echo 1
      return
    fi
  done
  echo 0
}

function do_skip_extension() {
  in_array "$1" "${SKIP_EXTENSIONS[@]}"
}

function install_prerelease_extension() {
  in_array "$1" "${INSTALL_PRERELEASE[@]}"
}

function vscode_update_extension() {
  local ext="$1"
  if [[ "$(do_skip_extension "$ext")" == "1" ]]; then
    echo "skipping extension $ext"
    return 0
  fi
  local prerelease=""
  if [[ "$(install_prerelease_extension "$ext")" == "1" ]]; then
    prerelease="--pre-release"
  fi
  echo "  - $ext $prerelease"
  local r="$("$CODE" --force --install-extension "$ext" $prerelease)"
  if [[ $r =~ newer ]]; then
    echo "  - $ext --force $prerelease"
    "$CODE" --install-extension $ext --force $prerelease
  fi
}

function update_extensions() {
  echo "updating extensions..."
  for ext in $("$CODE" --list-extensions); do
    vscode_update_extension "$ext" &
  done

  for job in $(jobs -p); do
    wait $job || true
  done
  echo "updates complete"
}

# get the url for latest download and parse out hash
download_url=$(curl --silent -LI "$URL" | grep Location | tail -1 | awk '{print $2}' | sed -e 's/\r//')

# get version hash from url
latest_hash=$(echo "$download_url" | awk -F/ '{print $(NF-1)}')
if [[ ! "$SHA_VERSION"  == "" ]]; then
    download_url="${download_url//$latest_hash/$SHA_VERSION}"
fi

# get hash from installation version
set +e
if [ -d "$CURRENT_APP" ]; then
  installed_version=$("$CURRENT_APP/Contents/Resources/app/bin/code" --version | egrep -v 'x64' | tail -1)
fi
set -e

# Exit if latest version is already installed
if [[ "$SHA_VERSION" == "$installed_version" ]]; then
    echo "Requested version is installed"
elif [[ ! "$SHA_VERSION" == "" ]] && [[ $latest_hash == "$installed_version" ]]; then
  echo "Latest version is installed"
  update_extensions
  exit 0
fi

echo "Latest hash:    $latest_hash"
echo "Installed hash: $installed_version"
echo "Requested hash: $SHA_VERSION"

# get filename
filename=$(basename "$download_url")-$latest_hash

if [[ ! -f $filename ]]; then
  # find the latest url and download
  echo "Downloading latest version from $download_url"
  curl --silent -L -o "$filename" $download_url
fi

is_running=$(ps -ef | grep -v grep | grep 'Visual Studio' | grep Contents/MacOS/Electron | awk '{print $1}')
reopen=0
if [[ $is_running =~ ^\d+$ ]]; then
  kill -9 "$is_running"
  reopen=1
fi

# process count
# if [[ $(ps -ef | grep "Visual Studio Code" | grep -v grep | wc -l) > 0 ]]; then
#     echo "Please exit Visual Studio Code and re-run this script"
#     exit 1
# fi

# install new version
rm -rf "$CURRENT_APP.backup"
echo "Installing new version"
mv -v "$CURRENT_APP" "$CURRENT_APP.backup"
unzip -q -d "$APP_DIR" "$filename"
echo "Removing download zip file"
rm -f "$filename"

update_extensions
[[ "$reopen" ]] && open "$CURRENT_APP"
rm -rf "$CURRENT_APP.backup"
