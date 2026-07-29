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

:: --------------------------------------------------------
:: BANNER (centered, light red)
:: --------------------------------------------------------
call :center "======================================"
call :center "        Dev-Fahim_Code"
call :center "github.com/dev-fahim-code"
call :center "======================================"
echo.
call :center "Administrative privileges confirmed. Starting optimization..."
echo.

:: --------------------------------------------------------
:: 1. REALTEK ETHERNET OPTIMIZATION
:: --------------------------------------------------------
call :center "Configuring Realtek Ethernet Adapter..."

:: Force 1.0 Gbps Full Duplex
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Speed & Duplex' -DisplayValue '1.0 Gbps Full Duplex' -ErrorAction SilentlyContinue"

:: Disable Power-Saving Restrictions
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Energy-Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Green Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Gigabit Lite' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Auto Disable Gigabit' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'WOL & Shutdown Link Speed' -DisplayValue 'Not Speed Down' -ErrorAction SilentlyContinue"

:: Maximize Buffers (Values can vary by driver; sets max standard values)
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Receive Buffers' -DisplayValue '512' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Transmit Buffers' -DisplayValue '512' -ErrorAction SilentlyContinue"

:: Enable Hardware Offloading
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'IPv4 Checksum Offload' -DisplayValue 'Rx & Tx Enabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue 'Rx & Tx Enabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue 'Rx & Tx Enabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Large Send Offload v2 (IPv4)' -DisplayValue 'Enabled' -ErrorAction SilentlyContinue"

call :center "Realtek settings applied."
echo.

:: --------------------------------------------------------
:: 2. INTEL WI-FI 6 OPTIMIZATION
:: --------------------------------------------------------
call :center "Configuring Intel Wi-Fi 6 Adapter..."

:: Maximize Throughput Standards & Channels
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName '802.11ax Wireless Mode' -DisplayValue '802.11ax' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Channel Width for 2.4GHz' -DisplayValue 'Auto' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Channel Width for 5GHz' -DisplayValue 'Auto' -ErrorAction SilentlyContinue"

:: Roaming & Power Tuning
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Roaming Aggressiveness' -DisplayValue '1. Lowest' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Transmit Power' -DisplayValue '5. Highest' -ErrorAction SilentlyContinue"

:: MIMO & Traffic Offloading
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'MIMO Power Save Mode' -DisplayValue 'No SMPS' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Packet Coalescing' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Throughput Booster' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"

call :center "Intel Wi-Fi settings applied."
echo.

:: --------------------------------------------------------
:: 3. WINDOWS WIRELESS POWER PLAN OPTIMIZATION
:: --------------------------------------------------------
call :center "Setting Windows Wireless Adapter to Maximum Performance..."

:: FIX: $activePlan was a PowerShell-local variable that did not persist
:: back to the batch file, so the final "powercfg /setactivescheme $activePlan"
:: line ran literally in cmd.exe and failed. Both value updates and the
:: re-activation now happen inside a single PowerShell session so the
:: variable stays alive for all three commands.
powershell -Command "$activePlan = (powercfg /getactivescheme).Split()[3]; powercfg /setacvalueindex $activePlan 19cbb8fa-0579-4c8e-8019-d483c57406de 12bbebe6-58d6-4636-95bb-3217ef867c1a 0; powercfg /setdcvalueindex $activePlan 19cbb8fa-0579-4c8e-8019-d483c57406de 12bbebe6-58d6-4636-95bb-3217ef867c1a 0; powercfg /setactivescheme $activePlan"

call :center "Windows Power settings applied."
echo.
call :center "======================================================="
call :center "OPTIMIZATION COMPLETE!"
call :center "Note: Network adapters may briefly reset to apply changes."
call :center "It is highly recommended to restart your PC."
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
