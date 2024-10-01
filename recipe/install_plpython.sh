#!/bin/bash

set -exo pipefail

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

export PYTHON=$PREFIX/bin/python
./configure \
    --prefix=$PREFIX \
    --with-libraries=$PREFIX/lib \
    --with-includes=$PREFIX/include \
    --enable-thread-safety \
    --with-gssapi \
    --with-icu \
    --with-libxml \
    --with-libxslt \
    --with-openssl \
    --with-uuid=e2fs \
    --with-system-tzdata=$PREFIX/share/zoneinfo \
    --with-python

for dir in src/pl/plpython contrib/hstore_plpython; do
  pushd $dir
  make clean
  make
  make install
  popd
done
