@echo on

meson setup ^
   --prefix=%LIBRARY_PREFIX% ^
   --backend ninja ^
   --buildtype=release ^
   -Dcassert=false ^
   -Dnls=disabled ^
   -Dplperl=disabled ^
   -Dpltcl=disabled ^
   -Dextra_include_dirs=%LIBRARY_INC% ^
   -Dextra_lib_dirs=%LIBRARY_LIB% ^
   build
if errorlevel 1 exit 1

ninja -C build -j %CPU_COUNT%
if errorlevel 1 exit 1

:: Run a minimal set of tests.
meson test --print-errorlogs --no-rebuild -C build --suite setup
if errorlevel 1 exit 1

:: The main regression tests take too long for this purpose. Skipping them.
:: meson test --print-errorlogs --no-rebuild -C build --suite regress
:: if errorlevel 1 exit 1
