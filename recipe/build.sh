#!/bin/bash

set -exo pipefail

EXTRA_CONFIG_ARGS=""

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" && "${target_platform}" == linux* ]]; then
    # Only add this flag during cross-compilation on Linux platforms
    EXTRA_CONFIG_ARGS+=" LDFLAGS_EX_BE=-Wl,--export-dynamic"
fi

./configure \
    --prefix=$PREFIX \
    --with-readline \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
    --with-openssl \
    --with-uuid=e2fs \
    --with-libxml \
    --with-libxslt \
    --with-gssapi \
    --with-system-tzdata=$PREFIX/share/zoneinfo \
    PG_SYSROOT="undefined" \
    $EXTRA_CONFIG_ARGS

make -j $CPU_COUNT
make -j $CPU_COUNT -C contrib

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check
    make check -C contrib
fi
