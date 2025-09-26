@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Cookie Cleanup Script
:: Removes existing cookies from all supported browsers
:: ===================================================================

echo   - Cleaning existing cookies from browsers...

:: Kill all browser processes before cleanup
echo     Stopping browser processes...
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im opera.exe >nul 2>&1
taskkill /f /im brave.exe >nul 2>&1
taskkill /f /im iexplore.exe >nul 2>&1

:: Wait for processes to fully terminate
timeout /t 3 /nobreak >nul 2>&1

:: ===================================================================
:: Chrome Cookie Cleanup
:: ===================================================================
echo     Cleaning Chrome cookies...

set "CHROME_USER_DATA=%LOCALAPPDATA%\Google\Chrome\User Data"
if exist "%CHROME_USER_DATA%" (
    :: Clean default profile
    if exist "%CHROME_USER_DATA%\Default\Cookies" (
        del /q "%CHROME_USER_DATA%\Default\Cookies" >nul 2>&1
    )
    if exist "%CHROME_USER_DATA%\Default\Cookies-journal" (
        del /q "%CHROME_USER_DATA%\Default\Cookies-journal" >nul 2>&1
    )
    if exist "%CHROME_USER_DATA%\Default\Network\Cookies" (
        del /q "%CHROME_USER_DATA%\Default\Network\Cookies" >nul 2>&1
    )
    if exist "%CHROME_USER_DATA%\Default\Local Storage" (
        rmdir /s /q "%CHROME_USER_DATA%\Default\Local Storage" >nul 2>&1
    )
    if exist "%CHROME_USER_DATA%\Default\Session Storage" (
        rmdir /s /q "%CHROME_USER_DATA%\Default\Session Storage" >nul 2>&1
    )
    if exist "%CHROME_USER_DATA%\Default\IndexedDB" (
        rmdir /s /q "%CHROME_USER_DATA%\Default\IndexedDB" >nul 2>&1
    )
    
    :: Clean other profiles
    for /d %%i in ("%CHROME_USER_DATA%\Profile*") do (
        if exist "%%i\Cookies" del /q "%%i\Cookies" >nul 2>&1
        if exist "%%i\Cookies-journal" del /q "%%i\Cookies-journal" >nul 2>&1
        if exist "%%i\Network\Cookies" del /q "%%i\Network\Cookies" >nul 2>&1
        if exist "%%i\Local Storage" rmdir /s /q "%%i\Local Storage" >nul 2>&1
        if exist "%%i\Session Storage" rmdir /s /q "%%i\Session Storage" >nul 2>&1
        if exist "%%i\IndexedDB" rmdir /s /q "%%i\IndexedDB" >nul 2>&1
    )
)

:: ===================================================================
:: Firefox Cookie Cleanup
:: ===================================================================
echo     Cleaning Firefox cookies...

set "FIREFOX_PROFILES=%APPDATA%\Mozilla\Firefox\Profiles"
if exist "%FIREFOX_PROFILES%" (
    for /d %%i in ("%FIREFOX_PROFILES%\*") do (
        if exist "%%i\cookies.sqlite" del /q "%%i\cookies.sqlite" >nul 2>&1
        if exist "%%i\cookies.sqlite-shm" del /q "%%i\cookies.sqlite-shm" >nul 2>&1
        if exist "%%i\cookies.sqlite-wal" del /q "%%i\cookies.sqlite-wal" >nul 2>&1
        if exist "%%i\webappsstore.sqlite" del /q "%%i\webappsstore.sqlite" >nul 2>&1
        if exist "%%i\webappsstore.sqlite-shm" del /q "%%i\webappsstore.sqlite-shm" >nul 2>&1
        if exist "%%i\webappsstore.sqlite-wal" del /q "%%i\webappsstore.sqlite-wal" >nul 2>&1
        if exist "%%i\sessionstore.jsonlz4" del /q "%%i\sessionstore.jsonlz4" >nul 2>&1
        if exist "%%i\sessionstore-backups" rmdir /s /q "%%i\sessionstore-backups" >nul 2>&1
        if exist "%%i\storage" rmdir /s /q "%%i\storage" >nul 2>&1
        if exist "%%i\datareporting" rmdir /s /q "%%i\datareporting" >nul 2>&1
    )
)

