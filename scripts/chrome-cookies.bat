@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Chrome Cookie Blocking Script
:: Configures Google Chrome to block cookies and tracking
:: ===================================================================

echo   - Configuring Google Chrome...

:: Chrome user data directories
set "CHROME_USER_DATA=%LOCALAPPDATA%\Google\Chrome\User Data"
set "CHROME_SYSTEM_DATA=%PROGRAMFILES%\Google\Chrome\Application"
set "CHROME_SYSTEM_DATA_X86=%PROGRAMFILES(X86)%\Google\Chrome\Application"

:: Check if Chrome is installed
if not exist "%CHROME_USER_DATA%" (
    if not exist "%CHROME_SYSTEM_DATA%" (
        if not exist "%CHROME_SYSTEM_DATA_X86%" (
            echo     Chrome not found - skipping Chrome configuration
            exit /b 0
        )
    )
)

:: Kill Chrome processes if running
taskkill /f /im chrome.exe >nul 2>&1

:: Chrome preferences locations
set "CHROME_DEFAULT_PREFS=%CHROME_USER_DATA%\Default\Preferences"
set "CHROME_LOCAL_STATE=%CHROME_USER_DATA%\Local State"

:: Create Chrome user data directory if it doesn't exist
if not exist "%CHROME_USER_DATA%\Default" (
    mkdir "%CHROME_USER_DATA%\Default" 2>nul
)

:: Configure Chrome preferences for cookie blocking
echo     Updating Chrome preferences...

:: Create or update Preferences file
if exist "%CHROME_DEFAULT_PREFS%" (
    :: Backup existing preferences
    copy "%CHROME_DEFAULT_PREFS%" "%CHROME_DEFAULT_PREFS%.backup" >nul 2>&1
)

:: Create Chrome preferences JSON with cookie blocking settings
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
echo          "automatic_downloads": 2
echo       },
echo       "content_settings": {
echo          "exceptions": {
echo             "cookies": {}
echo          }
echo       },
echo       "cookie_controls_mode": 2,
echo       "privacy_sandbox": {
echo          "apis_enabled": false,
echo          "topics_enabled": false,
echo          "fledge_enabled": false,
echo          "ad_measurement_enabled": false
echo       }
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
echo    }
echo }
) > "%CHROME_DEFAULT_PREFS%"

:: Configure Chrome Local State for additional privacy
if not exist "%CHROME_LOCAL_STATE%" (
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
    ) > "%CHROME_LOCAL_STATE%"
)

:: Registry settings for Chrome (system-wide)
echo     Applying Chrome registry settings...

:: Chrome policy registry keys
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultCookiesSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "BlockThirdPartyCookies" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "CookiesBlockedForUrls" /t REG_MULTI_SZ /d "*" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "EnableOnlineRevocationChecks" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SearchSuggestEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "NetworkPredictionOptions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "UrlKeyedAnonymizedDataCollectionEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SpellCheckServiceEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SafeBrowsingProtectionLevel" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PasswordManagerEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AutofillAddressEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AutofillCreditCardEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultNotificationsSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultGeolocationSetting" /t REG_DWORD /d 2 /f >nul 2>&1

:: Privacy Sandbox controls
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PrivacySandboxAdMeasurementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PrivacySandboxAdTopicsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PrivacySandboxSiteEnabledAdsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo     Chrome configuration completed successfully.

exit /b 0