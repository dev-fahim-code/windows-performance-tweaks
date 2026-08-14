@echo off
title Appearance for Best Performance
setlocal EnableExtensions

:: ---- Self-elevate to Administrator if not already running as one ----
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator rights are needed - requesting elevation...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cls
echo.
powershell -NoProfile -Command "$w=[Console]::WindowWidth; $t='Appearance for Best Performance'; Write-Host ((' ' * [Math]::Max(0,[int](($w-$t.Length)/2))) + $t) -ForegroundColor White"
powershell -NoProfile -Command "$w=[Console]::WindowWidth; $t='https://github.com/dev-fahim-code'; Write-Host ((' ' * [Math]::Max(0,[int](($w-$t.Length)/2))) + $t) -ForegroundColor Red"
echo.
echo This will set Visual Effects to "Adjust for best performance" while
echo keeping "Smooth edges of screen fonts" and "Show thumbnails instead
echo of icons" turned ON - the same result as doing it by hand.
echo.
set /p CONFIRM=Apply these settings now? (Y/N): 
if /I not "%CONFIRM%"=="Y" (
    echo.
    echo Cancelled - no changes were made.
    echo.
    pause
    endlocal
    exit /b
)

echo.
echo Applying settings...

:: Best-performance visual-effects bitmask, with font smoothing bit kept on
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f >nul

:: Font smoothing / ClearType - stays ON
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f >nul

:: Turn off "show window contents while dragging" and minimize/maximize animation
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul

:: Turn off taskbar animations, translucent selection rectangle, icon-label shadows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul

:: "Show thumbnails instead of icons" - stays ON (0 = thumbnails, 1 = icons only)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul

:: Mark the Performance Options dialog as "Custom" since two boxes stay checked
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul

:: Turn off Aero Peek
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul

echo Done.
echo.
echo A restart guarantees every setting (including window animation) is
echo fully applied. Windows will ask you to save anything still open.
echo.
set /p REBOOT=Restart now? (Y/N): 
if /I "%REBOOT%"=="Y" (
    echo.
    echo Restarting now...
    shutdown /r /t 0
) else (
    echo.
    echo OK, no restart. Sign out and back in later to fully apply everything.
)

echo.
pause
endlocal
