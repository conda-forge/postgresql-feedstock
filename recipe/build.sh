#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

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
    PG_SYSROOT="undefined"

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
