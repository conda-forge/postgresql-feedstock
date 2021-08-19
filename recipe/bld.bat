@echo on

pushd src\tools\msvc

echo $config-^>{openssl} = '%LIBRARY_PREFIX%'; >> config.pl
echo $config-^>{zlib} = '%LIBRARY_PREFIX%';    >> config.pl
echo $config-^>{xml} = '%LIBRARY_PREFIX%';     >> config.pl
echo $config-^>{xslt} = '%LIBRARY_PREFIX%';    >> config.pl
echo $config-^>{iconv} = '%LIBRARY_PREFIX%';   >> config.pl
echo $config-^>{gss} = '%LIBRARY_PREFIX%';     >> config.pl

:: the msvc solution expects that the krb5 links are in this directory
if not exist "%PREFIX%\Library\lib\amd64" md "%PREFIX%\Library\lib\amd64"
COPY "%PREFIX%\Library\lib\krb5_64.lib" "%PREFIX%\Library\lib\amd64\krb5_64.lib"
COPY "%PREFIX%\Library\lib\comerr64.lib" "%PREFIX%\Library\lib\amd64\comerr64.lib"
COPY "%PREFIX%\Library\lib\gssapi64" "%PREFIX%\Library\lib\amd64\gssapi64.lib"

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

perl mkvcbuild.pl
if %ERRORLEVEL% NEQ 0 exit 1

call msbuild %SRC_DIR%\pgsql.sln /p:Configuration=Release /p:Platform="%ARCH%"
if %ERRORLEVEL% NEQ 0 exit 1
