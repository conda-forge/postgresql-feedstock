@echo on

set "STAGEDIR=%SRC_DIR%\client-staging"
if exist "%STAGEDIR%" RD /s /q "%STAGEDIR%"
meson install --no-rebuild --destdir "%STAGEDIR%" -C build

if not exist "%LIBRARY_BIN%" mkdir "%LIBRARY_BIN%"
for /f "usebackq delims=" %%B in ("%RECIPE_DIR%\client_binaries.txt") do (
    for /r "%STAGEDIR%" %%F in (%%B.exe) do if exist "%%F" COPY /y "%%F" "%LIBRARY_BIN%"
)
if errorlevel 1 exit 1
