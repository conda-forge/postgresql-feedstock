#!/bin/bash

set -exo pipefail

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
    EXTRA_CONFIG_ARGS="LDFLAGS_EX_BE=-Wl,--export-dynamic"
fi

./configure \
    --prefix=$PREFIX \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
    --enable-thread-safety \
    --with-gssapi \
    --with-icu \
    --with-ldap \
    --with-libxml \
    --with-libxslt \
    --with-lz4 \
    --with-zstd \
    --with-openssl \
    --with-uuid=e2fs \
    --with-system-tzdata=$PREFIX/share/zoneinfo \
    PG_SYSROOT="undefined" \
    $EXTRA_CONFIG_ARGS


make -j $CPU_COUNT
make -j $CPU_COUNT -C contrib

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    # make check # Failing with 'initdb: cannot be run as root'.
    if [ ${target_platform} == linux-64 ]; then
        # osx, aarch64 and ppc64le checks fail in some strange ways
        make check
        make check -C contrib
    fi
    # make check -C src/interfaces/ecpg
fi
