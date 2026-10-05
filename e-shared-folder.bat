@echo off
setlocal enabledelayedexpansion
title Network Drive Setup Tool

:: ==========================================
:: CONFIGURATION: CHANGE THESE TO YOUR VALUES
:: ==========================================
set "IP_A=192.168.2.27"


set "SHARE_E=\\%IP_B%\e"
:: ==========================================

echo ===================================================
echo     Step 1: Clearing Old Cached Credentials
echo ===================================================
echo This prevents Windows from trying to use the old admin password...

:: Disconnect existing drive letters to prevent conflicts
net use Q: /delete /y >nul 2>&1
net use Z: /delete /y >nul 2>&1
net use E: /delete /y >nul 2>&1

:: Wipe cached Windows Vault/Credential Manager tokens for these IPs
cmdkey /delete:target=Domain:target=%IP_A% >nul 2>&1
cmdkey /delete:target=Domain:target=%IP_B% >nul 2>&1
cmdkey /delete:%IP_A% >nul 2>&1
cmdkey /delete:%IP_B% >nul 2>&1

echo.
echo ===================================================
echo     Step 2: Select Your Needed Network Drives
echo ===================================================
echo Please answer (Y)es or (N)o for each drive.
echo.


:ASK_E
set /p "want_e=Do you need access to the E: drive? (Y/N): "
if /i "%want_e%"=="Y" (set "map_e=1") else if /i "%want_e%"=="N" (set "map_e=0") else (goto ASK_E)

echo.
echo ===================================================
echo     Step 3: Mapping Selected Drives
echo ===================================================

if "%map_q%"=="1" (
    echo Mapping Q: drive...
    net use Q: "%SHARE_Q%" /persistent:yes
)
if "%map_z%"=="1" (
    echo Mapping Z: drive...
    net use Z: "%SHARE_Z%" /persistent:yes
)
if "%map_e%"=="1" (
    echo Mapping E: drive...
    net use E: "%SHARE_E%" /persistent:yes
)

echo.
echo ===================================================
echo     Process complete! Press any key to exit.
echo ===================================================
pause
exit
