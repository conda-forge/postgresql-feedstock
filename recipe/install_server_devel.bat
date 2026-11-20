@echo on

set "STAGEDIR=%SRC_DIR%\server-devel-staging"
if exist "%STAGEDIR%" RD /s /q "%STAGEDIR%"
meson install --no-rebuild --destdir "%STAGEDIR%" -C build

for /r "%STAGEDIR%" %%F in (postgres.h) do if exist "%%F" set "STAGEINCSERVER=%%~dpF"
for %%D in ("%STAGEINCSERVER%.") do set "STAGEINCSERVER=%%~fD"
if not exist "%STAGEINCSERVER%\postgres.h" exit 1
ROBOCOPY "%STAGEINCSERVER%" "%LIBRARY_INC%\server" /E
if errorlevel 8 exit 1
