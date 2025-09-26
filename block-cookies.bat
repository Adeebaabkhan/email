@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Cookie Blocking Solution - Main Orchestration Script
:: Comprehensive cookie blocking for Windows 10/11
:: Supports: Chrome, Firefox, Edge, Opera, Brave
:: ===================================================================

title Cookie Blocking Solution v1.0

:: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo ERROR: Administrator privileges required
    echo ========================================
    echo.
    echo This script needs to run as Administrator to:
    echo - Modify Windows registry
    echo - Edit hosts file
    echo - Access browser directories
    echo.
    echo Please right-click this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Set up logging
set "LOG_DIR=%~dp0logs"
set "LOG_FILE=%LOG_DIR%\cookie-blocking-%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: Initialize log file
echo ===================================================================== > "%LOG_FILE%"
echo Cookie Blocking Solution - Execution Log >> "%LOG_FILE%"
echo Started: %date% %time% >> "%LOG_FILE%"
echo ===================================================================== >> "%LOG_FILE%"

:: Display banner
cls
echo.
echo =====================================================================
echo                    Cookie Blocking Solution v1.0
echo =====================================================================
echo.
echo This tool will help you block cookies across multiple browsers
echo and configure system-level privacy settings on Windows.
echo.
echo Supported Browsers:
echo   - Google Chrome
echo   - Mozilla Firefox
echo   - Microsoft Edge
echo   - Opera
echo   - Brave Browser
echo.
echo Actions that will be performed:
echo   1. Create backup of current settings
echo   2. Modify browser configurations to block cookies
echo   3. Update Windows registry for system-level blocking
echo   4. Configure hosts file to block tracking domains
echo   5. Clean existing cookies from browsers
echo.

:: User confirmation
echo WARNING: This will modify browser settings and system configuration.
echo A backup will be created for all changes.
echo.
set /p "CONFIRM=Do you want to continue? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Operation cancelled by user.
    echo Operation cancelled by user. >> "%LOG_FILE%"
    pause
    exit /b 0
)

echo.
echo Starting cookie blocking process...
echo Starting cookie blocking process... >> "%LOG_FILE%"

:: Create backup first
echo.
echo [1/6] Creating backup of current settings...
call "%~dp0scripts\backup-restore.bat" backup
if %errorlevel% neq 0 (
    echo ERROR: Backup creation failed! >> "%LOG_FILE%"
    echo ERROR: Backup creation failed! Aborting operation.
    pause
    exit /b 1
)
echo Backup completed successfully.
echo Backup completed successfully. >> "%LOG_FILE%"

:: Browser cookie blocking
echo.
echo [2/6] Configuring browsers to block cookies...
call "%~dp0scripts\chrome-cookies.bat"
call "%~dp0scripts\firefox-cookies.bat"
call "%~dp0scripts\edge-cookies.bat"
call "%~dp0scripts\opera-cookies.bat"
call "%~dp0scripts\brave-cookies.bat"
echo Browser configuration completed.
echo Browser configuration completed. >> "%LOG_FILE%"

:: Registry modifications
echo.
echo [3/6] Applying Windows registry modifications...
call "%~dp0scripts\registry-cookies.bat"
echo Registry modifications completed.
echo Registry modifications completed. >> "%LOG_FILE%"

:: Hosts file modifications
echo.
echo [4/6] Updating hosts file to block tracking domains...
call "%~dp0scripts\hosts-cookies.bat"
echo Hosts file updated.
echo Hosts file updated. >> "%LOG_FILE%"

:: Cleanup existing cookies
echo.
echo [5/6] Cleaning existing cookies from browsers...
call "%~dp0scripts\cleanup-cookies.bat"
echo Cookie cleanup completed.
echo Cookie cleanup completed. >> "%LOG_FILE%"

:: Final summary
echo.
echo [6/6] Cookie blocking configuration completed!
echo.
echo =====================================================================
echo                          OPERATION COMPLETED
echo =====================================================================
echo.
echo Cookie blocking has been successfully configured for:
echo   ✓ Chrome, Firefox, Edge, Opera, Brave browsers
echo   ✓ Windows system-level settings
echo   ✓ Network-level tracking domain blocking
echo   ✓ Existing cookies cleaned
echo.
echo Backup location: %~dp0backups\backup-%date:~-4,4%-%date:~-10,2%-%date:~-7,2%\
echo Log file: %LOG_FILE%
echo.
echo To restore previous settings, run: scripts\backup-restore.bat restore
echo.

echo Operation completed successfully. >> "%LOG_FILE%"
echo Completed: %date% %time% >> "%LOG_FILE%"

pause
exit /b 0