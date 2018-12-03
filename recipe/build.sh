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

make check
make check -C contrib
# make check -C src/interfaces/ecpg
