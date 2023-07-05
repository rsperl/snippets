#!/usr/bin/env bash

# ref: https://learn.microsoft.com/en-us/cli/azure/run-azure-cli-docker

set -u
VERSION="${1:-latest}"

echo "Note - a specific version may be used by passing an image tag"
echo "Using image tag '$VERSION'"

IMAGE=my-curl:$VERSION
BASHRC=$HOME/tmp/curl-bashrc

CLI="$(basename "$IMAGE")"

mkdir -p $HOME/tmp

# setup bash env here
cat <<___EOF___ >$BASHRC
# File is created dynamically and used by the curl container

set -o
export PATH=.:$HOME/bin:$PATH
export PS1="[$CLI] \s\$ "

___EOF___

username="${USER:-unknown}"
cname="${CLI//:/-}-$username-$$"

docker run --rm --name $cname -it --entrypoint bash \
  -v $BASHRC:/root/.bashrc \
  -v ${HOME}/.ssh:/root/.ssh \
  -v ~/bin:/root/bin \
  -w /root \
  "$IMAGE"