:: ===================================================================
:: Edge Cookie Cleanup
:: ===================================================================
echo     Cleaning Edge cookies...

set "EDGE_USER_DATA=%LOCALAPPDATA%\Microsoft\Edge\User Data"
if exist "%EDGE_USER_DATA%" (
    :: Clean default profile
    if exist "%EDGE_USER_DATA%\Default\Cookies" (
        del /q "%EDGE_USER_DATA%\Default\Cookies" >nul 2>&1
    )
    if exist "%EDGE_USER_DATA%\Default\Cookies-journal" (
        del /q "%EDGE_USER_DATA%\Default\Cookies-journal" >nul 2>&1
    )
    if exist "%EDGE_USER_DATA%\Default\Network\Cookies" (
        del /q "%EDGE_USER_DATA%\Default\Network\Cookies" >nul 2>&1
    )
    if exist "%EDGE_USER_DATA%\Default\Local Storage" (
        rmdir /s /q "%EDGE_USER_DATA%\Default\Local Storage" >nul 2>&1
    )
    if exist "%EDGE_USER_DATA%\Default\Session Storage" (
        rmdir /s /q "%EDGE_USER_DATA%\Default\Session Storage" >nul 2>&1
    )
    if exist "%EDGE_USER_DATA%\Default\IndexedDB" (
        rmdir /s /q "%EDGE_USER_DATA%\Default\IndexedDB" >nul 2>&1
    )
    
    :: Clean other profiles
    for /d %%i in ("%EDGE_USER_DATA%\Profile*") do (
        if exist "%%i\Cookies" del /q "%%i\Cookies" >nul 2>&1
        if exist "%%i\Cookies-journal" del /q "%%i\Cookies-journal" >nul 2>&1
        if exist "%%i\Network\Cookies" del /q "%%i\Network\Cookies" >nul 2>&1
        if exist "%%i\Local Storage" rmdir /s /q "%%i\Local Storage" >nul 2>&1
        if exist "%%i\Session Storage" rmdir /s /q "%%i\Session Storage" >nul 2>&1
        if exist "%%i\IndexedDB" rmdir /s /q "%%i\IndexedDB" >nul 2>&1
    )
)

:: ===================================================================
:: Opera Cookie Cleanup
:: ===================================================================
echo     Cleaning Opera cookies...

set "OPERA_USER_DATA=%APPDATA%\Opera Software\Opera Stable"
if exist "%OPERA_USER_DATA%" (
    if exist "%OPERA_USER_DATA%\Cookies" del /q "%OPERA_USER_DATA%\Cookies" >nul 2>&1
    if exist "%OPERA_USER_DATA%\Cookies-journal" del /q "%OPERA_USER_DATA%\Cookies-journal" >nul 2>&1
    if exist "%OPERA_USER_DATA%\Local Storage" rmdir /s /q "%OPERA_USER_DATA%\Local Storage" >nul 2>&1
    if exist "%OPERA_USER_DATA%\Session Storage" rmdir /s /q "%OPERA_USER_DATA%\Session Storage" >nul 2>&1
    if exist "%OPERA_USER_DATA%\IndexedDB" rmdir /s /q "%OPERA_USER_DATA%\IndexedDB" >nul 2>&1
    if exist "%OPERA_USER_DATA%\databases" rmdir /s /q "%OPERA_USER_DATA%\databases" >nul 2>&1
)

:: ===================================================================
:: Brave Cookie Cleanup
:: ===================================================================
echo     Cleaning Brave cookies...

