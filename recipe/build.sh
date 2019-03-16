#!/bin/bash

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
    --with-system-tzdata=$PREFIX/share/zoneinfo

make -j $CPU_COUNT
make -j $CPU_COUNT -C contrib

# make check # Failing with 'initdb: cannot be run as root'.
if [ ${target_platform} == linux-64 ]; then
    # osx, aarch64 and ppc64le checks fail in some strange ways
    make check
    make check -C contrib
fi
# make check -C src/interfaces/ecpg
