#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    LDFLAGS="-rpath $PREFIX/lib $LDFLAGS"
fi

./configure \
    --prefix=$PREFIX \
    --without-readline \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
    --with-openssl \
    --with-gssapi \
    --with-pam \
    --with-ldap

make
# make check # Failing with 'initdb: cannot be run as root'.
make install
