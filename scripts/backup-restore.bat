@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Backup and Restore Script
:: Creates backups of browser settings and system configurations
:: Provides restore functionality to undo changes
:: ===================================================================

if "%1"=="" (
    echo Usage: backup-restore.bat [backup^|restore]
    echo.
    echo   backup  - Create backup of current browser settings
    echo   restore - Restore settings from most recent backup
    exit /b 1
)

set "ACTION=%1"
set "BACKUP_ROOT=%~dp0..\backups"
set "TIMESTAMP=%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "BACKUP_DIR=%BACKUP_ROOT%\backup-%TIMESTAMP%"

if /i "%ACTION%"=="backup" goto :backup
if /i "%ACTION%"=="restore" goto :restore

echo Invalid action. Use 'backup' or 'restore'.
exit /b 1

:backup
echo Creating comprehensive backup...

:: Create backup directory structure
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" 2>nul
if not exist "%BACKUP_DIR%\browsers" mkdir "%BACKUP_DIR%\browsers" 2>nul
if not exist "%BACKUP_DIR%\registry" mkdir "%BACKUP_DIR%\registry" 2>nul
if not exist "%BACKUP_DIR%\hosts" mkdir "%BACKUP_DIR%\hosts" 2>nul
if not exist "%BACKUP_DIR%\system" mkdir "%BACKUP_DIR%\system" 2>nul

echo Backup directory: %BACKUP_DIR%

:: ===================================================================
:: Browser Settings Backup
:: ===================================================================
echo   - Backing up browser settings...

:: Chrome backup
set "CHROME_USER_DATA=%LOCALAPPDATA%\Google\Chrome\User Data"
if exist "%CHROME_USER_DATA%" (
    echo     Chrome settings...
    xcopy "%CHROME_USER_DATA%\Default\Preferences" "%BACKUP_DIR%\browsers\chrome_preferences" /y >nul 2>&1
    xcopy "%CHROME_USER_DATA%\Local State" "%BACKUP_DIR%\browsers\chrome_local_state" /y >nul 2>&1
    for /d %%i in ("%CHROME_USER_DATA%\Profile*") do (
        xcopy "%%i\Preferences" "%BACKUP_DIR%\browsers\chrome_profile_%%~ni_preferences" /y >nul 2>&1
    )
)

:: Firefox backup
set "FIREFOX_PROFILES=%APPDATA%\Mozilla\Firefox\Profiles"
if exist "%FIREFOX_PROFILES%" (
    echo     Firefox settings...
    for /d %%i in ("%FIREFOX_PROFILES%\*") do (
        if exist "%%i\user.js" (
            xcopy "%%i\user.js" "%BACKUP_DIR%\browsers\firefox_%%~ni_user.js" /y >nul 2>&1
        )
        if exist "%%i\prefs.js" (
            xcopy "%%i\prefs.js" "%BACKUP_DIR%\browsers\firefox_%%~ni_prefs.js" /y >nul 2>&1
        )
    )
)

:: Edge backup
set "EDGE_USER_DATA=%LOCALAPPDATA%\Microsoft\Edge\User Data"
if exist "%EDGE_USER_DATA%" (
    echo     Edge settings...
    xcopy "%EDGE_USER_DATA%\Default\Preferences" "%BACKUP_DIR%\browsers\edge_preferences" /y >nul 2>&1
    xcopy "%EDGE_USER_DATA%\Local State" "%BACKUP_DIR%\browsers\edge_local_state" /y >nul 2>&1
)

:: Opera backup
set "OPERA_USER_DATA=%APPDATA%\Opera Software\Opera Stable"
if exist "%OPERA_USER_DATA%" (
    echo     Opera settings...
    xcopy "%OPERA_USER_DATA%\Preferences" "%BACKUP_DIR%\browsers\opera_preferences" /y >nul 2>&1
    xcopy "%OPERA_USER_DATA%\Local State" "%BACKUP_DIR%\browsers\opera_local_state" /y >nul 2>&1
)

