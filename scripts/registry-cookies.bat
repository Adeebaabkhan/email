@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Windows Registry Cookie Blocking Script
:: System-wide privacy and cookie blocking registry modifications
:: ===================================================================

echo   - Applying Windows registry modifications...

:: Create registry backup
echo     Creating registry backup...
set "BACKUP_DIR=%~dp0..\backups\registry"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" 2>nul

:: Backup key registry sections
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "%BACKUP_DIR%\internet_settings_hklm.reg" /y >nul 2>&1
reg export "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "%BACKUP_DIR%\internet_settings_hkcu.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Internet Explorer" "%BACKUP_DIR%\internet_explorer_hklm.reg" /y >nul 2>&1
reg export "HKCU\SOFTWARE\Microsoft\Internet Explorer" "%BACKUP_DIR%\internet_explorer_hkcu.reg" /y >nul 2>&1

:: ===================================================================
:: Internet Explorer / Windows Web Browser Cookie Settings
:: ===================================================================
echo     Configuring Internet Explorer cookie settings...

:: Set cookie blocking for Internet zones
:: Zone 0 = Local Computer, Zone 1 = Intranet, Zone 2 = Trusted, Zone 3 = Internet, Zone 4 = Restricted

:: Internet Zone (Zone 3) - Block all cookies
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1A10" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1A10" /t REG_DWORD /d 3 /f >nul 2>&1

:: Restricted Zone (Zone 4) - Block all cookies
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1A10" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1A10" /t REG_DWORD /d 3 /f >nul 2>&1

:: Trusted Zone (Zone 2) - Block third-party cookies
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1A10" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1A10" /t REG_DWORD /d 1 /f >nul 2>&1

:: Intranet Zone (Zone 1) - Block third-party cookies
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1A10" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1A10" /t REG_DWORD /d 1 /f >nul 2>&1

:: ===================================================================
:: Privacy Settings
:: ===================================================================
echo     Configuring privacy settings...

:: Disable automatic crash reporting
reg add "HKLM\SOFTWARE\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Windows Error Reporting
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Customer Experience Improvement Program
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1

:: ===================================================================
:: Windows Telemetry and Data Collection
:: ===================================================================
echo     Disabling Windows telemetry and data collection...

:: Disable telemetry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable advertising ID
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable location tracking
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable app access to location
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: ===================================================================
:: Microsoft Edge Legacy Settings (if present)
:: ===================================================================
echo     Configuring Edge Legacy settings...

reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowTabPreloading" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "DoNotTrack" /t REG_DWORD /d 1 /f >nul 2>&1

:: ===================================================================
:: Windows Update Delivery Optimization
:: ===================================================================
echo     Disabling Windows Update P2P sharing...

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1

:: ===================================================================
:: Windows 10/11 Privacy Settings
:: ===================================================================
echo     Configuring Windows 10/11 privacy settings...

:: Disable app diagnostics
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable app access to account info
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable app access to contacts
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable app access to calendar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable app access to call history
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable app access to email
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: ===================================================================
:: Cortana Privacy Settings
:: ===================================================================
echo     Disabling Cortana data collection...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1

:: ===================================================================
:: Microsoft Store and Apps Privacy
:: ===================================================================
echo     Configuring Microsoft Store privacy settings...

:: Disable automatic app updates that might include tracking
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f >nul 2>&1

:: ===================================================================
:: OneDrive Privacy Settings
:: ===================================================================
echo     Configuring OneDrive privacy settings...

:: Disable OneDrive sync
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f >nul 2>&1

:: ===================================================================
:: Network and Connection Privacy
:: ===================================================================
echo     Configuring network privacy settings...

:: Disable network connectivity status indicator
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable network location wizard
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /ve /t REG_SZ /d "" /f >nul 2>&1

echo     Registry modifications completed successfully.

exit /b 0