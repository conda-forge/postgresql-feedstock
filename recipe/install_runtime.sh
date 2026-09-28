#!/bin/bash

set -exo pipefail

make install
find $PREFIX/bin -type f ! -name pg_config -exec rm {} \;
rm -f "$PREFIX/lib/llvmjit.so" "$PREFIX/lib/llvmjit.dylib" "$PREFIX/lib/llvmjit_types.bc"
