#!/bin/bash

set -exo pipefail

stagedir="$SRC_DIR/server-devel-staging"
rm -rf "$stagedir"
make install DESTDIR="$stagedir"

mkdir -p "$PREFIX/include"
cp -a "$stagedir$PREFIX/include/server" "$PREFIX/include/"
