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
    --with-libxslt \
    --with-gssapi

make -j $CPU_COUNT
make -j $CPU_COUNT -C contrib

make check
# plpython can't find libpython3 during check time on Linux only.
# We add the LD_LIBRARY_PATH to assist on that issue. This does not
# impact the library after it is installed.
LD_LIBRARY_PATH=$PREFIX/lib make check -C src/pl
LD_LIBRARY_PATH=$PREFIX/lib make check -C contrib
make check -C src/interfaces/ecpg

make install
make install -C contrib
