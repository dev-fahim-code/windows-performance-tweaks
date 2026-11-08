@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Appearance for Best Performance v2.1

:: ==========================================
:: APPEARANCE FOR BEST PERFORMANCE
:: Version 2.1
:: Developer: Fahim
::
:: Changes in 2.1:
::  - Restore option (menu 2)
::  - Backups are verified before anything is changed
::  - Timestamped backup folders, newest listed first
::  - Backup folder falls back to %USERPROFILE% if the
::    script folder is read-only
::  - Sign-out option (some settings need it)
::  - Menu colour resets after every action
:: ==========================================

:: Backup locations (script folder first, user profile as fallback)
set "ROOT1=%~dp0Backups"
set "ROOT2=%USERPROFILE%\AppearanceBackups"

:MENU
color 0B
cls
echo.
echo ==========================================
echo       APPEARANCE FOR BEST PERFORMANCE
echo                  VERSION 2.1
echo ==========================================
echo.
echo   Optimize Windows visual effects.
echo.
echo   [1] Apply best performance settings
echo   [2] Restore a previous backup
echo   [3] Exit
echo.
echo ==========================================
choice /c 123 /n /m "Select an option: "

if errorlevel 3 exit /b
if errorlevel 2 goto RESTORE
if errorlevel 1 goto APPLY

:: ==========================================
:: APPLY
:: ==========================================
:APPLY
cls
echo.
echo ==========================================
echo          PERFORMANCE OPTIMIZATION
echo ==========================================
echo.
echo This will change these settings for the current user:
echo.
echo   - Turn off window and taskbar animations
echo   - Turn off dragging window contents
echo   - Turn off translucent selection rectangle
echo   - Turn off shadows under icon labels
echo   - Turn off Aero Peek
echo     (little or no effect on Windows 11)
echo   - Keep font smoothing ON
echo   - Keep thumbnails ON
echo.
echo A backup is created and verified first.
echo No administrator rights are needed.
echo.
choice /c YN /n /m "Continue? (Y/N): "
if errorlevel 2 goto CANCEL

:: ---- Timestamp for the backup folder ----
set "STAMP="
for /f %%a in ('powershell -nologo -noprofile -command "Get-Date -Format yyyyMMdd_HHmmss" 2^>nul') do set "STAMP=%%a"
if not defined STAMP set "STAMP=%RANDOM%%RANDOM%"

:: ---- Pick a writable backup root ----
set "BACKUP="
call :TRYROOT "%ROOT1%"
if not defined BACKUP call :TRYROOT "%ROOT2%"

if not defined BACKUP (
    color 0C
    echo.
    echo ERROR: Cannot create a backup folder in either location:
    echo   %ROOT1%
    echo   %ROOT2%
    echo Nothing was changed.
    echo.
    pause
    goto MENU
)

echo.
echo Creating registry backups...

set "BKFAIL=0"
call :EXPORT "HKCU\Control Panel\Desktop" Desktop required
call :EXPORT "HKCU\Control Panel\Desktop\WindowMetrics" WindowMetrics required
call :EXPORT "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" ExplorerAdvanced required
call :EXPORT "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" VisualEffects optional
call :EXPORT "HKCU\Software\Microsoft\Windows\DWM" DWM optional

if "!BKFAIL!"=="1" (
    color 0C
    echo.
    echo ERROR: Backup failed. No settings were changed.
    echo.
    pause
    goto MENU
)

echo.
echo Backup saved to:
echo !BACKUP!
echo.
echo Applying settings...

set "FAILED=0"
set "K_DESK=HKCU\Control Panel\Desktop"
set "K_METR=HKCU\Control Panel\Desktop\WindowMetrics"
set "K_ADV=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
set "K_VFX=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
set "K_DWM=HKCU\Software\Microsoft\Windows\DWM"

:: Best performance base mask
call :SETREG "!K_DESK!" UserPreferencesMask REG_BINARY 9012078010000000

:: Font smoothing ON (ClearType)
call :SETREG "!K_DESK!" FontSmoothing REG_SZ 2
call :SETREG "!K_DESK!" FontSmoothingType REG_DWORD 2

:: Window dragging and animation OFF
call :SETREG "!K_DESK!" DragFullWindows REG_SZ 0
call :SETREG "!K_METR!" MinAnimate REG_SZ 0

:: Explorer effects OFF
call :SETREG "!K_ADV!" TaskbarAnimations REG_DWORD 0
call :SETREG "!K_ADV!" ListviewAlphaSelect REG_DWORD 0
call :SETREG "!K_ADV!" ListviewShadow REG_DWORD 0

:: Thumbnails ON (IconsOnly = 0 means show thumbnails)
call :SETREG "!K_ADV!" IconsOnly REG_DWORD 0

:: Custom visual effects profile
call :SETREG "!K_VFX!" VisualFXSetting REG_DWORD 3

:: Aero Peek OFF
call :SETREG "!K_DWM!" EnableAeroPeek REG_DWORD 0

