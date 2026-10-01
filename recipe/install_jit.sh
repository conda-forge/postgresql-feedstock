#!/bin/bash

set -exo pipefail

make install
make install -C contrib

find "$PREFIX" -mindepth 1 -maxdepth 1 ! -name lib -exec rm -rf {} +
find "$PREFIX/lib" -mindepth 1 -maxdepth 1 \
	! -name bitcode \
	! -name llvmjit.so \
	! -name llvmjit.dylib \
	! -name llvmjit_types.bc \
	-exec rm -rf {} +
