#!/usr/bin/env bash

# ref: https://learn.microsoft.com/en-us/cli/azure/run-azure-cli-docker

set -u
VERSION="${1:-latest}"

echo "Note - a specific version may be used by passing an image tag"
echo "Using image tag '$VERSION'"

IMAGE=mcr.microsoft.com/azure-cli:$VERSION
BASHRC=$HOME/tmp/az-cli-bashrc

CLI="$(basename "$IMAGE")"

mkdir -p $HOME/tmp

# setup bash env here
cat <<___EOF___ >$BASHRC
# File is created dynamically and used by the az-cli container

export PATH=.:$HOME/bin:$PATH
export PS1="[$CLI] \s\$ "
alias k=kubectl

___EOF___

username="${USER:-unknown}"
cname="${CLI//:/-}-$username-$$"

docker run --rm --name az-cli-$username-$$ -it --entrypoint bash \
  -v $BASHRC:/root/.bashrc \
  -v ${HOME}/.ssh:/root/.ssh \
  -v ~/.kube:/root/.kube \
  -v ~/bin:/root/bin \
  -v ~/.azure:/root/.azure \
  -w /root \
  "$IMAGE"
