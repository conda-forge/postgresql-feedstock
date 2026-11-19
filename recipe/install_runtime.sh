#!/bin/bash

set -exo pipefail

stagedir="$SRC_DIR/runtime-staging"
rm -rf "$stagedir"
make install DESTDIR="$stagedir"

mkdir -p "$PREFIX/bin" "$PREFIX/include" "$PREFIX/lib/pkgconfig"
cp "$stagedir$PREFIX/bin/pg_config" "$PREFIX/bin/"
cp -a "$stagedir$PREFIX/include/." "$PREFIX/include/"
rm -rf "$PREFIX/include/server"
cp "$stagedir$PREFIX/lib/libpq.a" "$PREFIX/lib/"
cp "$stagedir$PREFIX/lib/pkgconfig/libpq.pc" "$PREFIX/lib/pkgconfig/"

find "$stagedir$PREFIX/lib" -maxdepth 1 \
    \( -name 'libpq.so*' -o -name 'libpq*.dylib' \) \
    -exec cp -a {} "$PREFIX/lib/" \;
