@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Microsoft Edge Cookie Blocking Script
:: Configures Microsoft Edge to block cookies and tracking
:: ===================================================================

echo   - Configuring Microsoft Edge...

:: Edge user data directories
set "EDGE_USER_DATA=%LOCALAPPDATA%\Microsoft\Edge\User Data"
set "EDGE_SYSTEM_DATA=%PROGRAMFILES(X86)%\Microsoft\Edge\Application"
set "EDGE_SYSTEM_DATA_64=%PROGRAMFILES%\Microsoft\Edge\Application"

:: Check if Edge is installed
if not exist "%EDGE_USER_DATA%" (
    if not exist "%EDGE_SYSTEM_DATA%" (
        if not exist "%EDGE_SYSTEM_DATA_64%" (
            echo     Microsoft Edge not found - skipping Edge configuration
            exit /b 0
        )
    )
)

:: Kill Edge processes if running
taskkill /f /im msedge.exe >nul 2>&1

:: Edge preferences locations
set "EDGE_DEFAULT_PREFS=%EDGE_USER_DATA%\Default\Preferences"
set "EDGE_LOCAL_STATE=%EDGE_USER_DATA%\Local State"

:: Create Edge user data directory if it doesn't exist
if not exist "%EDGE_USER_DATA%\Default" (
    mkdir "%EDGE_USER_DATA%\Default" 2>nul
)

:: Configure Edge preferences for cookie blocking
echo     Updating Edge preferences...

:: Create or update Preferences file
if exist "%EDGE_DEFAULT_PREFS%" (
    :: Backup existing preferences
    copy "%EDGE_DEFAULT_PREFS%" "%EDGE_DEFAULT_PREFS%.backup" >nul 2>&1
)

:: Create Edge preferences JSON with cookie blocking settings
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
echo    },
echo    "edge": {
echo       "shopping_assistant": {
echo          "enabled": false
echo       },
echo       "personalizeads": {
echo          "enabled": false
echo       }
echo    }
echo }
) > "%EDGE_DEFAULT_PREFS%"

:: Configure Edge Local State for additional privacy
if not exist "%EDGE_LOCAL_STATE%" (
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
    echo    "edge": {
    echo       "wallet": {
    echo          "enabled": false
    echo       }
    echo    }
    echo }
    ) > "%EDGE_LOCAL_STATE%"
)

:: Registry settings for Edge (system-wide)
echo     Applying Edge registry settings...

:: Edge policy registry keys
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "DefaultCookiesSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BlockThirdPartyCookies" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "CookiesBlockedForUrls" /t REG_MULTI_SZ /d "*" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "TrackingPrevention" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "NetworkPredictionOptions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SpellcheckEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SafeBrowsingProtectionLevel" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PasswordManagerEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "DefaultNotificationsSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "DefaultGeolocationSetting" /t REG_DWORD /d 2 /f >nul 2>&1

:: Edge-specific privacy features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeCollectionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeFollowEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeWalletCheckoutEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ShowRecommendationsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BingAdsSuppression" /t REG_DWORD /d 1 /f >nul 2>&1

:: Privacy Sandbox controls
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PrivacySandboxAdMeasurementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PrivacySandboxAdTopicsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PrivacySandboxSiteEnabledAdsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Edge WebView2 telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\WebView2" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WebView2" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo     Edge configuration completed successfully.

exit /b 0