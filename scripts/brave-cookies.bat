@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Brave Browser Cookie Blocking Script
:: Configures Brave Browser to block cookies and tracking
:: ===================================================================

echo   - Configuring Brave Browser...

:: Brave user data directories
set "BRAVE_USER_DATA=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data"
set "BRAVE_SYSTEM_DATA=%PROGRAMFILES%\BraveSoftware\Brave-Browser\Application"
set "BRAVE_SYSTEM_DATA_X86=%PROGRAMFILES(X86)%\BraveSoftware\Brave-Browser\Application"

:: Check if Brave is installed
if not exist "%BRAVE_USER_DATA%" (
    if not exist "%BRAVE_SYSTEM_DATA%" (
        if not exist "%BRAVE_SYSTEM_DATA_X86%" (
            echo     Brave Browser not found - skipping Brave configuration
            exit /b 0
        )
    )
)

:: Kill Brave processes if running
taskkill /f /im brave.exe >nul 2>&1

:: Brave preferences locations
set "BRAVE_DEFAULT_PREFS=%BRAVE_USER_DATA%\Default\Preferences"
set "BRAVE_LOCAL_STATE=%BRAVE_USER_DATA%\Local State"

:: Create Brave user data directory if it doesn't exist
if not exist "%BRAVE_USER_DATA%\Default" (
    mkdir "%BRAVE_USER_DATA%\Default" 2>nul
)

:: Configure Brave preferences for cookie blocking
echo     Updating Brave preferences...

:: Create or update Preferences file
if exist "%BRAVE_DEFAULT_PREFS%" (
    :: Backup existing preferences
    copy "%BRAVE_DEFAULT_PREFS%" "%BRAVE_DEFAULT_PREFS%.backup" >nul 2>&1
)

:: Create Brave preferences JSON with cookie blocking settings
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
echo          "background_sync": 2,
echo          "ads": 2
echo       },
echo       "content_settings": {
echo          "exceptions": {
echo             "cookies": {}
echo          }
echo       },
echo       "cookie_controls_mode": 2,
echo       "brave": {
echo          "shields": {
echo             "ads_blocked": true,
echo             "trackers_blocked": true,
echo             "scripts_blocked": false,
echo             "fingerprinting_blocked": true,
echo             "cookies_blocked": true
echo          }
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
echo    },
echo    "brave_rewards": {
echo       "enabled": false
echo    },
echo    "brave_wallet": {
echo       "enabled": false
echo    }
echo }
) > "%BRAVE_DEFAULT_PREFS%"

:: Configure Brave Local State for additional privacy
if not exist "%BRAVE_LOCAL_STATE%" (
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
    echo    },
    echo    "brave": {
    echo       "stats_reporting_enabled": false,
    echo       "p3a_enabled": false
    echo    }
    echo }
    ) > "%BRAVE_LOCAL_STATE%"
)

:: Registry settings for Brave (system-wide)
echo     Applying Brave registry settings...

:: Brave policy registry keys
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "DefaultCookiesSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BlockThirdPartyCookies" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "CookiesBlockedForUrls" /t REG_MULTI_SZ /d "*" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "SearchSuggestEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "NetworkPredictionOptions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "SpellCheckServiceEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "SafeBrowsingProtectionLevel" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "PasswordManagerEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "AutofillAddressEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "AutofillCreditCardEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "DefaultNotificationsSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "DefaultGeolocationSetting" /t REG_DWORD /d 2 /f >nul 2>&1

:: Brave-specific features
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveRewardsDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveWalletDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveShieldsAdsBlocked" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveShieldsTrackersBlocked" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveShieldsFingerprintingBlocked" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveShieldsCookiesBlocked" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveStatsReportingDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveP3AEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Additional Brave privacy settings
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "IPFSEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "TorDisabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BraveNewsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Configure Brave Shields settings file
set "BRAVE_SHIELDS_CONFIG=%BRAVE_USER_DATA%\Default\brave_shields_config.json"
(
echo {
echo   "default_settings": {
echo     "ads_blocked": true,
echo     "trackers_blocked": true,
echo     "scripts_blocked": false,
echo     "fingerprinting_blocked": true,
echo     "cookies_blocked": true,
echo     "https_upgrade": true
echo   },
echo   "per_site_settings": {}
echo }
) > "%BRAVE_SHIELDS_CONFIG%"

echo     Brave Browser configuration completed successfully.

exit /b 0