set -x
set -e
export PYTHON=$PREFIX/bin/python
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
    --with-python

for dir in src/pl/plpython contrib/hstore_plpython; do
  pushd $dir
  make clean
  make
  make install
  popd
done
