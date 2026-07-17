@echo off
:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:menu
cls
echo ==========================================
echo           DNS SWITCHER (Ethernet)
echo ==========================================
echo  1. Google DNS (8.8.8.8 / 8.8.4.4)
echo  2. Quad9 DNS (9.9.9.9 / 149.112.112.112)
echo  3. Cloudflare DNS (1.1.1.1 / 1.0.0.1)
echo  4. Reset to Automatic (DHCP)
echo  5. TEST ALL (Ping Latency Test)
echo  6. Exit
echo ==========================================
echo.

set /p choice="Select an option (1-6): "

if "%choice%"=="1" goto google
if "%choice%"=="2" goto quad9
if "%choice%"=="3" goto cloudflare
if "%choice%"=="4" goto dhcp
if "%choice%"=="5" goto testpings
if "%choice%"=="6" goto exit
goto menu

:google
echo Setting Google DNS...
netsh interface ipv4 set dns name="Ethernet" static 8.8.8.8 primary
netsh interface ipv4 add dns name="Ethernet" 8.8.4.4 index=2
goto success

:quad9
echo Setting Quad9 DNS...
netsh interface ipv4 set dns name="Ethernet" static 9.9.9.9 primary
netsh interface ipv4 add dns name="Ethernet" 149.112.112.112 index=2
goto success

:cloudflare
echo Setting Cloudflare DNS...
netsh interface ipv4 set dns name="Ethernet" static 1.1.1.1 primary
netsh interface ipv4 add dns name="Ethernet" 1.0.0.1 index=2
goto success

:dhcp
echo Resetting DNS to automatic (DHCP)...
netsh interface ipv4 set dns name="Ethernet" source=dhcp
goto success

:testpings
cls
echo ==========================================
echo          RUNNING DNS LATENCY TEST        
echo ==========================================
echo.
echo [1/3] Pinging Google DNS (8.8.8.8)...
ping 8.8.8.8 -n 4
echo ------------------------------------------
echo [2/3] Pinging Quad9 DNS (9.9.9.9)...
ping 9.9.9.9 -n 4
echo ------------------------------------------
echo [3/3] Pinging Cloudflare DNS (1.1.1.1)...
ping 1.1.1.1 -n 4
echo ==========================================
echo Test Complete. Look at the "Average" times above.
echo Lower ms = Faster gaming and browsing response.
echo.
pause
goto menu

:success
echo.
echo DNS updated successfully!
echo Flushing DNS cache...
ipconfig /flushdns
echo.
pause
goto menu

:exit
exit
