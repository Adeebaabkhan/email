@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Opera Cookie Blocking Script
:: Configures Opera Browser to block cookies and tracking
:: ===================================================================

echo   - Configuring Opera Browser...

:: Opera user data directories
set "OPERA_USER_DATA=%APPDATA%\Opera Software\Opera Stable"
set "OPERA_SYSTEM_DATA=%PROGRAMFILES%\Opera"
set "OPERA_SYSTEM_DATA_X86=%PROGRAMFILES(X86)%\Opera"

:: Check if Opera is installed
if not exist "%OPERA_USER_DATA%" (
    if not exist "%OPERA_SYSTEM_DATA%" (
        if not exist "%OPERA_SYSTEM_DATA_X86%" (
            echo     Opera not found - skipping Opera configuration
            exit /b 0
        )
    )
)

:: Kill Opera processes if running
taskkill /f /im opera.exe >nul 2>&1

:: Opera preferences locations
set "OPERA_PREFS=%OPERA_USER_DATA%\Preferences"
set "OPERA_LOCAL_STATE=%OPERA_USER_DATA%\Local State"

:: Create Opera user data directory if it doesn't exist
if not exist "%OPERA_USER_DATA%" (
    mkdir "%OPERA_USER_DATA%" 2>nul
)

:: Configure Opera preferences for cookie blocking
echo     Updating Opera preferences...

:: Create or update Preferences file
if exist "%OPERA_PREFS%" (
    :: Backup existing preferences
    copy "%OPERA_PREFS%" "%OPERA_PREFS%.backup" >nul 2>&1
)

:: Create Opera preferences JSON with cookie blocking settings
(
echo {
echo    "profile": {
echo       "default_content_setting_values": {
echo          "cookies": 2,
echo          "third_party_cookies": 2,
echo          "javascript": 1,
echo          "images": 1,
echo          "plugins": 2,
echo          "popups": 2,
echo          "geolocation": 2,
echo          "notifications": 2,
echo          "media_stream": 2,
echo          "automatic_downloads": 2,
echo          "midi_sysex": 2,
echo          "background_sync": 2
echo       },
echo       "content_settings": {
echo          "exceptions": {
echo             "cookies": {}
echo          }
echo       },
echo       "cookie_controls_mode": 2
echo    },
echo    "privacy": {
echo       "do_not_track": true,
echo       "safe_browsing": {
echo          "enabled": true,
echo          "enhanced_protection": false
echo       }
echo    },
echo    "sync": {
echo       "suppress_start": true
echo    },
echo    "search": {
echo       "suggest_enabled": false
echo    },
echo    "alternate_error_pages": {
echo       "enabled": false
echo    },
echo    "dns_prefetching": {
echo       "enabled": false
echo    },
echo    "safebrowsing": {
echo       "reporting_enabled": false
echo    },
echo    "opera": {
echo       "news": {
echo          "enabled": false
echo       },
echo       "sidebar": {
echo          "enabled": false
echo       },
echo       "workspaces": {
echo          "enabled": false
echo       }
echo    }
echo }
) > "%OPERA_PREFS%"

:: Configure Opera Local State for additional privacy
if not exist "%OPERA_LOCAL_STATE%" (
    (
    echo {
    echo    "background_mode": {
    echo       "enabled": false
    echo    },
    echo    "metrics": {
    echo       "reporting_enabled": false
    echo    },
    echo    "optimization_guide": {
    echo       "fetching_enabled": false
    echo    }
    echo }
    ) > "%OPERA_LOCAL_STATE%"
)

:: Registry settings for Opera (system-wide)
echo     Applying Opera registry settings...

:: Opera policy registry keys (similar to Chrome but for Opera)
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "DefaultCookiesSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "BlockThirdPartyCookies" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "CookiesBlockedForUrls" /t REG_MULTI_SZ /d "*" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "SearchSuggestEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "NetworkPredictionOptions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "SpellCheckServiceEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "SafeBrowsingProtectionLevel" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "PasswordManagerEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "AutofillAddressEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "AutofillCreditCardEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "DefaultNotificationsSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "DefaultGeolocationSetting" /t REG_DWORD /d 2 /f >nul 2>&1

:: Opera-specific features
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "OperaNewsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "SidebarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "WorkspacesEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera" /v "OperaTouchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Additional Opera privacy settings
:: Create or modify Opera's secure preferences file
set "OPERA_SECURE_PREFS=%OPERA_USER_DATA%\Secure Preferences"
if exist "%OPERA_SECURE_PREFS%" (
    copy "%OPERA_SECURE_PREFS%" "%OPERA_SECURE_PREFS%.backup" >nul 2>&1
)

:: Create additional Opera configuration files
set "OPERA_CONFIG_DIR=%OPERA_USER_DATA%"
if not exist "%OPERA_CONFIG_DIR%" mkdir "%OPERA_CONFIG_DIR%" 2>nul

:: Opera custom CSS for blocking elements (optional)
set "OPERA_USER_CSS=%OPERA_CONFIG_DIR%\user.css"
(
echo /* Opera Cookie and Tracking Blocker Custom CSS */
echo /* Hide cookie consent banners */
echo div[class*="cookie"], div[id*="cookie"], 
echo div[class*="consent"], div[id*="consent"],
echo div[class*="gdpr"], div[id*="gdpr"] {
echo     display: none !important;
echo }
echo /* Hide tracking pixels */
echo img[width="1"], img[height="1"],
echo img[src*="tracking"], img[src*="pixel"] {
echo     display: none !important;
echo }
) > "%OPERA_USER_CSS%"

echo     Opera configuration completed successfully.

exit /b 0