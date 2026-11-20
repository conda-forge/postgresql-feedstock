#!/bin/bash

set -exo pipefail

stagedir="$SRC_DIR/db-staging"
rm -rf "$stagedir"
make install DESTDIR="$stagedir"
make install -C contrib DESTDIR="$stagedir"

while IFS= read -r binary; do
    rm -f "$stagedir$PREFIX/bin/$binary"
done < "$RECIPE_DIR/client_binaries.txt"
rm -f "$stagedir$PREFIX/bin/pg_config"
rm -f "$stagedir$PREFIX/lib"/libpq.*
rm -f "$stagedir$PREFIX/lib/pkgconfig/libpq.pc"
rm -rf "$stagedir$PREFIX/include"
rm -rf "$stagedir$PREFIX/lib/bitcode"
rm -f \
    "$stagedir$PREFIX/lib/llvmjit.so" \
    "$stagedir$PREFIX/lib/llvmjit.dylib" \
    "$stagedir$PREFIX/lib/llvmjit_types.bc"

cp -a "$stagedir$PREFIX/." "$PREFIX/"
