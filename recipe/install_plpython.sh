#!/bin/bash

set -exo pipefail

EXTRA_FEATURES=""
EXTRA_CONFIG_ARGS=""

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

EXTRA_FEATURES+=" --with-llvm"

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" && "${target_platform}" == linux* ]]; then
    # Only add this flag during cross-compilation on Linux platforms
    EXTRA_CONFIG_ARGS+=" LDFLAGS_EX_BE=-Wl,--export-dynamic"
fi

export PYTHON=$PREFIX/bin/python
./configure \
    --prefix=$PREFIX \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
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
    --with-python \
    $EXTRA_FEATURES \
    PG_SYSROOT="undefined" \
    $EXTRA_CONFIG_ARGS

for dir in src/pl/plpython contrib/hstore_plpython; do
  pushd $dir
  make clean
  make
  make install
  popd
done
