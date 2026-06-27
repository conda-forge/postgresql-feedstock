#!/bin/bash

set -exo pipefail

make install
find $PREFIX/bin -type f ! -name pg_config -exec rm {} \;
