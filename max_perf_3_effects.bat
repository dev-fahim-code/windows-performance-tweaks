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
call :center "Administrative privileges confirmed. Customizing appearance for Max Performance..."
echo.

:: --------------------------------------------------------
:: SET VISUAL EFFECTS TO CUSTOM (3)
:: --------------------------------------------------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f

:: --------------------------------------------------------
:: TURN OFF ALL FLUFF ANIMATIONS & TRANSITIONS (MAX PERFORMANCE)
:: --------------------------------------------------------
:: Disables window animations when minimizing/maximizing
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
:: Disables taskbar animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
:: Disables combobox animation, smooth scrolling lists, menu fading, selection fade
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012028010000000 /f
:: Disables folder fade, peek, and drag contents visibility
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f

:: --------------------------------------------------------
:: FORCE ENABLE ONLY THE CHOSEN 3
:: --------------------------------------------------------
:: 1. Smooth edges of screen fonts (FontSmoothing = 2)
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f
:: 2. Show thumbnails instead of icons (IconsOnly = 0)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f
:: 3. Show shadows under windows (DropShadow = 1)
:: Note: This overwrites the mask above to retain window border drop shadow
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9412028010000000 /f

:: --------------------------------------------------------
:: RESTART WINDOWS EXPLORER TO APPLY INSTANTLY
:: --------------------------------------------------------
call :center "Restarting Windows Explorer to apply changes..."
taskkill /f /im explorer.exe
start explorer.exe
echo.
call :center "======================================================="
call :center "SUCCESS: Maximum Performance Profile Applied!"
call :center "Only Font Smoothing, Thumbnails, and Window Shadows are enabled."
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
