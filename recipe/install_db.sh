#!/bin/bash

set -exo pipefail

make install
make install -C contrib
