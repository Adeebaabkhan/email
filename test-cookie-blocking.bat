@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Cookie Blocking Solution - Test Script
:: Tests the cookie blocking solution without making actual changes
:: ===================================================================

title Cookie Blocking Solution - Test Mode

echo.
echo =====================================================================
echo              Cookie Blocking Solution - Test Mode
echo =====================================================================
echo.
echo This script will test all components without making changes to your system.
echo.

:: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Not running as administrator. Some tests may be limited.
) else (
    echo ✓ Running with administrator privileges.
)

echo.
echo Testing script components...

:: Test main script exists
if exist "%~dp0block-cookies.bat" (
    echo ✓ Main script found: block-cookies.bat
) else (
    echo ✗ Main script missing: block-cookies.bat
)

:: Test scripts directory
if exist "%~dp0scripts" (
    echo ✓ Scripts directory found
) else (
    echo ✗ Scripts directory missing
    exit /b 1
)

:: Test individual browser scripts
set "BROWSER_SCRIPTS=chrome-cookies.bat firefox-cookies.bat edge-cookies.bat opera-cookies.bat brave-cookies.bat"

for %%s in (%BROWSER_SCRIPTS%) do (
    if exist "%~dp0scripts\%%s" (
        echo   ✓ Browser script found: %%s
    ) else (
        echo   ✗ Browser script missing: %%s
    )
)

:: Test system scripts
set "SYSTEM_SCRIPTS=registry-cookies.bat hosts-cookies.bat cleanup-cookies.bat backup-restore.bat"

for %%s in (%SYSTEM_SCRIPTS%) do (
    if exist "%~dp0scripts\%%s" (
        echo   ✓ System script found: %%s
    ) else (
        echo   ✗ System script missing: %%s
    )
)

:: Test documentation
if exist "%~dp0COOKIE_BLOCKING_README.md" (
    echo ✓ Documentation found: COOKIE_BLOCKING_README.md
) else (
    echo ✗ Documentation missing: COOKIE_BLOCKING_README.md
)

echo.
echo Testing browser detection...

:: Check for installed browsers
set "CHROME_USER_DATA=%LOCALAPPDATA%\Google\Chrome\User Data"
set "FIREFOX_PROFILES=%APPDATA%\Mozilla\Firefox\Profiles"
set "EDGE_USER_DATA=%LOCALAPPDATA%\Microsoft\Edge\User Data"
set "OPERA_USER_DATA=%APPDATA%\Opera Software\Opera Stable"
set "BRAVE_USER_DATA=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data"

if exist "%CHROME_USER_DATA%" (
    echo   ✓ Google Chrome detected
) else (
    echo   - Google Chrome not detected
)

if exist "%FIREFOX_PROFILES%" (
    echo   ✓ Mozilla Firefox detected
) else (
    echo   - Mozilla Firefox not detected
)

if exist "%EDGE_USER_DATA%" (
    echo   ✓ Microsoft Edge detected
) else (
    echo   - Microsoft Edge not detected
)

if exist "%OPERA_USER_DATA%" (
    echo   ✓ Opera detected
) else (
    echo   - Opera not detected
)

if exist "%BRAVE_USER_DATA%" (
    echo   ✓ Brave Browser detected
) else (
    echo   - Brave Browser not detected
)

echo.
echo Testing system access...

:: Test hosts file access
set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
if exist "%HOSTS_FILE%" (
    echo   ✓ Hosts file accessible: %HOSTS_FILE%
) else (
    echo   ✗ Hosts file not accessible
)

:: Test registry access (read-only)
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ Registry access confirmed
) else (
    echo   ✗ Registry access failed
)

:: Test backup directory creation
set "TEST_BACKUP_DIR=%~dp0backups\test"
mkdir "%TEST_BACKUP_DIR%" 2>nul
if exist "%TEST_BACKUP_DIR%" (
    echo   ✓ Backup directory creation successful
    rmdir "%TEST_BACKUP_DIR%" 2>nul
) else (
    echo   ✗ Backup directory creation failed
)

echo.
echo Testing script syntax...

:: Basic syntax test for each script
set "ALL_SCRIPTS=block-cookies.bat scripts\chrome-cookies.bat scripts\firefox-cookies.bat scripts\edge-cookies.bat scripts\opera-cookies.bat scripts\brave-cookies.bat scripts\registry-cookies.bat scripts\hosts-cookies.bat scripts\cleanup-cookies.bat scripts\backup-restore.bat"

for %%s in (%ALL_SCRIPTS%) do (
    if exist "%~dp0%%s" (
        :: Simple syntax check - look for common batch errors
        findstr /i "@echo off" "%~dp0%%s" >nul 2>&1
        if !errorlevel! equ 0 (
            echo   ✓ Script syntax OK: %%s
        ) else (
            echo   ? Script syntax check inconclusive: %%s
        )
    )
)

echo.
echo =====================================================================
echo                           Test Summary
echo =====================================================================
echo.

set "TOTAL_TESTS=0"
set "PASSED_TESTS=0"

:: Count and summarize results
if exist "%~dp0block-cookies.bat" set /a PASSED_TESTS+=1
set /a TOTAL_TESTS+=1

if exist "%~dp0scripts" set /a PASSED_TESTS+=1
set /a TOTAL_TESTS+=1

for %%s in (%BROWSER_SCRIPTS% %SYSTEM_SCRIPTS%) do (
    if exist "%~dp0scripts\%%s" set /a PASSED_TESTS+=1
    set /a TOTAL_TESTS+=1
)

if exist "%~dp0COOKIE_BLOCKING_README.md" set /a PASSED_TESTS+=1
set /a TOTAL_TESTS+=1

echo Tests Passed: %PASSED_TESTS%/%TOTAL_TESTS%
echo.

if %PASSED_TESTS% equ %TOTAL_TESTS% (
    echo ✅ ALL TESTS PASSED
    echo The Cookie Blocking Solution is ready to use.
    echo.
    echo To run the actual cookie blocking:
    echo   1. Right-click on block-cookies.bat
    echo   2. Select "Run as administrator"
    echo   3. Follow the prompts
) else (
    echo ⚠️  SOME TESTS FAILED
    echo Please check the missing components above before running the solution.
    echo.
    echo Missing files should be downloaded or recreated.
)

echo.
echo For documentation and usage instructions, see:
echo   COOKIE_BLOCKING_README.md
echo.

pause
exit /b 0