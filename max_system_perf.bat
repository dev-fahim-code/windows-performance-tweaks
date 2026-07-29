@echo off
color 0C
setlocal enabledelayedexpansion

:: --------------------------------------------------------
:: SELF-ELEVATION: relaunch with a UAC prompt if not admin
:: --------------------------------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator permission...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

call :center "======================================"
call :center "        Dev-Fahim_Code"
call :center "github.com/dev-fahim-code"
call :center "======================================"
echo.
call :center "Administrative privileges confirmed. Optimizing system performance..."
echo.

:: --------------------------------------------------------
:: DISABLE WINDOWS TELEMETRY & BACKGROUND TRACKING
:: --------------------------------------------------------
:: Stops Windows from using CPU/Network to upload diagnostic data
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
sc config DiagTrack start= disabled
net stop DiagTrack

:: --------------------------------------------------------
:: OPTIMIZE CPU TASK SCHEDULING (Gives games/active apps priority)
:: --------------------------------------------------------
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f

:: --------------------------------------------------------
:: DISABLE HIBERNATION (Frees up gigabytes of storage & stops constant disk writes)
:: --------------------------------------------------------
powercfg -h off

:: --------------------------------------------------------
:: REDUCE MOUSE/KEYBOARD RESPONSE DELAY
:: --------------------------------------------------------
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 8 /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d 0 /f

echo.
call :center "======================================================="
call :center "PERFORMANCE TWEAKS APPLIED!"
call :center "Please restart your PC for changes to take effect."
call :center "======================================================="
echo.
call :center "Script by Dev-Fahim_Code - github.com/dev-fahim-code"
pause
exit /b

:: --------------------------------------------------------
:: Helper: center a line of text based on console width
:: --------------------------------------------------------
:center
setlocal
set "str=%~1"
set "cols=80"
for /f "tokens=2" %%a in ('mode con ^| findstr /R "Columns"') do set "cols=%%a"
set "len=0"
:strlen_loop
if defined str (
    set "str=!str:~1!"
    set /a len+=1
    goto strlen_loop
)
set "pad=0"
set /a pad=(cols-len)/2
if %pad% lss 0 set "pad=0"
set "spaces="
for /l %%i in (1,1,%pad%) do set "spaces=!spaces! "
endlocal & echo(%spaces%%~1
goto :eof