set "BRAVE_USER_DATA=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data"
if exist "%BRAVE_USER_DATA%" (
    :: Clean default profile
    if exist "%BRAVE_USER_DATA%\Default\Cookies" (
        del /q "%BRAVE_USER_DATA%\Default\Cookies" >nul 2>&1
    )
    if exist "%BRAVE_USER_DATA%\Default\Cookies-journal" (
        del /q "%BRAVE_USER_DATA%\Default\Cookies-journal" >nul 2>&1
    )
    if exist "%BRAVE_USER_DATA%\Default\Network\Cookies" (
        del /q "%BRAVE_USER_DATA%\Default\Network\Cookies" >nul 2>&1
    )
    if exist "%BRAVE_USER_DATA%\Default\Local Storage" (
        rmdir /s /q "%BRAVE_USER_DATA%\Default\Local Storage" >nul 2>&1
    )
    if exist "%BRAVE_USER_DATA%\Default\Session Storage" (
        rmdir /s /q "%BRAVE_USER_DATA%\Default\Session Storage" >nul 2>&1
    )
    if exist "%BRAVE_USER_DATA%\Default\IndexedDB" (
        rmdir /s /q "%BRAVE_USER_DATA%\Default\IndexedDB" >nul 2>&1
    )
    
    :: Clean other profiles
    for /d %%i in ("%BRAVE_USER_DATA%\Profile*") do (
        if exist "%%i\Cookies" del /q "%%i\Cookies" >nul 2>&1
        if exist "%%i\Cookies-journal" del /q "%%i\Cookies-journal" >nul 2>&1
        if exist "%%i\Network\Cookies" del /q "%%i\Network\Cookies" >nul 2>&1
        if exist "%%i\Local Storage" rmdir /s /q "%%i\Local Storage" >nul 2>&1
        if exist "%%i\Session Storage" rmdir /s /q "%%i\Session Storage" >nul 2>&1
        if exist "%%i\IndexedDB" rmdir /s /q "%%i\IndexedDB" >nul 2>&1
    )
)

:: ===================================================================
:: Internet Explorer Cookie Cleanup
:: ===================================================================
echo     Cleaning Internet Explorer cookies...

:: Clean IE cookies
if exist "%APPDATA%\Microsoft\Windows\Cookies" (
    del /q "%APPDATA%\Microsoft\Windows\Cookies\*" >nul 2>&1
)
if exist "%APPDATA%\Microsoft\Windows\Cookies\Low" (
    del /q "%APPDATA%\Microsoft\Windows\Cookies\Low\*" >nul 2>&1
)

:: Clean IE temporary files
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2 >nul 2>&1

:: ===================================================================
:: Windows System Cookie Cleanup
:: ===================================================================
echo     Cleaning Windows system cookies...

:: Clean Windows temporary internet files
if exist "%LOCALAPPDATA%\Microsoft\Windows\INetCache" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\INetCache" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\Windows\Temporary Internet Files" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\Temporary Internet Files" >nul 2>&1
)

:: Clean Windows WebCache
if exist "%LOCALAPPDATA%\Microsoft\Windows\WebCache" (
    :: Stop WebCache service
    net stop "WebCache" >nul 2>&1
    timeout /t 2 /nobreak >nul 2>&1
    
    :: Clean WebCache database
    if exist "%LOCALAPPDATA%\Microsoft\Windows\WebCache\WebCacheV01.dat" (
        del /q "%LOCALAPPDATA%\Microsoft\Windows\WebCache\WebCacheV01.dat" >nul 2>&1
    )
    
    :: Restart WebCache service
    net start "WebCache" >nul 2>&1
)

:: Clean Flash cookies (if Flash is installed)
if exist "%APPDATA%\Macromedia\Flash Player" (
    rmdir /s /q "%APPDATA%\Macromedia\Flash Player" >nul 2>&1
)

:: ===================================================================
:: Registry Cleanup for Stored Cookies
:: ===================================================================
echo     Cleaning registry cookie entries...

:: Clean IE cookie registry entries
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\P3P\History" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Content" /f >nul 2>&1

:: Clean tracking registry entries
reg delete "HKCU\SOFTWARE\Microsoft\Internet Explorer\DOMStorage" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\DOMStorage" /f >nul 2>&1

echo     Cookie cleanup completed successfully.

exit /b 0