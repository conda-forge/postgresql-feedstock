#!/bin/bash

set -exo pipefail

EXTRA_FEATURES=""
EXTRA_CONFIG_ARGS=""

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" && "${target_platform}" == linux* ]]; then
    # Only add this flag during cross-compilation on Linux platforms
    EXTRA_CONFIG_ARGS+=" LDFLAGS_EX_BE=-Wl,--export-dynamic"
fi

# ARMv8+ CRC32 vector support
if [[ "${target_platform}" == "linux-aarch64" ]]; then
    export CPPFLAGS="${CPPFLAGS:-} -DHWCAP_CRC32=0x80 -DHWCAP_SVE=0x400000"
fi

if [[ "${target_platform}" == linux* ]]; then
    EXTRA_FEATURES+=" --with-liburing"
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
    --with-ssl=openssl \
    --with-uuid=e2fs \
    --with-zstd \
    --with-system-tzdata=$PREFIX/share/zoneinfo \
    $EXTRA_FEATURES \
    PG_SYSROOT="undefined" \
    $EXTRA_CONFIG_ARGS


make -j $CPU_COUNT
make -j $CPU_COUNT -C contrib

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check
    make check -C contrib
fi
