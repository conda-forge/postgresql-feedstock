#!/bin/bash

set -exo pipefail

make install -C src/backend/jit/llvm
