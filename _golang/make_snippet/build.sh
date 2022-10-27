#!/usr/bin/env bash

BUILD_DIR="$(realpath $(dirname $0))"
BIN="make_snippet"
OUT="$BUILD_DIR/$BIN"
set -x
(cd $BUILD_DIR && go build -o "$OUT" *.go)
ln -fs "$OUT" "$HOME/bin/$BIN"
