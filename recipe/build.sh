#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    LDFLAGS="-rpath $PREFIX/lib $LDFLAGS"
fi

./configure \
    --prefix=$PREFIX \
    --with-readline \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
    --with-openssl \
    --with-python \
    --with-uuid=e2fs \
    --with-libxml \
    --with-gssapi

make -j $CPU_COUNT
make -j $CPU_COUNT -C contrib

make check

make install
make install -C contrib
