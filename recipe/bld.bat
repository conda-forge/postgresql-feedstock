@echo on

pushd src\tools\msvc

echo $config-^>{openssl} = '%LIBRARY_PREFIX%'; >> config.pl
echo $config-^>{zlib} = '%LIBRARY_PREFIX%';    >> config.pl
echo $config-^>{xml} = '%LIBRARY_PREFIX%';     >> config.pl
echo $config-^>{xslt} = '%LIBRARY_PREFIX%';    >> config.pl
echo $config-^>{iconv} = '%LIBRARY_PREFIX%';   >> config.pl
echo $config-^>{gss} = '%LIBRARY_PREFIX%';     >> config.pl

:: Appveyor's postgres install is on PATH and interferes with testing
IF NOT "%APPVEYOR%" == "" (
    ECHO Deleting AppVeyor's PostgreSQL installs
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

:: Attempt to fix x509v3.h include
set WIN32_LEAN_AND_MEAN=1

perl mkvcbuild.pl
if %ERRORLEVEL% NEQ 0 exit 1

call msbuild %SRC_DIR%\pgsql.sln /p:Configuration=Release /p:Platform="%ARCH%"
if %ERRORLEVEL% NEQ 0 exit 1
