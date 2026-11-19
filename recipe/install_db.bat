@echo on

set "STAGEDIR=%SRC_DIR%\db-staging"
if exist "%STAGEDIR%" RD /s /q "%STAGEDIR%"
meson install --no-rebuild --destdir "%STAGEDIR%" -C build

for /r "%STAGEDIR%" %%F in (postgres.exe) do if exist "%%F" set "STAGEBIN=%%~dpF"
if not exist "%STAGEBIN%\postgres.exe" exit 1
for %%D in ("%STAGEBIN%..") do set "STAGEPREFIX=%%~fD"

for /f "usebackq delims=" %%B in ("%RECIPE_DIR%\client_binaries.txt") do del /q "%STAGEBIN%\%%B.exe"
del /q "%STAGEBIN%\pg_config.exe"
del /q "%STAGEBIN%\libpq.dll"
del /q "%STAGEPREFIX%\lib\libpq.lib"
del /q "%STAGEPREFIX%\lib\pkgconfig\libpq.pc"
RD /s /q "%STAGEPREFIX%\include"

XCOPY /s /e /i /y "%STAGEPREFIX%\*" "%LIBRARY_PREFIX%\"
if errorlevel 1 exit 1
