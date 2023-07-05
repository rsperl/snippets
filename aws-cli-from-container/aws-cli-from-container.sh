#!/usr/bin/env bash

# ref: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-docker.html

set -u
VERSION="${1:-latest}"

echo "Note - a specific version may be used by passing an image tag"
echo "Using image tag '$VERSION'"
# IMAGE=public.ecr.aws/aws-cli/aws-cli:$VERSION
IMAGE=aws-cli:$VERSION
BASHRC=$HOME/tmp/aws-cli-bashrc

CLI="$(basename "$IMAGE")"
mkdir -p $HOME/tmp

# setup bash env here
cat <<___EOF___ >$BASHRC
# File is created dynamically and used by the aws-cli container

set -o 
export PATH=.:$HOME/bin:$PATH
export PS1="[$CLI] \s\$ "
export KUBECONFIG="$HOME/.kube"
alias k=kubectl

___EOF___

username="${USER:-unknown}"
cname="${CLI//:/-}-$username-$$"

docker run --rm --name $cname -it \
  --entrypoint bash \
  -v $BASHRC:/root/.bashrc \
  -v ~/.kube:/root/.kube \
  -v ~/bin:/root/bin \
  -v ~/.aws:/root/.aws \
  -w /root \
  "$IMAGE"
