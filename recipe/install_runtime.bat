set "STAGEDIR=%SRC_DIR%\runtime-staging"
if exist "%STAGEDIR%" RD /s /q "%STAGEDIR%"
meson install --no-rebuild --destdir "%STAGEDIR%" -C build

if not exist "%LIBRARY_BIN%" mkdir "%LIBRARY_BIN%"
if not exist "%LIBRARY_LIB%\pkgconfig" mkdir "%LIBRARY_LIB%\pkgconfig"
for /r "%STAGEDIR%" %%F in (pg_config.exe) do if exist "%%F" COPY /y "%%F" "%LIBRARY_BIN%"
for /r "%STAGEDIR%" %%F in (libpq.dll) do if exist "%%F" COPY /y "%%F" "%LIBRARY_BIN%"
for /r "%STAGEDIR%" %%F in (libpq.lib) do if exist "%%F" COPY /y "%%F" "%LIBRARY_LIB%"
for /r "%STAGEDIR%" %%F in (libpq.pc) do if exist "%%F" COPY /y "%%F" "%LIBRARY_LIB%\pkgconfig\"
for /r "%STAGEDIR%" %%F in (libpq-fe.h) do if exist "%%F" set "STAGEINC=%%~dpF"
for %%D in ("%STAGEINC%.") do set "STAGEINC=%%~fD"
if not exist "%STAGEINC%\libpq-fe.h" exit 1
ROBOCOPY "%STAGEINC%" "%LIBRARY_INC%" /E /XD server
if errorlevel 8 exit 1
