@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: Hosts File Cookie and Tracking Domain Blocking Script
:: Blocks known tracking and advertising domains via hosts file
:: ===================================================================

echo   - Updating hosts file to block tracking domains...

set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
set "BACKUP_DIR=%~dp0..\backups\hosts"
set "TEMP_HOSTS=%TEMP%\hosts_temp.txt"

:: Create backup directory
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" 2>nul

:: Create backup of original hosts file
echo     Creating backup of hosts file...
set "BACKUP_FILE=%BACKUP_DIR%\hosts_backup_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.txt"
copy "%HOSTS_FILE%" "%BACKUP_FILE%" >nul 2>&1

:: Check if our marker already exists
findstr /C:"# Cookie Blocking Solution" "%HOSTS_FILE%" >nul 2>&1
if %errorlevel% equ 0 (
    echo     Cookie blocking entries already present in hosts file.
    echo     Skipping hosts file modification.
    exit /b 0
)

:: Create temporary file with tracking domains to block
echo     Adding tracking domains to hosts file...

(
echo.
echo # Cookie Blocking Solution - Tracking Domain Blocking
echo # Added on %date% %time%
echo # 
echo # Major advertising and tracking networks
echo 127.0.0.1 doubleclick.net
echo 127.0.0.1 www.doubleclick.net
echo 127.0.0.1 ad.doubleclick.net
echo 127.0.0.1 stats.doubleclick.net
echo 127.0.0.1 cm.g.doubleclick.net
echo 127.0.0.1 googleadservices.com
echo 127.0.0.1 www.googleadservices.com
echo 127.0.0.1 googlesyndication.com
echo 127.0.0.1 www.googlesyndication.com
echo 127.0.0.1 googletagservices.com
echo 127.0.0.1 www.googletagservices.com
echo 127.0.0.1 google-analytics.com
echo 127.0.0.1 www.google-analytics.com
echo 127.0.0.1 ssl.google-analytics.com
echo 127.0.0.1 googletagmanager.com
echo 127.0.0.1 www.googletagmanager.com
echo.
echo # Facebook tracking
echo 127.0.0.1 connect.facebook.net
echo 127.0.0.1 www.connect.facebook.net
echo 127.0.0.1 facebook.com
echo 127.0.0.1 www.facebook.com
echo 127.0.0.1 m.facebook.com
echo 127.0.0.1 graph.facebook.com
echo 127.0.0.1 pixel.facebook.com
echo.
echo # Twitter tracking
echo 127.0.0.1 analytics.twitter.com
echo 127.0.0.1 platform.twitter.com
echo 127.0.0.1 syndication.twitter.com
echo 127.0.0.1 cdn.syndication.twimg.com
echo.
echo # Amazon tracking
echo 127.0.0.1 amazon-adsystem.com
echo 127.0.0.1 www.amazon-adsystem.com
echo 127.0.0.1 s.amazon-adsystem.com
echo 127.0.0.1 fls-na.amazon.com
echo 127.0.0.1 fls-eu.amazon.com
echo.
echo # Microsoft tracking
echo 127.0.0.1 bat.bing.com
echo 127.0.0.1 www.bat.bing.com
echo 127.0.0.1 flex.msn.com
echo 127.0.0.1 rad.msn.com
echo 127.0.0.1 ads1.msn.com
echo 127.0.0.1 a.ads1.msn.com
echo 127.0.0.1 a.ads2.msn.com
echo.
echo # Adobe tracking
echo 127.0.0.1 omtrdc.net
echo 127.0.0.1 www.omtrdc.net
echo 127.0.0.1 2o7.net
echo 127.0.0.1 www.2o7.net
echo 127.0.0.1 omniture.com
echo 127.0.0.1 www.omniture.com
echo.
echo # Yahoo tracking
echo 127.0.0.1 ads.yahoo.com
echo 127.0.0.1 www.ads.yahoo.com
echo 127.0.0.1 analytics.yahoo.com
echo 127.0.0.1 comscore.com
echo 127.0.0.1 www.comscore.com
echo 127.0.0.1 scorecardresearch.com
echo 127.0.0.1 www.scorecardresearch.com
echo.
echo # AppNexus
echo 127.0.0.1 appnexus.com
echo 127.0.0.1 www.appnexus.com
echo 127.0.0.1 ib.adnxs.com
echo 127.0.0.1 seg.adnxs.com
echo.
echo # Criteo
echo 127.0.0.1 criteo.com
echo 127.0.0.1 www.criteo.com
echo 127.0.0.1 cas.criteo.com
echo 127.0.0.1 gum.criteo.com
echo.
echo # Outbrain
echo 127.0.0.1 outbrain.com
echo 127.0.0.1 www.outbrain.com
echo 127.0.0.1 widgets.outbrain.com
echo 127.0.0.1 amplify.outbrain.com
echo.
echo # Taboola
echo 127.0.0.1 taboola.com
echo 127.0.0.1 www.taboola.com
echo 127.0.0.1 cdn.taboola.com
echo 127.0.0.1 trc.taboola.com
echo.
echo # AddThis
echo 127.0.0.1 addthis.com
echo 127.0.0.1 www.addthis.com
echo 127.0.0.1 s7.addthis.com
echo 127.0.0.1 cache.addthis.com
echo.
echo # ShareThis
echo 127.0.0.1 sharethis.com
echo 127.0.0.1 www.sharethis.com
echo 127.0.0.1 buttons.sharethis.com
echo 127.0.0.1 seg.sharethis.com
echo.
echo # Quantcast
echo 127.0.0.1 quantcast.com
echo 127.0.0.1 www.quantcast.com
echo 127.0.0.1 pixel.quantserve.com
echo 127.0.0.1 secure.quantserve.com
echo.
echo # BlueKai
echo 127.0.0.1 bluekai.com
echo 127.0.0.1 www.bluekai.com
echo 127.0.0.1 tags.bluekai.com
echo 127.0.0.1 stags.bluekai.com
echo.
echo # Turn
echo 127.0.0.1 turn.com
echo 127.0.0.1 www.turn.com
echo 127.0.0.1 ads.turn.com
echo.
echo # MediaMath
echo 127.0.0.1 mediamath.com
echo 127.0.0.1 www.mediamath.com
echo 127.0.0.1 pixel.mathtag.com
echo 127.0.0.1 t.co
echo.
echo # Rubicon Project
echo 127.0.0.1 rubiconproject.com
echo 127.0.0.1 www.rubiconproject.com
echo 127.0.0.1 tap.rubiconproject.com
echo 127.0.0.1 pixel.rubiconproject.com
echo.
echo # Index Exchange
echo 127.0.0.1 casalemedia.com
echo 127.0.0.1 www.casalemedia.com
echo 127.0.0.1 htlb.casalemedia.com
echo.
echo # PubMatic
echo 127.0.0.1 pubmatic.com
echo 127.0.0.1 www.pubmatic.com
echo 127.0.0.1 ads.pubmatic.com
echo 127.0.0.1 image2.pubmatic.com
echo.
echo # OpenX
echo 127.0.0.1 openx.net
echo 127.0.0.1 www.openx.net
echo 127.0.0.1 ox-d.openx.net
echo 127.0.0.1 d.openx.org
echo.
echo # Sovrn
echo 127.0.0.1 sovrn.com
echo 127.0.0.1 www.sovrn.com
echo 127.0.0.1 ap.lijit.com
echo.
echo # TripleLift
echo 127.0.0.1 triplelift.com
echo 127.0.0.1 www.triplelift.com
echo 127.0.0.1 ib.3lift.com
echo.
echo # LiveRamp
echo 127.0.0.1 liveramp.com
echo 127.0.0.1 www.liveramp.com
echo 127.0.0.1 rlcdn.com
echo 127.0.0.1 www.rlcdn.com
echo.
echo # The Trade Desk
echo 127.0.0.1 thetradedesk.com
echo 127.0.0.1 www.thetradedesk.com
echo 127.0.0.1 insight.adsrvr.org
echo.
echo # Amazon DSP
echo 127.0.0.1 ads.betrad.com
echo 127.0.0.1 c.betrad.com
echo.
echo # Common cookie consent and tracking scripts
echo 127.0.0.1 cookielaw.org
echo 127.0.0.1 www.cookielaw.org
echo 127.0.0.1 cdn.cookielaw.org
echo 127.0.0.1 optanon.blob.core.windows.net
echo 127.0.0.1 consent.trustarc.com
echo 127.0.0.1 choices.trustarc.com
echo 127.0.0.1 consent.cookiebot.com
echo 127.0.0.1 consentcdn.cookiebot.com
echo.
echo # Heat mapping and session recording
echo 127.0.0.1 hotjar.com
echo 127.0.0.1 www.hotjar.com
echo 127.0.0.1 static.hotjar.com
echo 127.0.0.1 script.hotjar.com
echo 127.0.0.1 insights.hotjar.com
echo 127.0.0.1 crazyegg.com
echo 127.0.0.1 www.crazyegg.com
echo 127.0.0.1 script.crazyegg.com
echo 127.0.0.1 fullstory.com
echo 127.0.0.1 www.fullstory.com
echo 127.0.0.1 rs.fullstory.com
echo.
echo # Customer data platforms
echo 127.0.0.1 segment.com
echo 127.0.0.1 www.segment.com
echo 127.0.0.1 cdn.segment.com
echo 127.0.0.1 api.segment.io
echo 127.0.0.1 rudderstack.com
echo 127.0.0.1 www.rudderstack.com
echo.
echo # Email tracking
echo 127.0.0.1 mailchimp.com
echo 127.0.0.1 list-manage.com
echo 127.0.0.1 constantcontact.com
echo 127.0.0.1 sendgrid.net
echo 127.0.0.1 mandrillapp.com
echo.
echo # End of Cookie Blocking Solution entries
) >> "%HOSTS_FILE%"

:: Flush DNS cache to apply changes
echo     Flushing DNS cache...
ipconfig /flushdns >nul 2>&1

echo     Hosts file updated successfully. %date% %time%
echo     Backup saved to: %BACKUP_FILE%

exit /b 0