#!/usr/bin/env bash

# ref: https://learn.microsoft.com/en-us/cli/azure/run-azure-cli-docker

set -u
VERSION="${1:-latest}"

echo "Note - a specific version may be used by passing an image tag"
echo "Using image tag '$VERSION'"

IMAGE="my-azure-cli:$VERSION"
BASHRC="$HOME/tmp/az-cli-bashrc"

CLI="$(basename "$IMAGE")"

mkdir -p $HOME/tmp

# setup bash env here
cat <<___EOF___ >$BASHRC
# File is created dynamically and used by the az-cli container

set -o
export PATH=.:$HOME/bin:$PATH
export PS1="[$CLI] \s\$ "
export KUBECONFIG="$HOME/.kube"
alias k=kubectl
___EOF___

username="${USER:-unknown}"
cname="${CLI//:/-}-$username-$$"

docker run --rm --name $cname -it --entrypoint bash \
  -v ~/.kube:/root/.kube \
  -v ~/bin:/root/bin \
  -v $BASHRC:/root/.bashrc \
  -v $HOME/.azure/accessTokens.json:/root/.azure/accessTokens.json \
  -v $HOME/.azure/azureProfile.json:/root/.azure/azureProfile.json \
  -v $HOME/.azure/AzurePSDataCollectionProfile.json:/root/.azure/AzurePSDataCollectionProfile.json \
  -v $HOME/.azure/AzureRmContext.json:/root/.azure/AzureRmContext.json \
  -v $HOME/.azure/clouds.config:/root/.azure/clouds.config \
  -v $HOME/.azure/commandIndex.json:/root/.azure/commandIndex.json \
  -v $HOME/.azure/commands:/root/.azure/commands \
  -v $HOME/.azure/config:/root/.azure/config \
  -v $HOME/.azure/dockerAccessToken.json:/root/.azure/dockerAccessToken.json \
  -v $HOME/.azure/ErrorRecords:/root/.azure/ErrorRecords \
  -v $HOME/.azure/extensionCommandTree.json:/root/.azure/extensionCommandTree.json \
  -v $HOME/.azure/logs:/root/.azure/logs \
  -v $HOME/.azure/msal_token_cache.json:/root/.azure/msal_token_cache.json \
  -v $HOME/.azure/service_principal_entries.json:/root/.azure/service_principal_entries.json \
  -v $HOME/.ssh:/root/.ssh \
  -w /root \
  "$IMAGE"
