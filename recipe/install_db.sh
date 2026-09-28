#!/bin/bash

set -exo pipefail

make install
make install -C contrib
rm -f "$PREFIX/lib/llvmjit.so" "$PREFIX/lib/llvmjit.dylib" "$PREFIX/lib/llvmjit_types.bc"
