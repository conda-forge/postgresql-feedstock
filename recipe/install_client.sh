#!/bin/bash

set -exo pipefail

stagedir="$SRC_DIR/client-staging"
rm -rf "$stagedir"
make install DESTDIR="$stagedir"
make install -C contrib DESTDIR="$stagedir"

mkdir -p "$PREFIX/bin"
while IFS= read -r binary; do
    cp "$stagedir$PREFIX/bin/$binary" "$PREFIX/bin/"
done < "$RECIPE_DIR/client_binaries.txt"
