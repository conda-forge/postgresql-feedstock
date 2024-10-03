@echo on

:: Check if running in a CI environment
if "%CI%"=="true" (
    echo Running in a CI environment. Deleting existing PostgreSQL installation.
    RD /S /Q "C:\Program Files\PostgreSQL"
)

if "%PY_VER%" == "2.7" goto :msbuildpath
if "%PY_VER%" == "3.4" goto :msbuildpath
goto :havemsbuild

:msbuildpath
  :: Need to move a more current msbuild into PATH.  32-bit one in particular on AppVeyor barfs on the solution that
  ::    Postgres writes here.  This one comes from the Win7 SDK (.net 4.0), and is known to work.
  set "PATH=%CD%;C:\Windows\Microsoft.NET\Framework\v4.0.30319;%PATH%"

:havemsbuild


if "%ARCH%" == "32" (
   set ARCH=Win32
) else (
   set ARCH=x64
)

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

meson compile -C build
if errorlevel 1 exit 1

:: Run a minimal set of tests.
meson test --print-errorlogs --no-rebuild -C build --suite setup
if errorlevel 1 exit 1

:: The main regression tests may take too long for this purpose.
meson test --print-errorlogs --no-rebuild -C build --suite regress
if errorlevel 1 exit 1
