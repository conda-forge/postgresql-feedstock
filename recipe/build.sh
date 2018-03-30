#!/bin/bash

./configure \
    --prefix=$PREFIX \
    --with-readline \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
    --with-openssl \
    --with-gssapi

make -j $CPU_COUNT
# make check # Failing with 'initdb: cannot be run as root'.
