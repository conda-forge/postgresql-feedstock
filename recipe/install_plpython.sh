set -x
set -e

export PG_CONFIG_ARGS="--with-python"
bash $RECIPE_DIR/build.sh
make install
