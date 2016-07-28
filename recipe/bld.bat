cd src\tools\msvc

echo $config-^>{openssl} = '%LIBRARY_PREFIX%'; >> config.pl
echo $config-^>{zlib} = '%LIBRARY_PREFIX%';    >> config.pl
echo $config-^>{python} = '%PREFIX%';          >> config.pl

:: Appveyor's postgres install is on PATH and interferes with testing
IF NOT "%APPVEYOR%" == "" (
    RD /S /Q "C:\Program Files\PostgreSQL"
)

:: Need to move a more current msbuild into PATH.  32-bit one in particular on AppVeyor barfs on the solution that
::    Postgres writes here.  This one comes from the Win7 SDK (.net 4.0), and is known to work.
if "%ARCH%" == "32" (
   COPY C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe .\
   set "PATH=%CD%;%PATH%"
   set ARCH=Win32
) else (
   set ARCH=x64
)

perl mkvcbuild.pl
call msbuild %SRC_DIR%\pgsql.sln /p:Configuration=Release /p:Platform="%ARCH%" /m
if errorlevel 1 exit 1
call install.bat "%LIBRARY_PREFIX%"
if errorlevel 1 exit 1

REM On windows, it is necessary to start a server for the tests to connect to and run on
ECHO Creating data dir in C:\pgdata
mkdir C:\pgdata
:: Ensure that the work dir is writeable by the test process
icacls "c:\pgdata" /grant Everyone:(OI)(CI)F
"%LIBRARY_BIN%\initdb.exe" -D C:\pgdata
"%LIBRARY_BIN%\pg_ctl" -D "C:\pgdata" -l logfile start

echo Started server I think...

set PATH

call vcregress check
if errorlevel 1 call :done 1
call vcregress installcheck
if errorlevel 1 call :done 1
call vcregress plcheck
if errorlevel 1 call :done 1
call vcregress contribcheck
if errorlevel 1 call :done 1
call vcregress modulescheck
if errorlevel 1 call :done 1
call vcregress ecpgcheck
if errorlevel 1 call :done 1
call vcregress isolationcheck
if errorlevel 1 call :done 1
call vcregress upgradecheck
if errorlevel 1 call :done 1
:: This requires an extra perl module to run.  See
::    https://www.postgresql.org/docs/current/static/install-windows-full.html#AEN29138
:: call vcregress bincheck
:: if errorlevel 1 call :done 1

call :done 0

:done
  :: Kill any running server
  "%LIBRARY_BIN%\pg_ctl" stop -D C:\pgdata -m i
  rd /s /q C:\pgdata
  exit %~1
