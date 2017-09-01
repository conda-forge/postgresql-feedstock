from os import environ, path
from subprocess import check_call

SRC_DIR = environ['SRC_DIR']
INSTALL_DIRS = [
  'config',
  'src/include',
  'src/common',
  'src/interfaces',
  'src/bin',
  'src/port',
  'src/makefiles',
]
BUILD_DIRS = []
BUILD_DIRS += INSTALL_DIRS

for dir in BUILD_DIRS:
    check_call(['make', '-C', path.join(SRC_DIR, dir)])

for dir in INSTALL_DIRS:
    check_call(['make', '-C', path.join(SRC_DIR, dir), 'install'])

check_call(['make', '-C', path.join(SRC_DIR, 'src'), 'install-local'])