echo.
if "!FAILED!"=="1" (
    color 0C
    echo WARNING: Some registry changes failed.
    echo Check permissions and your Windows configuration.
    echo You can undo changes with option 2 in the main menu.
) else (
    color 0A
    echo ==========================================
    echo       OPTIMIZATION COMPLETED!
    echo ==========================================
)
echo.
call :APPLYCHANGES
goto MENU

:: ==========================================
:: RESTORE
:: ==========================================
:RESTORE
cls
echo.
echo ==========================================
echo            RESTORE A BACKUP
echo ==========================================
echo.

set "COUNT=0"
for %%R in ("%ROOT1%" "%ROOT2%") do (
    if exist "%%~R\" (
        for /f "delims=" %%D in ('dir /b /ad /o-n "%%~R\Backup_*" 2^>nul') do (
            set /a COUNT+=1
            set "B!COUNT!=%%~R\%%D"
        )
    )
)

if !COUNT! EQU 0 (
    echo No backups found.
    echo.
    pause
    goto MENU
)

echo Available backups, newest first within each location:
echo.
for /l %%i in (1,1,!COUNT!) do echo   [%%i] !B%%i!
echo.

set "SEL="
set /p "SEL=Enter backup number (0 to cancel): "

echo(!SEL!| findstr /r "^[0-9][0-9]*$" >nul 2>&1
if errorlevel 1 (
    echo.
    echo Invalid selection.
    pause
    goto MENU
)

set /a NUM=!SEL! 2>nul
if !NUM! EQU 0 goto CANCEL
if !NUM! LSS 1 goto RESTORE_BAD
if !NUM! GTR !COUNT! goto RESTORE_BAD

set "TARGET="
for %%n in (!NUM!) do set "TARGET=!B%%n!"

echo.
echo Restore from:
echo !TARGET!
echo.
choice /c YN /n /m "Continue? (Y/N): "
if errorlevel 2 goto CANCEL

set "RFAIL=0"
set "IMPORTED=0"
for %%F in ("!TARGET!\*.reg") do (
    reg import "%%~F" >nul 2>&1
    if errorlevel 1 (set "RFAIL=1") else (set /a IMPORTED+=1)
)

:: Keys that did not exist at backup time: remove the values we added
if exist "!TARGET!\VisualEffects.missing" reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /f >nul 2>&1
if exist "!TARGET!\DWM.missing" reg delete "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /f >nul 2>&1

echo.
if "!RFAIL!"=="1" (
    color 0C
    echo WARNING: Some files failed to import.
) else (
    color 0A
    echo ==========================================
    echo          RESTORE COMPLETED!
    echo ==========================================
)
echo Files imported: !IMPORTED!
echo.
call :APPLYCHANGES
goto MENU

:RESTORE_BAD
echo.
echo Number out of range.
pause
goto MENU

:: ==========================================
:: CANCEL
:: ==========================================
:CANCEL
echo.
echo Operation cancelled. No settings changed.
pause
goto MENU

:: ==========================================
:: SUBROUTINES
:: ==========================================

:: Try to create the backup folder under a root. Sets BACKUP on success.
:TRYROOT
set "TRY=%~1\Backup_!STAMP!"
mkdir "!TRY!" >nul 2>&1
if exist "!TRY!\" (
    >"!TRY!\.write_test" echo test 2>nul
    if exist "!TRY!\.write_test" (
        del "!TRY!\.write_test" >nul 2>&1
        set "BACKUP=!TRY!"
    )
)
exit /b 0

:: Export one registry key and verify the file exists.
:: %1 = key, %2 = file name, %3 = required or optional
:EXPORT
reg query "%~1" >nul 2>&1
if errorlevel 1 (
    if /i "%~3"=="optional" (
        echo   [skip] %~2 - key not present
        >"!BACKUP!\%~2.missing" echo missing
        exit /b 0
    )
    echo   [FAIL] %~2 - key not found
    set "BKFAIL=1"
    exit /b 1
)
reg export "%~1" "!BACKUP!\%~2.reg" /y >nul 2>&1
if not exist "!BACKUP!\%~2.reg" (
    echo   [FAIL] %~2 - export failed
    set "BKFAIL=1"
    exit /b 1
)
echo   [ OK ] %~2
exit /b 0

:: Write one registry value. Sets FAILED=1 on error.
:: %1 = key, %2 = value name, %3 = type, %4 = data
:SETREG
reg add "%~1" /v %~2 /t %~3 /d %~4 /f >nul 2>&1
if errorlevel 1 set "FAILED=1"
exit /b 0

:: Offer to restart Explorer or sign out so changes take effect.
:APPLYCHANGES
echo Some changes only fully apply after signing out.
echo.
echo   [1] Restart Windows Explorer now
echo   [2] Sign out now (save your work first)
echo   [3] Later
echo.
choice /c 123 /n /m "Select an option: "
if errorlevel 3 exit /b 0
if errorlevel 2 (
    shutdown /l
    exit /b 0
)
if errorlevel 1 (
    echo.
    echo Restarting Windows Explorer...
    taskkill /f /im explorer.exe >nul 2>&1
    start "" explorer.exe
    echo Explorer restarted.
    echo.
    pause
)
exit /b 0