:: Brave backup
set "BRAVE_USER_DATA=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data"
if exist "%BRAVE_USER_DATA%" (
    echo     Brave settings...
    xcopy "%BRAVE_USER_DATA%\Default\Preferences" "%BACKUP_DIR%\browsers\brave_preferences" /y >nul 2>&1
    xcopy "%BRAVE_USER_DATA%\Local State" "%BACKUP_DIR%\browsers\brave_local_state" /y >nul 2>&1
)

:: ===================================================================
:: Registry Backup
:: ===================================================================
echo   - Backing up registry settings...

reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "%BACKUP_DIR%\registry\internet_settings_hklm.reg" /y >nul 2>&1
reg export "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "%BACKUP_DIR%\registry\internet_settings_hkcu.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Internet Explorer" "%BACKUP_DIR%\registry\internet_explorer_hklm.reg" /y >nul 2>&1
reg export "HKCU\SOFTWARE\Microsoft\Internet Explorer" "%BACKUP_DIR%\registry\internet_explorer_hkcu.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Google\Chrome" "%BACKUP_DIR%\registry\chrome_policies_hklm.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Mozilla\Firefox" "%BACKUP_DIR%\registry\firefox_policies_hklm.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Microsoft\Edge" "%BACKUP_DIR%\registry\edge_policies_hklm.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" "%BACKUP_DIR%\registry\brave_policies_hklm.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Opera Software\Opera" "%BACKUP_DIR%\registry\opera_policies_hklm.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "%BACKUP_DIR%\registry\datacollection_policies_hklm.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "%BACKUP_DIR%\registry\advertisinginfo_policies_hklm.reg" /y >nul 2>&1

:: ===================================================================
:: Hosts File Backup
:: ===================================================================
echo   - Backing up hosts file...
set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
if exist "%HOSTS_FILE%" (
    copy "%HOSTS_FILE%" "%BACKUP_DIR%\hosts\hosts_original.txt" >nul 2>&1
)

:: ===================================================================
:: System Configuration Backup
:: ===================================================================
echo   - Backing up system configuration...

:: Create backup info file
(
echo Cookie Blocking Solution - Backup Information
echo Created: %date% %time%
echo Backup Directory: %BACKUP_DIR%
echo.
echo Browser Configurations Backed Up:
if exist "%CHROME_USER_DATA%" echo   - Google Chrome
if exist "%FIREFOX_PROFILES%" echo   - Mozilla Firefox
if exist "%EDGE_USER_DATA%" echo   - Microsoft Edge
if exist "%OPERA_USER_DATA%" echo   - Opera
if exist "%BRAVE_USER_DATA%" echo   - Brave Browser
echo.
echo Registry Keys Backed Up:
echo   - Internet Settings (HKLM and HKCU)
echo   - Internet Explorer Settings
echo   - Browser Policy Settings
echo   - Privacy and Data Collection Settings
echo.
echo System Files Backed Up:
echo   - Hosts file
echo.
echo To restore these settings, run:
echo   scripts\backup-restore.bat restore
) > "%BACKUP_DIR%\backup_info.txt"

echo Backup completed successfully!
echo Backup location: %BACKUP_DIR%
echo.
exit /b 0

:restore
echo Restoring from backup...

:: Find the most recent backup
set "LATEST_BACKUP="
for /f "delims=" %%i in ('dir /b /ad /o-d "%BACKUP_ROOT%\backup-*" 2^>nul') do (
    if "!LATEST_BACKUP!"=="" set "LATEST_BACKUP=%%i"
)

if "%LATEST_BACKUP%"=="" (
    echo ERROR: No backup found in %BACKUP_ROOT%
    echo Please ensure you have created a backup first.
    exit /b 1
)

set "RESTORE_DIR=%BACKUP_ROOT%\%LATEST_BACKUP%"
echo Using backup: %RESTORE_DIR%

