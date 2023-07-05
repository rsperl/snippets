#!/usr/bin/env bash

version=$1

if [[ $version == "" ]]; then
  echo "Usage $0 <version>"
  exit 1
fi

docker build --pull -t aws-cli:$version --build-arg VERSION=$version .
