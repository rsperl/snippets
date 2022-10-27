#!/usr/bin/env bash

BINARY=main

DIST_DIR="./dist"
BUILD_TIME="$(date --iso-8601=seconds)"
COMMIT_SHA="$(git rev-parse HEAD 2>/dev/null && true)"
REPOSITORY="$(git remote -v | head -1 | awk '{print $2}')"

# or
# git rev-parse --short=8 HEAD 2>/dev/null && true
COMMIT_SHORT_SHA="${COMMIT_SHA:0:8}"

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD && true)

COMMIT_TAG="$(git tag --points-at $COMMIT_SHA && true)"

BUILD_HOSTNAME=$(hostname)

BUILD_USERNAME=$USER

mkdir -p "$DIST_DIR"

# Reference the build-time variables as <package>.<Varname>
set -x
go build -o "$DIST_DIR/$BINARY" \
  -ldflags="-X main.Version=$COMMIT_TAG \
    -X main.Repository=$REPOSITORY \
    -X main.CommitSHA=$COMMIT_SHA \
    -X main.ShortCommitSHA=$COMMIT_SHORT_SHA \
    -X main.Branch=$BRANCH_NAME \
    -X main.BuildTime=$BUILD_TIME \
    -X main.BuildHostname=$BUILD_HOSTNAME \
    -X main.BuildUsername=$BUILD_USERNAME" \
  .
set +x

echo
echo "Binary built: $DIST_DIR/$BINARY"
ls -l "$DIST_DIR/$BINARY"