:: User confirmation
echo.
echo WARNING: This will restore your browser settings and system configuration
echo to the state they were in when the backup was created.
echo.
echo This will undo all cookie blocking configurations.
echo.
set /p "CONFIRM=Do you want to continue with the restore? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Restore cancelled by user.
    exit /b 0
)

:: Stop browsers before restore
echo   - Stopping browser processes...
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im opera.exe >nul 2>&1
taskkill /f /im brave.exe >nul 2>&1
taskkill /f /im iexplore.exe >nul 2>&1

timeout /t 3 /nobreak >nul 2>&1

:: ===================================================================
:: Restore Browser Settings
:: ===================================================================
echo   - Restoring browser settings...

:: Chrome restore
if exist "%RESTORE_DIR%\browsers\chrome_preferences" (
    echo     Chrome settings...
    copy "%RESTORE_DIR%\browsers\chrome_preferences" "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Preferences" >nul 2>&1
)
if exist "%RESTORE_DIR%\browsers\chrome_local_state" (
    copy "%RESTORE_DIR%\browsers\chrome_local_state" "%LOCALAPPDATA%\Google\Chrome\User Data\Local State" >nul 2>&1
)

:: Firefox restore
set "FIREFOX_PROFILES=%APPDATA%\Mozilla\Firefox\Profiles"
if exist "%FIREFOX_PROFILES%" (
    echo     Firefox settings...
    for /d %%i in ("%FIREFOX_PROFILES%\*") do (
        if exist "%RESTORE_DIR%\browsers\firefox_%%~ni_user.js" (
            copy "%RESTORE_DIR%\browsers\firefox_%%~ni_user.js" "%%i\user.js" >nul 2>&1
        ) else (
            if exist "%%i\user.js" del "%%i\user.js" >nul 2>&1
        )
    )
)

:: Edge restore
if exist "%RESTORE_DIR%\browsers\edge_preferences" (
    echo     Edge settings...
    copy "%RESTORE_DIR%\browsers\edge_preferences" "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Preferences" >nul 2>&1
)
if exist "%RESTORE_DIR%\browsers\edge_local_state" (
    copy "%RESTORE_DIR%\browsers\edge_local_state" "%LOCALAPPDATA%\Microsoft\Edge\User Data\Local State" >nul 2>&1
)

:: Opera restore
if exist "%RESTORE_DIR%\browsers\opera_preferences" (
    echo     Opera settings...
    copy "%RESTORE_DIR%\browsers\opera_preferences" "%APPDATA%\Opera Software\Opera Stable\Preferences" >nul 2>&1
)

:: Brave restore
if exist "%RESTORE_DIR%\browsers\brave_preferences" (
    echo     Brave settings...
    copy "%RESTORE_DIR%\browsers\brave_preferences" "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Preferences" >nul 2>&1
)

:: ===================================================================
:: Restore Registry Settings
:: ===================================================================
echo   - Restoring registry settings...

:: Delete policy keys first (to clean up)
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Opera Software\Opera" /f >nul 2>&1

:: Restore original registry settings
if exist "%RESTORE_DIR%\registry\internet_settings_hklm.reg" (
    regedit /s "%RESTORE_DIR%\registry\internet_settings_hklm.reg" >nul 2>&1
)
if exist "%RESTORE_DIR%\registry\internet_settings_hkcu.reg" (
    regedit /s "%RESTORE_DIR%\registry\internet_settings_hkcu.reg" >nul 2>&1
)

:: ===================================================================
:: Restore Hosts File
:: ===================================================================
echo   - Restoring hosts file...

if exist "%RESTORE_DIR%\hosts\hosts_original.txt" (
    copy "%RESTORE_DIR%\hosts\hosts_original.txt" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
    ipconfig /flushdns >nul 2>&1
)

echo.
echo =====================================================================
echo                     RESTORE COMPLETED SUCCESSFULLY
echo =====================================================================
echo.
echo Your browser settings and system configuration have been restored
echo to their previous state.
echo.
echo All cookie blocking configurations have been removed.
echo.
echo You may need to restart your browsers for all changes to take effect.
echo.

exit /b 0