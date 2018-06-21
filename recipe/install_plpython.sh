set -x
set -e

cd src/pl/plpython
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
    --with-gssapi
    --with-python

make
make install
