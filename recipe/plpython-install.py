from os import environ, path
from subprocess import check_call

SRC_DIR = environ['SRC_DIR']
INSTALL_DIRS = [
  'src/pl/plpython',
  'contrib/hstore_plpython',
  'contrib/ltree_plpython',
]
BUILD_DIRS = []
BUILD_DIRS += INSTALL_DIRS

for dir in BUILD_DIRS:
    check_call(['make', '-C', path.join(SRC_DIR, dir)])

for dir in INSTALL_DIRS:
    check_call(['make', '-C', path.join(SRC_DIR, dir), 'install'])
