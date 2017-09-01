from glob import glob
from os import environ, path
from subprocess import check_call

import platform

SRC_DIR = environ['SRC_DIR']
INSTALL_DIRS = filter(path.isdir, glob(path.join(SRC_DIR, 'contrib', '*')))
INSTALL_DIRS = filter(lambda x: not (x.endswith('plpython')
                                     or x.endswith('plperl')
                                     or x.endswith('start-scripts')
                                     or x.endswith('sepgsql')),
                      INSTALL_DIRS)
INSTALL_DIRS = list(INSTALL_DIRS)

BUILD_DIRS = []
BUILD_DIRS += INSTALL_DIRS

for dir in BUILD_DIRS:
    check_call(['make', '-C', path.join(SRC_DIR, dir)])

for dir in INSTALL_DIRS:
    check_call(['make', '-C', path.join(SRC_DIR, dir), 'install'])
