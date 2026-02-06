@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: Check for admin rights
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

set "UTILITIES_URL=https://github.com/Abscissa24/Utilities/raw/main"
set "TEMP_DIR=%SystemRoot%\Temp"
set "INSTALL_DIR=C:\Utilities"

cls
if exist "C:\Utilities\Uninstall\Unins000.exe" goto GUI_DETECTED
if not exist "%AppData%\Utilities\Shell\support.ico" goto CONFIG
if not exist "%AppData%\Utilities\Setup\Menu.bat" goto CONFIG
if exist "%AppData%\Utilities\Setup\Menu.bat" goto MAIN_MENU

goto MAIN_MENU

:: Experimental Flag
:GUI_WARNING_DISABLE
cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Developer Mode','GUI Warning Disabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
set "targetDir=C:\Utilities\Data\Plugins"
set "targetFile=%targetDir%\GUIWarningOff.ini"

if not exist "%targetDir%" mkdir "%targetDir%"
type nul > "%targetFile%"
goto MAIN_MENU

:: Experimental Flag
:GUI_WARNING_ENABLE
cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Developer Mode','GUI Warning Enabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
del /f /q "C:\Utilities\Data\Plugins\GUIWarningOff.ini"
goto MAIN_MENU

:GUI_DETECTED
:: We should not goto CONFIG because GUI should have handled that already
:: In the event that the user needs to reconfigure the system, use: WIN+R and enter para.
if exist "C:\Utilities\Data\Plugins\GUIWarningOff.ini" goto MAIN_MENU

cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Warning','GUI Detected','Why are you tinkering in the TUI? :P' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
goto MAIN_MENU

:CONFIG
cls
title Configuring
echo Fetching Resources     
:: Ensure required directories exist
if not exist "%AppData%\Utilities\Setup" md "%AppData%\Utilities\Setup"
if not exist "%AppData%\Utilities\Shell" md "%AppData%\Utilities\Shell"

:: Remove deprecated figlet if present (was used in much earlier versions).
if exist "%AppData%\Utilities\Figlet\figlet.exe" (
    cls
    del /f /q "%AppData%\Utilities\Figlet\figlet.exe"
)

:: Install fastfetch silently
:: If already installed, skip. Use the --force flag to persist downloading and installing.
winget install fastfetch >nul 2>&1

:: Notification Daemon
:: powershell -NoProfile -ExecutionPolicy Bypass -Command ^
:: "if (-not (Get-Module -ListAvailable -Name BurntToast)) { Install-Module -Name BurntToast -Scope CurrentUser -Force }"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Install-PackageProvider -Name NuGet -Force -ForceBootstrap | Out-Null; if (-not (Get-Module -ListAvailable -Name BurntToast)) { Install-Module -Name BurntToast -Scope CurrentUser -Force }"

:: Download Menu.bat if missing
if not exist "%AppData%\Utilities\Setup\Menu.bat" (
    cls
    powershell -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Menu.bat' -OutFile '%AppData%\Utilities\Setup\Menu.bat' -UseBasicParsing" >nul 2>&1
)

:: Download support.ico if missing
if not exist "%AppData%\Utilities\Shell\support.ico" (
    cls
    powershell -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/support.ico' -OutFile '%AppData%\Utilities\Shell\support.ico' -UseBasicParsing" >nul 2>&1
    )

:: Autostart with maintenance mode (if set to TRUE, the repository is under heavy maintenance - usually a massive upgrade/overhaul like with v10.20260204)
:: I'm turning maintenance mode off on the 04th of February 2026 (today) since the overhaul threshold was met.
set "ON=FALSE" 
:: If true, initially deploy with maintenance mode ENABLED. If false, deploy with FULL functionality.
:: Code inside this block runs ONLY if ON is TRUE (case-insensitive)
if /i "%ON%"=="TRUE" (
    :: Download MaintenanceMode.ini if missing
    :: I plan on using the type function to automatically create this parameter instead of downloading a precompiled one. Will do later.
    if not exist "%AppData%\Utilities\Shell\MaintenanceMode.ini" (
        cls
        powershell -Command ^
        "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/blob/main/Assets/Misc/MaintenanceMode.ini' -OutFile '%AppData%\Utilities\Shell\MaintenanceMode.ini' -UseBasicParsing" >nul 2>&1
    )
)
:: Code inside this block runs ONLY if ON is FALSE (case-insensitive)
if /i "%ON%"=="FALSE" (
del /f /q "%AppData%\Utilities\Shell\MaintenanceMode.ini" >nul 2>&1
)

:: A simple greeter after the system has been configured
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Welcome to Utilities ❤️','System Configured :D' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
cls
goto MAIN_MENU

:: Experimental Flag
:PURGE_CONFIG
cls
title Purging
echo Cleaning Resources
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"if (Get-Module -ListAvailable -Name BurntToast) { Uninstall-Module BurntToast -AllVersions -Force -ErrorAction SilentlyContinue }; ^
Remove-Item -Recurse -Force \"$env:LOCALAPPDATA\PackageManagement\ProviderAssemblies\NuGet\" -ErrorAction SilentlyContinue; ^
Remove-Item -Recurse -Force \"$env:LOCALAPPDATA\PackageManagement\ProviderCache\NuGet\" -ErrorAction SilentlyContinue; ^
Remove-Item -Recurse -Force \"$env:ProgramFiles\PackageManagement\ProviderAssemblies\NuGet\" -ErrorAction SilentlyContinue; ^
Remove-Item -Recurse -Force \"$env:ProgramFiles\PackageManagement\ProviderCache\NuGet\" -ErrorAction SilentlyContinue" *> $null
winget uninstall fastfetch >nul 2>&1
rmdir /s /q "%AppData%\Utilities" >nul 2>&1
goto CONFIG

:: Experimental Flag
:MAINTENANCE_WARNING_ON
cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Developer Mode', 'Maintenance Warning enabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
del /f /q "C:\Utilities\Data\Plugins\MaintenanceModeOff.ini"
goto MAIN_MENU

:: Experimental Flag
:MAINTENANCE_WARNING_OFF
cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Developer Mode', 'Maintenance Warning disabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
set "targetDir=C:\Utilities\Data\Plugins"
set "targetFile=%targetDir%\MaintenanceModeOff.ini"

if not exist "%targetDir%" mkdir "%targetDir%"
type nul > "%targetFile%"

goto MAIN_MENU

:: Experimental Flag
:INRO_WARNINGS_OFF
cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
    "New-BurntToastNotification -Text 'Developer Mode', 'Warnings Disabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""

set "targetDir=C:\Utilities\Data\Plugins"
set "targetFile1=%targetDir%\GUIWarningOff.ini"
set "targetFile2=%targetDir%\MaintenanceModeOff.ini"

if not exist "%targetDir%" mkdir "%targetDir%"
type nul > "%targetFile1%"
type nul > "%targetFile2%"
goto MAIN_MENU

:: Experimental Flag
:INRO_WARNINGS_ON
cls
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
"New-BurntToastNotification -Text 'Developer Mode', 'Warnings Enabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
del /f /q "C:\Utilities\Data\Plugins\MaintenanceModeOff.ini"
del /f /q "C:\Utilities\Data\Plugins\GUIWarningOff.ini"
goto MAIN_MENU

:: Experimental Flag
:MAINTENANCE_MODE_ON
set "targetDir=%AppData%\Utilities\Shell"
set "targetFile=%targetDir%\MaintenanceMode.ini"

if not exist "%targetDir%" mkdir "%targetDir%"
type nul > "%targetFile%"
goto MAIN_MENU

:: Experimental Flag
:MAINTENANCE_MODE_OFF
del /f /q "%AppData%\Utilities\Shell\MaintenanceMode.ini"
goto MAIN_MENU

:MAIN_MENU
cls
set "ON=FALSE" 
:: If true, initially deploy with maintenance mode ENABLED. If false, deploy with FULL functionality.
:: Code inside this block runs ONLY if ON is TRUE (case-insensitive)
if /i "%ON%"=="TRUE" (
    :: Download MaintenanceMode.ini if missing
    :: I plan on using the type function to automatically create this parameter instead of downloading a precompiled one. Will do later.
    if not exist "%AppData%\Utilities\Shell\MaintenanceMode.ini" (
        cls
        powershell -Command ^
        "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/blob/main/Assets/Misc/MaintenanceMode.ini' -OutFile '%AppData%\Utilities\Shell\MaintenanceMode.ini' -UseBasicParsing" >nul 2>&1
    )
)
:: Code inside this block runs ONLY if ON is FALSE (case-insensitive)
if /i "%ON%"=="FALSE" (
del /f /q "%AppData%\Utilities\Shell\MaintenanceMode.ini" >nul 2>&1
)

if not exist "%AppData%\Utilities\Shell\MaintenanceMode.ini" (
    title Utilities
)

if exist "%AppData%\Utilities\Shell\MaintenanceMode.ini" (
    title Utilities - 🚧Maintenance Mode🚧
    if not exist "C:\Utilities\Data\Plugins\MaintenanceModeOff.ini" (
        powershell -ExecutionPolicy Bypass -NoProfile -Command ^
        "New-BurntToastNotification -Text '🚧 MAINTENANCE 🚧','Core functions are disabled','Supplementary functions are available' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""
    )
)
COLOR 0B
echo.
echo  ██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗███████╗███████╗
echo  ██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝██║██╔════╝██╔════╝
echo  ██║   ██║   ██║   ██║██║     ██║   ██║   ██║█████╗  ███████╗
echo  ██║   ██║   ██║   ██║██║     ██║   ██║   ██║██╔══╝  ╚════██║
echo  ╚██████╔╝   ██║   ██║███████╗██║   ██║   ██║███████╗███████║
echo   ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝   ╚═╝╚══════╝╚══════╝
echo.
:: ===========================
:: Decide which menu to show
:: ===========================
if exist "C:\Utilities\Scripts" (
    set "opt1=Manage Utilities"
) else (
    set "opt1=Installation"
)
echo 1) %opt1%
echo 2) GitHub Homepage
echo 3) Configurations
echo 4) Update
echo.
set /p choice=Select an option: 

if "%choice%"=="1" (
    if "%opt1%"=="Manage Utilities" goto MANAGE_MENU
    goto INSTALL_MENU
)

if "%choice%"=="2" goto GITHUB_LAUNCH
if "%choice%"=="3" goto CONFIGURE
if "%choice%"=="4" goto UPGRADE

:: ===============================
:: Developer / Easter Egg Commands
:: ===============================

for %%A in (
    "dev_menu:DEV_MENU"
    "dev_gui:DEV_GUI"
    "info:DEV_INFO"
    "disable_gui_warning:GUI_WARNING_DISABLE"
    "enable_gui_warning:GUI_WARNING_ENABLE"
    "disable_maintenance_warning:MAINTENANCE_WARNING_OFF"
    "enable_maintenance_warning:MAINTENANCE_WARNING_ON"
    "disable_warnings:INRO_WARNINGS_OFF"
    "enable_warnings:INRO_WARNINGS_ON"
    "para:PURGE_CONFIG"
    "enable_maintenance_mode:MAINTENANCE_MODE_ON"
    "disable_maintenance_mode:MAINTENANCE_MODE_OFF"
    "enable_logs:UPGRADE_WITH_LOGS"
    "exp_restore:DEV_RESTORE"
    "activate_office:UPDATE_OFFICE_ACTIVATION"
) do (
    for /f "tokens=1,2 delims=:" %%B in (%%A) do (
        if /i "%choice%"=="%%~B" goto %%~C
    )
)

call :SHOW_ERROR
goto MAIN_MENU

:MANAGE_MENU
cls
title Manager
COLOR 0B
echo. 
echo  ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗ 
echo  ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗
echo  ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝
echo  ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗
echo  ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║
echo  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
echo.                                                           
echo 1) Uninstall 
echo 2) Reinstall
echo 3) Experimental Features
echo 4) Archived Versions
echo. 
echo 5) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto UNINSTALL_ALL
if "%choice%"=="2" goto INSTALL_STABLE
if "%choice%"=="3" goto MANAGE_EXPERIMENTAL
if "%choice%"=="4" goto INSTALL_ARCHIVED_VERSIONS
if "%choice%"=="5" goto MAIN_MENU

call :SHOW_ERROR
goto MANAGE_MENU

:MANAGE_EXPERIMENTAL
cls
title Experimental
color 0E

echo(
echo  ███████╗██╗  ██╗██████╗ ███████╗██████╗ ██╗███╗   ███╗███████╗███╗   ██╗████████╗ █████╗ ██╗     
echo  ██╔════╝╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██║     
echo  █████╗   ╚███╔╝ ██████╔╝█████╗  ██████╔╝██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████║██║     
echo  ██╔══╝   ██╔██╗ ██╔═══╝ ██╔══╝  ██╔══██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██║██║     
echo  ███████╗██╔╝ ██╗██║     ███████╗██║  ██║██║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ██║  ██║███████╗
echo  ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
echo(

set "expPath=C:\Utilities\Scripts\Experimental"

if exist "%expPath%" (
    goto EXP_MENU_INSTALLED
) else (
    goto EXP_MENU_NOTINSTALLED
)

:: ---------------------- MENU WHEN NOT INSTALLED ----------------------
:EXP_MENU_NOTINSTALLED
echo 1) Install Features
echo 2) Back to Manager
echo(
set /p "choice=Select an option: "

if "%choice%"=="1" goto INSTALL_EXPERIMENTAL
if "%choice%"=="2" goto MANAGE_MENU
call :SHOW_ERROR
goto MANAGE_EXPERIMENTAL

:: ---------------------- MENU WHEN INSTALLED ----------------------
:EXP_MENU_INSTALLED
echo 1) Uninstall Features
echo 2) Reinstall Features
echo 3) Back to Manager
echo(
set /p "choice=Select an option: "

if "%choice%"=="1" goto UNINSTALL_EXPERIMENTAL
if "%choice%"=="2" goto INSTALL_EXPERIMENTAL
if "%choice%"=="3" goto MANAGE_MENU

call :SHOW_ERROR
goto MANAGE_EXPERIMENTAL

:INSTALL_MENU
cls
title Installation
COLOR 0A
echo.
echo  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗      █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
echo  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
echo  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║
echo  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
echo  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
echo  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
echo.                                                                                          

echo 1) Utilities
echo 2) Utilities + Experimental
echo 3) Previous Versions
echo 4) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto INSTALL_STABLE
if "%choice%"=="2" goto INSTALL_EXPERIMENTAL
if "%choice%"=="3" goto INSTALL_ARCHIVED_VERSIONS
if "%choice%"=="4" goto MAIN_MENU
call :SHOW_ERROR
goto INSTALL_MENU

:INSTALL_ARCHIVED_VERSIONS
cls
title Archive
COLOR 0D
echo. 
echo   █████╗ ██████╗  ██████╗██╗  ██╗██╗██╗   ██╗███████╗
echo  ██╔══██╗██╔══██╗██╔════╝██║  ██║██║██║   ██║██╔════╝
echo  ███████║██████╔╝██║     ███████║██║██║   ██║█████╗  
echo  ██╔══██║██╔══██╗██║     ██╔══██║██║╚██╗ ██╔╝██╔══╝  
echo  ██║  ██║██║  ██║╚██████╗██║  ██║██║ ╚████╔╝ ███████╗
echo  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚══════╝
echo. 
echo. 
echo 1) Point-Release
echo 2) Rolling-Release
echo 3) Installer [BETA]
echo. 
echo 4) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto POINT
if "%choice%"=="2" goto VERSION_X_MENU
if "%choice%"=="3" goto PREVIOUS_INSTALLER
if "%choice%"=="4" goto INSTALL_MENU
call :SHOW_ERROR
goto INSTALL_ARCHIVED_VERSIONS

:PREVIOUS_INSTALLER
cls
title CLI Archive
COLOR 0D
echo. 
echo  ██████╗ ███████╗████████╗ █████╗ 
echo  ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗
echo  ██████╔╝█████╗     ██║   ███████║
echo  ██╔══██╗██╔══╝     ██║   ██╔══██║
echo  ██████╔╝███████╗   ██║   ██║  ██║
echo  ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝                              
echo. 
echo. 
echo 1) 25 September 2025
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto PREVIOUS_INSTALLER_INSTALL
if "%choice%"=="2" goto INSTALL_ARCHIVED_VERSIONS
call :SHOW_ERROR
goto INSTALL_ARCHIVED_VERSIONS

:PREVIOUS_INSTALLER_INSTALL
cls
echo Performing CLI Rollback [BETA]   
echo. 
takeown /f "%AppData%\Utilities" /r /d y >nul 2>&1
icacls "%AppData%\Utilities" /grant "%username%":F /t /q >nul 2>&1
rd /s /q "%AppData%\Utilities" >nul 2>&1

:: Create download directory if it doesn't exist
if not exist "%AppData%\Utilities\Setup" (
    mkdir "%AppData%\Utilities\Setup" >nul 2>&1
)

:: Download the file
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Installer/Setup.bat' -OutFile '%AppData%\Utilities\Setup\Setup.bat' -UseBasicParsing" >nul 2>&1

:: Verify the file contains @echo off
findstr /m "^@echo off" "%AppData%\Utilities\Setup\Setup.bat" >nul 2>&1
if errorlevel 1 (
    cls
    echo ERROR: Schema Corrupted
    echo.
    pause
    goto MAIN_MENU
)

:: Create target directory if it doesn't exist
if not exist "C:\Utilities\Data\Shortcuts" (
    mkdir "C:\Utilities\Data\Shortcuts" >nul 2>&1
)

:: Launch the copied setup file using call (in-process, avoids memory issues)
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝                                                  
timeout /t 2 /nobreak >nul 2>&1
cls
call "%AppData%\Utilities\Setup\Setup.bat"
exit

:POINT
cls
title Point-Release
COLOR 0D
echo 
echo  ██████╗  ██████╗ ██╗███╗   ██╗████████╗   ██████╗ ███████╗██╗     ███████╗ █████╗ ███████╗███████╗
echo  ██╔══██╗██╔═══██╗██║████╗  ██║╚══██╔══╝   ██╔══██╗██╔════╝██║     ██╔════╝██╔══██╗██╔════╝██╔════╝
echo  ██████╔╝██║   ██║██║██╔██╗ ██║   ██║█████╗██████╔╝█████╗  ██║     █████╗  ███████║███████╗█████╗ 
echo  ██╔═══╝ ██║   ██║██║██║╚██╗██║   ██║╚════╝██╔══██╗██╔══╝  ██║     ██╔══╝  ██╔══██║╚════██║██╔══╝  
echo  ██║     ╚██████╔╝██║██║ ╚████║   ██║      ██║  ██║███████╗███████╗███████╗██║  ██║███████║███████╗
echo  ╚═╝      ╚═════╝ ╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝
echo. 
echo. 
echo 1) Version-6.0 [Build Date: 24th October 2024]
echo 2) Version-7.0 [Build Date: 30th November 2024]
echo 3) Version-8.0 [Build Date: 12th December 2024]
echo 4) Version-9.0 [Build Date: 10th January 2025]
echo 5) Version-9.1 [Build Date: 12th January 2025]
echo. 
echo 6) Back
echo.
set /p "choice=Select an option: "

if "%choice%"=="1" (
    set "version=6.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="2" (
    set "version=7.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="3" (
    set "version=8.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="4" (
    set "version=9.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="5" (
    set "version=9.1"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="6" goto INSTALL_ARCHIVED_VERSIONS
goto SHOW_ERROR

:VERSION_X_MENU
cls
title Build Month
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ███╗   ███╗ ██████╗ ███╗   ██╗████████╗██╗  ██╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ████╗ ████║██╔═══██╗████╗  ██║╚══██╔══╝██║  ██║
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██╔████╔██║██║   ██║██╔██╗ ██║   ██║   ███████║
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║╚██╔╝██║██║   ██║██║╚██╗██║   ██║   ██╔══██║
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
echo. 
echo. 
echo 1) February 2026
echo 2) October 2025
echo 3) September 2025
echo 4) August 2025
echo 5) June 2025
echo 6) May 2025
echo 7) April 2025
echo 8) March 2025
echo. 
echo 9) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto VERSION_X_FEBRUARY_2026
if "%choice%"=="2" goto VERSION_X_OCTOBER
if "%choice%"=="3" goto VERSION_X_SEPTEMBER
if "%choice%"=="4" goto VERSION_X_AUGUST
if "%choice%"=="5" goto VERSION_X_JUNE
if "%choice%"=="6" goto VERSION_X_MAY
if "%choice%"=="7" goto VERSION_X_APRIL
if "%choice%"=="8" goto VERSION_X_MARCH
if "%choice%"=="9" goto INSTALL_ARCHIVED_VERSIONS
call :SHOW_ERROR
goto VERSION_X_MENU

:VERSION_X_OCTOBER
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 04 February 2026
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=04022026" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" goto VERSION_X_MENU

call :SHOW_ERROR
goto VERSION_X_OCTOBER

:VERSION_X_OCTOBER
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 10 October 2025
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=10102025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_OCTOBER

:VERSION_X_SEPTEMBER
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 25 September 2025
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=25092025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_SEPTEMBER

:VERSION_X_AUGUST
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 25 August 2025
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=25082025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_AUGUST

:VERSION_X_JUNE
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo.  
echo 1) 08 June 2025
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=08062025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_JUNE

:VERSION_X_MAY
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 26 May 2025
echo 2) 06 May 2025
echo. 
echo 3) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=26052025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" set "version=06052025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="3" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_MAY

:VERSION_X_APRIL
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 20 April 2025
echo 2) 04 April 2025
echo 3) 03 April 2025
echo 4) 01 April 2025
echo. 
echo 5) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=20042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" set "version=04042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="3" set "version=03042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="4" set "version=01042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="5" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_APRIL

:VERSION_X_MARCH
cls
title Build Date
COLOR 0D
echo. 
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗     ██████╗  █████╗ ████████╗███████╗
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
echo  ██████╔╝██║   ██║██║██║     ██║  ██║    ██║  ██║███████║   ██║   █████╗  
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║    ██║  ██║██╔══██║   ██║   ██╔══╝  
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝    ██████╔╝██║  ██║   ██║   ███████╗
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
echo. 
echo. 
echo 1) 31 March 2025
echo 2) 25 March 2025
echo 3) 24 March 2025
echo. 
echo 4) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=31032025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" set "version=25032025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="3" set "version=24032025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="4" goto VERSION_X_MENU
call :SHOW_ERROR
goto VERSION_X_MARCH

:INSTALL_STABLE
if exist "%AppData%\Utilities\Shell\MaintenanceMode.ini" (
    cls & color 0E
    echo WARNING: Maintenance Mode is active!
    echo.
    echo WARNING: This function is disabled.
    timeout /t 3 /nobreak >nul 2>&1
    goto MAIN_MENU
)

COLOR 0A
cls
echo. 
echo  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗ 
echo  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝ 
echo  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗
echo  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║
echo  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝
echo  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
echo. 
:: Fetch from repository
:: Am planning an experimental version that creates the modules from scratch using the type function during runtime.
:: By doing so, the project can be fully offline without needing to pull assets from the main repository
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Before Install' -RestorePointType 'APPLICATION_INSTALL'"
curl -L "%UTILITIES_URL%/Latest/Utilities.zip" -o "%TEMP_DIR%\Utilities.zip" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
robocopy "C:\Utilities\Data\Speedtest" "%AppData%\Ookla\Speedtest CLI" "speedtest-cli.ini" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0 >nul 2>&1
robocopy "C:\Utilities\Data\Shortcuts" "%AppData%\Utilities\Shortcuts" *.lnk /S /ZB /COPYALL /R:1 /W:1 >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"

:: Replace with path for any other custom icon
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /t REG_SZ /d "C:\Utilities\Shell\support.ico" /f >nul 2>&1
setx /M PATH "%PATH%;%INSTALL_DIR%\Data\Shortcuts;%AppData%\Utilities\Setup" >nul 2>&1
call :CLEANUP >nul 2>&1
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
echo Please read the documentation carefully!
timeout /t 2 /nobreak >nul 2>&1
start "" "C:\Utilities\Release\Stable.pdf"
goto MAIN_MENU

:INSTALL_EXPERIMENTAL
if exist "%AppData%\Utilities\Shell\MaintenanceMode.ini" (
    cls & COLOR 0E
    echo WARNING: Maintenance Mode is active!
    echo. 
    echo WARNING: This feature is disabled.
    timeout /t 3 /nobreak >nul 2>&1
    goto MAIN_MENU
)

COLOR 06 & cls
echo. 
echo  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗ 
echo  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝ 
echo  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗
echo  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║
echo  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝
echo  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
echo. 

if exist "C:\Utilities" (
    cls
    :: A helper function that simply adds the experimental features to an already existing installation.
    powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Before Install SE' -RestorePointType 'APPLICATION_INSTALL'"
    call "C:\Utilities\Data\Shortcuts\EXP.bat"
)

if not exist "C:\Utilities" (
    :: Fetch from repository
    :: Am planning an experimental version that creates the modules from scratch using the type function during runtime.
    :: By doing so, the project can be fully offline without needing to pull assets from the main repository
    powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Before Install SE' -RestorePointType 'APPLICATION_INSTALL'"
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1

    robocopy "C:\Utilities\Data\Speedtest" "%AppData%\Ookla\Speedtest CLI" "speedtest-cli.ini" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0
    robocopy "C:\Utilities\Data\Shortcuts" "%AppData%\Utilities\Shortcuts" *.lnk /S /ZB /COPYALL /R:1 /W:1
    regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"

    :: Replace with another path for any other custom icon
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /t REG_SZ /d "C:\Utilities\Shell\support.ico" /f
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/download/v1.1.2/uad-ng-windows.exe' -OutFile 'C:\Utilities\Data\ADB\uad-ng-windows.exe' -UseBasicParsing" >nul 2>&1

    :: Some android manufacturers like OnePlus have their O+ connect app to achieve screen mirroring.
    :: This implementation is for android devices lacking native support for wireless mirroring and screen recording using PC hardware.
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.3.2/scrcpy-win64-v3.3.2.zip' -OutFile '%TEMP_DIR%\scrcpy.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP_DIR%\scrcpy.zip' -DestinationPath '%INSTALL_DIR%\Data\Record' -Force" >nul 2>&1

    :: Install additional experimental components
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi' -OutFile '%TEMP_DIR%\UniversalAdbDriverSetup.msi' -UseBasicParsing" >nul 2>&1
    msiexec /i "%TEMP_DIR%\UniversalAdbDriverSetup.msi" /qn /norestart /passive >nul 2>&1

    :: setx /M PATH "!PATH!;%INSTALL_DIR%\Data\ADB" >nul 2>&1
    :: There is nothing wrong with the above method, although having a direct and native integration with K3V1991's ADB & Fastboot++ is significantly superior.
    :: The link to the above repository is: https://github.com/K3V1991/ADB-and-FastbootPlusPlus

    setx /M PATH "%PATH%;%AppData%\Utilities\Setup;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1

    :: Install ADB & Fastboot++
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/K3V1991/ADB-and-FastbootPlusPlus/releases/download/v1.1.1/ADB-and-Fastboot++_v1.1.1.msi' -OutFile '%TEMP_DIR%\ADB-Plus.msi' -UseBasicParsing" >nul 2>&1
    msiexec /i "%TEMP_DIR%\ADB-Plus.msi" /qn /norestart /passive >nul 2>&1
    timeout /t 2 /nobreak >nul 2>&1
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Experimental.zip' -OutFile '%TEMP_DIR%\Exp.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Exp.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
    regedit /s "%INSTALL_DIR%\Registry\Experimental.reg" >nul 2>&1
)

call :CLEANUP >nul 2>&1
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo.    
echo Please read the documentation carefully!
timeout /t 2 /nobreak >nul 2>&1
start "" "C:\Utilities\Info\Experimental.pdf"
goto MAIN_MENU

:INSTALL_ARCHIVE
COLOR 0A
cls
echo Installing Version-%version%
timeout /t 2 /nobreak >nul 2>&1
cls
call :CLEANUP_PREVIOUS
cls
echo Performing shell integration
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Archives/Version-%version%/Utilities-%version%.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
rmdir /s /q "%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Archives/Version-%version%/Experimental-%version:~-1%.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg" >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Experimental.reg" >nul 2>&1
call :RESTART_EXPLORER
call :CLEANUP
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 

if exist "C:\Utilities\Info\README.pdf" (
    start "" "C:\Utilities\Info\README.pdf" >nul 2>&1
) else if exist "C:\Utilities\Info\README.txt" (
    start "" "C:\Utilities\Info\README.txt" >nul 2>&1
) else if exist "C:\Utilities\Info\Info.pdf" (
    start "" "C:\Utilities\Info\Info.pdf" >nul 2>&1
) else if exist "C:\Utilities\Info\Stable.pdf" (
    start "" "C:\Utilities\Info\Stable.pdf" >nul 2>&1
) else if exist "C:\Utilities\Info\Experimental.pdf" (
    start "" "C:\Utilities\Info\Experimental.pdf" >nul 2>&1
)

goto MAIN_MENU

:INSTALL_ARCHIVE_X
COLOR 0A
cls
echo Installing Utilities-X from archive [%version%]
call :CLEANUP_PREVIOUS
cls
echo Performing shell integration
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Archives/Version-X/%version%/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Archives/Version-X/%version%/Experimental-X.zip' -OutFile '%TEMP_DIR%\Experimental.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Experimental.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/download/v1.1.2/uad-ng-windows.exe' -OutFile '%INSTALL_DIR%\Data\Misc\uad-ng-windows.exe' -UseBasicParsing" >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.3.2/scrcpy-win64-v3.3.2.zip' -OutFile '%TEMP_DIR%\scrcpy-win64-v3.3.2.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\scrcpy-win64-v3.3.2.zip' -DestinationPath '%INSTALL_DIR%\Data\Record' -Force" >nul 2>&1
powershell -nologo -noprofile -command "Expand-Archive -LiteralPath 'C:\Utilities\Data\Wise.zip' -DestinationPath 'C:\Program Files (x86)' -Force" >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" support.ico /COPYALL /R:3 /W:5 >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"
regedit /s "%INSTALL_DIR%\Registry\Experimental.reg" >nul 2>&1

call :RESTART_EXPLORER >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi' -OutFile '%TEMP_DIR%\UniversalAdbDriverSetup.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\UniversalAdbDriverSetup.msi" /qn /norestart /passive >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\ADB" >nul 2>&1
setx /M PATH "!PATH!;%AppData%\Utilities\Setup" >nul 2>&1
setx /M PATH "!PATH!;%AppData%\Utilities\Shortcuts" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\Wise Program Uninstaller.lnk" >nul 2>&1

call :CLEANUP
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
echo. 
echo Please read the documentation carefully!
timeout /t 2 /nobreak >nul 2>&1
start "C:\Utilities\Info\Experimental.pdf"
goto MAIN_MENU

:UNINSTALL_EXPERIMENTAL
COLOR 0C & cls
echo Removing from shell...
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Before Experimental Uninstall' -RestorePointType 'APPLICATION_INSTALL'" >nul 2>&1
reg delete "HKCR\Directory\Background\shell\Z002AAC\shell\Z007ACD" /f >nul 2>&1
reg delete "HKCR\Directory\background\shell\Z002AAC\shell\Z007ACE" /f >nul 2>&1
takeown /f "%INSTALL_DIR%\Scripts\Experimental" /r /d y >nul 2>&1
icacls "%INSTALL_DIR%\Scripts\Experimental" /grant %username%:F /t >nul 2>&1
rmdir /s /q "%INSTALL_DIR%\Scripts\Experimental" >nul 2>&1
rmdir /s /q "%INSTALL_DIR%\Data\Record" >nul 2>&1
del /f /q "%INSTALL_DIR%\Info\Experimental.pdf" >nul 2>&1

:: An experimental patch that fixes the context menu
:: For some unkown reason, without this patch, the "New" context menu entry vanishes and the user can not easily create folders/files.
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
reg add "HKCR\Directory\Background\shellex\ContextMenuHandlers\New" /ve /d "{D969A300-E7FF-11d0-A93B-00A0C90F2719}" /f
timeout /t 2 /nobreak
taskkill /f /im explorer.exe && start explorer.exe
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
timeout /t 2 /nobreak >nul 2>&1
goto MAIN_MENU

:UNINSTALL_ALL
COLOR 0C & cls
echo Uninstalling...
powershell -Command "Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Before Complete Uninstall' -RestorePointType 'APPLICATION_INSTALL'"

call :CLEANUP_PREVIOUS >nul 2>&1
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
timeout /t 2 /nobreak >nul 2>&1
start explorer.exe
goto MAIN_MENU

:: Extremely experimental, which is why it is not listed as a direct command/alias.
:: Made as a prototype of the experimental pipeline's "Panacea"
:: This highly experimental module uses the FIDo tool to downaload a fresh copy of windows 11
:: The goal was to be able to fix corrupted/ broken system files without having to hard reset or re-flash windows.
:: On the to-do list
:DEV_RESTORE
cls
title Windows 11 Repair (DISM + SFC)
setlocal
:: --------------------------
:: CONFIG
:: --------------------------
set ISO_PATH=%TEMP%\Win11.iso
set FIDO=%TEMP%\Fido.ps1
set LOG=%TEMP%\Win11Repair.log
echo.
echo ===============================
echo   WINDOWS 11 AUTO REPAIR
echo ===============================
echo.
:: --------------------------
:: Download Fido Script
:: --------------------------
echo Downloading ISO tool...
powershell -NoProfile -ExecutionPolicy Bypass ^
"Invoke-WebRequest 'https://raw.githubusercontent.com/pbatard/Fido/master/Fido.ps1' -OutFile '%FIDO%'"
if not exist "%FIDO%" (
    echo ERROR: Could not download Fido!
    pause
    exit /b
)
:: --------------------------
:: Download Windows 11 ISO
:: --------------------------
echo.
echo Downloading latest Windows 11 ISO...
powershell -NoProfile -ExecutionPolicy Bypass ^
"& '%FIDO%' -Win 11 -Edition 'Windows 11' -Language 'English' -Architecture x64 -GetMedia -Out '%ISO_PATH%'"
if not exist "%ISO_PATH%" (
    echo ERROR: ISO failed to download!
    pause
    exit /b
)
:: --------------------------
:: Mount ISO
:: --------------------------
echo.
echo Mounting ISO...
powershell -NoProfile -ExecutionPolicy Bypass ^
"$img = Mount-DiskImage -ImagePath '%ISO_PATH%' -PassThru; $vol = ($img | Get-Volume).DriveLetter; Write-Host $vol" > "%TEMP%\isovol.txt"
set /p ISODRIVE=<"%TEMP%\isovol.txt"
set ISODRIVE=%ISODRIVE%:
if "%ISODRIVE%"==":" (
    echo ERROR: Could not mount ISO!
    pause
    exit /b
)

echo ISO mounted at %ISODRIVE%
:: --------------------------
:: Find install.wim/esd
:: --------------------------
if exist "%ISODRIVE%\sources\install.wim" (
    set SRC=%ISODRIVE%\sources\install.wim
) else (
    if exist "%ISODRIVE%\sources\install.esd" (
        set SRC=%ISODRIVE%\sources\install.esd
    ) else (
        echo ERROR: No install.wim/esd found!
        pause
        exit /b
    )
)

echo Using repair source: %SRC%
:: --------------------------
:: DISM Repair
:: --------------------------
echo.
echo Running DISM (this takes a while)...
dism /Online /Cleanup-Image /RestoreHealth /Source:wim:%SRC%:1 /LimitAccess >> "%LOG%"
echo DISM completed.
echo.
:: --------------------------
:: SFC Repair
:: --------------------------
echo Running SFC...
sfc /scannow >> "%LOG%"
echo SFC completed.
echo.
:: --------------------------
:: Unmount ISO
:: --------------------------
echo Unmounting ISO...
powershell -NoProfile -ExecutionPolicy Bypass ^
"Dismount-DiskImage -ImagePath '%ISO_PATH%'"
echo Done.
echo Logs saved to: %LOG%
echo Please reboot your PC.
pause
exit /b

:: Takes the user to the main repository
:GITHUB_LAUNCH
cls
echo. 
echo   ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗ 
echo  ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗
echo  ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝
echo  ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗
echo  ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝
echo   ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
echo.                                          
timeout /t 1 /nobreak >nul 2>&1
start https://github.com/Abscissa24/Utilities
pause
goto MAIN_MENU

:: Hidden DEV Menu
:DEV_MENU
COLOR 06
cls
echo. 
echo  ██████╗ ███████╗██╗   ██╗    ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
echo  ██╔══██╗██╔════╝██║   ██║    ████╗ ████║██╔════╝████╗  ██║██║   ██║
echo  ██║  ██║█████╗  ██║   ██║    ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
echo  ██║  ██║██╔══╝  ╚██╗ ██╔╝    ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
echo  ██████╔╝███████╗ ╚████╔╝     ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
echo  ╚═════╝ ╚══════╝  ╚═══╝      ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ 
echo.                                                                 

echo 1) SETUP_INFO
echo 2) GIT_LAUNCH
echo 3) INSTALL_BETA_GUI
echo 4) SWITCH_TO_LEGACY_SHORTCUTS
echo 5) CREATE_LOCAL_DEV_REPOSITORY
echo. 
echo 6) MAIN_MENU
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto DEV_INFO
if "%choice%"=="2" goto GITHUB_LAUNCH
if "%choice%"=="3" goto DEV_GUI
if "%choice%"=="4" goto SWITCH_TO_LEGACY_SHORTCUTS
if "%choice%"=="5" goto DEV_MAKE_REPO
if /i "%choice%"=="enable_auto_update" goto AUTOUPDATE_ON
if /i "%choice%"=="disable_auto_update" goto AUTOUPDATE_OFF
if /i "%choice%"=="enable_logs" goto UPGRADE_WITH_LOGS
if /i "%choice%"=="disablee_logs" goto UPGRADE
if "%choice%"=="6" goto MAIN_MENU

:: Invalid choice
call :SHOW_ERROR
goto DEV_MENU

:SWITCH_TO_LEGACY_SHORTCUTS
:: Ensure shortcuts folder exists first
if not exist "C:\Utilities\Data\Shortcuts" (
    cls
    COLOR 04
    echo ERROR: No Installed Scheme!
    echo.
    pause
    goto DEV_MENU
)

:: Use choice to get a clean Y/N answer without parsing oddities
cls
choice /m "Remove shell integration?"
if errorlevel 2 goto SWITCH_TO_LEGACY_SHORTCUTS_BOTH
if errorlevel 1 goto SWITCH_TO_LEGACY_SHORTCUTS_ONLY

:: Fallback (shouldn't happen)
call :SHOW_ERROR
goto DEV_MENU

:SWITCH_TO_LEGACY_SHORTCUTS_ONLY
:: Remove registry shell entries (quoted, single-line token list)
for %%K in (
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities"     
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Record"        
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAA"
) do (
    reg delete "%%~K" /f >nul 2>&1
)

:: Copy legacy shortcuts to Desktop if present
for %%F in (clean.lnk lag.lnk insomnia.lnk speed.lnk tidy.lnk dmu.lnk) do (
    if exist "C:\Utilities\Data\Shortcuts\%%F" (
        copy /y "C:\Utilities\Data\Shortcuts\%%F" "%USERPROFILE%\Desktop\" >nul 2>&1
    )
)

goto DEV_MENU
:SWITCH_TO_LEGACY_SHORTCUTS_BOTH
:: Keep registry entries, only copy shortcuts
for %%F in (clean.lnk lag.lnk insomnia.lnk speed.lnk tidy.lnk dmu.lnk) do (
    if exist "C:\Utilities\Data\Shortcuts\%%F" (
        copy /y "C:\Utilities\Data\Shortcuts\%%F" "%USERPROFILE%\Desktop\" >nul 2>&1
    )
)

goto DEV_MENU

:DEV_GUI
cls
echo Fetching latest GUI
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/GUI/Utilities.exe' -OutFile '%USERPROFILE%\Desktop\Utilities.exe' -UseBasicParsing" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
cls
start "" "%USERPROFILE%\Desktop\Utilities.exe"
goto MAIN_MENU

:DEV_INFO
cls 
fastfetch
echo. 
pause
COLOR 0B
echo. 
echo  ██╗███╗   ██╗███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
echo  ██║████╗  ██║██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
echo  ██║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██╔████╔██║███████║   ██║   ██║██║   ██║██╔██╗ ██║
echo  ██║██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
echo  ██║██║ ╚████║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
echo  ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
echo.
echo.                                                                                       
echo Setup Version: 10.260204, Build Date: 04th February 2026
echo Previous Version: 10.251124, Build Date: 24th November 2025
echo Code Name: Project Zen
if exist "C:/Utilities/Uninstall/Unins000.exe" (
echo GUI Found: TRUE)
if not exist "C:/Utilities/Uninstall/Unins000.exe" (
echo GUI Found: FALSE [Running TUI Version-X 10.260204])
echo. 
echo Developer: Abscissa24
echo GitHub: https://github.com/Abscissa24/Utilities
echo. 
if exist "C:/Utilities/Scripts" (
echo Utilities Size-On-Disk: 2.76 MB (2,899,968 bytes) [INSTALLED])
if not exist "C:/Utilities" (
echo Utilities Size-On-Disk: 0MB [NOT INSTALLED])
if exist "C:/Utilities/Uninstall/Unins000.exe" (
echo. 
echo EXE Wrapper Version: NULL)
echo Version is supposed to be > 4.0, but an update to Inno corrupted my .iss file :(
echo Basically, the new version I was working on got corrupted. Will tackle some other time. TUI will work for now!
echo. 
echo GIT Health: Excellent
echo Package Health: Excellent
echo Commit Rate: Good
echo Repository Size: 352.8MB
echo. 
pause 
goto MAIN_MENU
)

:: Remnant of previous builds. It's a good theme so i'll keep it here.
:: Perhaps it'll get overhauled in the future
:MAWZES_THEME
cls

:: 1. Set Variables
set "ThemeDir=%AppData%\Utilities\Themes"
set "TempDir=%TEMP%"

:: 2. Kill Explorer ONCE to release file locks and clear cache
taskkill /f /im explorer.exe >nul 2>&1

:: 3. Cleanup Old Files & Registry
regsvr32 /u /s "%ThemeDir%\Release\ExplorerBlurMica.dll" >nul 2>&1
if exist "%ThemeDir%" rd /s /q "%ThemeDir%" >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /f >nul 2>&1
winget uninstall StartIsBack.StartAllBack >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
rmdir /s /q "AppData\Local\StartAllBack" >nul 2>&1

:: --- 3.1 Stop Explorer & Shell Processes ---
cls
echo Stopping Shell Processes
taskkill /f /im ShellExperienceHost.exe >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im RuntimeBroker.exe >nul 2>&1

:: --- 3.2 Clear Windows Icon and Thumbnail Cache ---
cls
echo Clearing Windows icon and thumbnail cache
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache*" >nul 2>&1

:: --- 3.3 Reset Taskbar Registry Values ---
cls
echo Resetting Taskbar Registry Values
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSi /f >nul 2>&1

:: --- 3.4 Reset Start Menu Database ---
cls
echo Resetting Start Menu Database
del /f /q "%LOCALAPPDATA%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\*" >nul 2>&1

:: --- 3.5 Re-Register Shell Components (AppX) ---
cls
echo Registering Shell Components
powershell -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul 2>&1

:: --- 3.6 Repair Windows Search Index ---
cls
echo Repairing Windows Search Index
powershell -ExecutionPolicy Bypass -Command "Get-Service WSearch | Restart-Service" >nul 2>&1

:: Idk why I commented this out. Must've been for good reason
:: DISM /Online /Cleanup-Image /RestoreHealth
:: sfc /scannow

:: 4. Download Assets
cls
echo Downloading Assets...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Mawzes.zip' -OutFile '%TempDir%\Mawzes.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Release.zip' -OutFile '%TempDir%\Release.zip' -UseBasicParsing" >nul 2>&1

:: 5. Install & Extract
cls
echo Extracting Files...
powershell -Command "Expand-Archive -Path '%TempDir%\Mawzes.zip' -DestinationPath '%ThemeDir%' -Force" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TempDir%\Release.zip' -DestinationPath '%ThemeDir%' -Force" >nul 2>&1

:: 6. Configure Registry & Register DLL
regsvr32 /s "%ThemeDir%\Release\ExplorerBlurMica.dll"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%ThemeDir%\Mawzes\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%ThemeDir%\Mawzes\Icons\folder.ico,0" /f >nul 2>&1
winget install StartIsBack.StartAllBack >nul 2>&1

:: 7. Restart Explorer and Apply Theme
start explorer.exe
timeout /t 3 /nobreak >nul 2>&1
start "" "%ThemeDir%\Mawzes\Mawzes.theme"

:: Cleanup Temp Files
del "%TempDir%\Mawzes.zip" >nul 2>&1
del "%TempDir%\Release.zip" >nul 2>&1
goto THEMES

:: This exists as a way to set up a development environment on any system locally.
:DEV_MAKE_REPO
cls
set "TEMP_DIR=%TEMP%\POLKIT"
set "PASS_FILE=%TEMP_DIR%\authentication.ini"

:: Make sure temp directory exists
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Download the zip file silently
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/Misc/authentication.ini' -OutFile '%PASS_FILE%' -UseBasicParsing" >nul 2>&1

:: Check if downloaded file exists
if not exist "%PASS_FILE%" (
    echo ERROR: Failed to generate password scheme!
    echo. 
    pause
    goto DEV_MENU
)

:: Prompt for password
set /p choice=Password: 

:: Read the password from the file
set /p correct_pass=<"%PASS_FILE%"

:: You're probably looking at this specific line to bypass the authentication :)
:: If you came all this way, it must be important. The password is 24072411.
:: Alternatively, just pull directly from main repo and fork it??
:: You could also change "%correct_pass%" to "%choice%" to crack it directly, then whatever integer or string you enter will work.
if "%choice%"=="%correct_pass%" goto DEV_PASS_UNLOCK

:: Invalid choice
goto DEV_PASS_LOCK

:DEV_PASS_LOCK
cls
echo Incorrect Password
echo.
pause
goto DEV_MENU

:DEV_PASS_UNLOCK
cls
echo Authentication Successful!
timeout /t 2 /nobreak >nul 2>&1
cls
echo Building Schema 0%
timeout /t 1 /nobreak >nul 2>&1
cls
echo Building Schema 11%
timeout /t 2 /nobreak >nul 2>&1
cls
echo Building Schema 24%
echo. 
if exist "%TEMP%\Utilities-main" (
    robocopy "%TEMP%\Utilities-main\Utilities-main" "%USERPROFILE%\Desktop\GitHub Development" /E /ZB /COPYALL /R:1 /W:1 /TEE
)
echo. 
if not exist "%TEMP%\Utilities-main" (
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/archive/refs/heads/main.zip' -OutFile '%TEMP%\Utilities-main.zip'"
cls
echo Building Schema 36%
timeout /t 2 /nobreak >nul 2>&1
cls
echo Building Schema 49%
timeout /t 2 /nobreak >nul 2>&1
cls
echo Building Schema 60%
timeout /t 1 /nobreak >nul 2>&1
echo. 
powershell -Command "Expand-Archive -Path '%TEMP%\Utilities-main.zip' -DestinationPath '%TEMP%\Utilities-main'"
robocopy "%TEMP%\Utilities-main\Utilities-main" "%USERPROFILE%\Desktop\GitHub Development" /E /ZB /COPYALL /R:1 /W:1 /TEE
cls
echo Building Schema 72%
timeout /t 1 /nobreak >nul 2>&1
cls
echo Building Schema 84%
timeout /t 1 /nobreak >nul 2>&1
cls
echo Building Schema 99%
timeout /t 1 /nobreak >nul 2>&1
echo. 
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Menu.bat' -OutFile '%USERPROFILE%\Desktop\GitHub Development\Menu.bat' -UseBasicParsing" >nul 2>&1
cls
echo Building Schema 100%
timeout /t 1 /nobreak >nul 2>&1
cls
echo Merging into your Desktop
timeout /t 2 /nobreak >nul 2>&1
cls
echo 
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
timeout /t 2 /nobreak >nul 2>&1
echo.
goto DEV_MENU
)

:CONFIGURE

cls
echo. 
echo   ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ███████╗
echo  ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ ██╔════╝
echo  ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗███████╗
echo  ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║╚════██║
echo  ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝███████║
echo   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝
echo. 
echo. 
echo 1) Themes
echo 2) Microsoft Office
echo 3) Activate Windows
echo. 
echo 4) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto CONFIGURE_THEMES
if "%choice%"=="2" goto CONFIGURE_OFFICE
if "%choice%"=="3" goto ACTIVATE_WINDOWS
if "%choice%"=="4" goto MAIN_MENU
call :SHOW_ERROR

:CONFIGURE_THEMES
if exist "%AppData%\Utilities\Themes\Release" goto THEMES
if not exist "%AppData%\Utilities\Themes\Release" goto SYNC_THEMES

:SYNC_THEMES
cls
echo Fetching Resources
 powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Release.zip' -OutFile '%TEMP%\Release.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Release.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
goto THEMES

:THEMES
cls
echo. 
echo  ████████╗██╗  ██╗███████╗███╗   ███╗███████╗███████╗
echo  ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝██╔════╝
echo     ██║   ███████║█████╗  ██╔████╔██║█████╗  ███████╗
echo     ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  ╚════██║
echo     ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗███████║
echo     ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚══════╝
echo.  
echo. 
echo. 
echo 1) Abstract
echo 2) Pretty Pink
echo 3) Bubu and Dudu
echo 4) Samurai Catto
echo 5) Mawzes
echo. 
echo 6) Options
echo 7) Back
echo. 
set /p choice=Select an option: 

if "%choice%"=="1" goto ABSTRACT
if "%choice%"=="2" goto PINK
if "%choice%"=="3" goto BUBU_DUDU
if "%choice%"=="4" goto SAMURAI_CATTO
if "%choice%"=="5" goto MAWZES_THEME
if "%choice%"=="6" goto OPTIONS
if "%choice%"=="7" goto CONFIGURE
call :SHOW_ERROR

:SAMURAI_CATTO
if not exist "%AppData%\Utilities\Themes\SamuraiCatto" (
cls
 powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/SamuraiCatto.zip' -OutFile '%TEMP%\SamuraiCatto.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\SamuraiCatto.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

if exist "%AppData%\Utilities\Themes\SamuraiCatto" (
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
cls
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\SamuraiCatto\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\SamuraiCatto\Icons\folder.ico,0" /f >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start "" "%AppData%\Utilities\Themes\SamuraiCatto\SamuraiCatto.theme" >nul 2>&1
goto THEMES
)

:PINK
cls
if not exist "%AppData%\Utilities\Themes\Pink" (
 powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Pink.zip' -OutFile '%TEMP%\Pink.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Pink.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

if exist "%AppData%\Utilities\Themes\Pink" (
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
cls
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Pink\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Pink\Icons\folder.ico,0" /f >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start "" "%AppData%\Utilities\Themes\Pink\Pink.theme" >nul 2>&1
goto THEMES
)

:BUBU_DUDU
cls
if not exist "%AppData%\Utilities\Themes\Bubu" (
 powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Bubu.zip' -OutFile '%TEMP%\Bubu.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Bubu.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

if exist "%AppData%\Utilities\Themes\Bubu" (
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
cls
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Bubu\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Bubu\Icons\folder.ico,0" /f >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start "" "%AppData%\Utilities\Themes\Bubu\BubuDudu.theme" >nul 2>&1
goto THEMES
)

:OPTIONS
cls
echo. 
echo   ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
echo  ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
echo  ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗
echo  ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║
echo  ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║███████║
echo   ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
echo.
echo.
echo 1) Toggle explorer blur
echo 2) Revert to default theme
echo 3) [BETA] Clone Wallpaper Repository
echo. 
echo 4) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto MICA_TOGGLE
if "%choice%"=="2" goto REVERT
if "%choice%"=="3" goto WALLPAPER
if "%choice%"=="4" goto CONFIGURE_THEMES

:WALLPAPER
cls
winget install --id Git.Git --source winget >nul 2>&1
rmdir /s /q "%USERPROFILE%\Pictures\wallpaper" >nul 2>&1
git clone --depth=1 https://github.com/mylinuxforwork/wallpaper.git %USERPROFILE%\Pictures\wallpaper
start "" "%USERPROFILE%\Pictures\wallpaper"
goto OPTIONS

:ABSTRACT
cls
if not exist "%AppData%\Utilities\Themes\Abstract" (
 powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Abstract.zip' -OutFile '%TEMP%\Abstract.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Abstract.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

if exist "%AppData%\Utilities\Themes\Abstract" (
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
cls
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Abstract\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Abstract\Icons\folder.ico,0" /f >nul 2>&1
taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start "" "%AppData%\Utilities\Themes\Abstract\Abstract.theme" >nul 2>&1
goto THEMES
)

:MICA_TOGGLE
if exist "%tmp%\m" (set "a=/u /s" & del "%tmp%\m") else (set "a=/s" & type nul > "%tmp%\m")
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
regsvr32 %a% "C:\Windows\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1
regsvr32 %a% "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1 & timeout /t 1 /nobreak >nul 2>&1 & start explorer.exe >nul 2>&1
goto OPTIONS

:REVERT
cls
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
del /q /f /s "%localappdata%\Microsoft\Windows\Themes\*.*" && rmdir /s /q "%localappdata%\Microsoft\Windows\Themes\" >nul 2>&1
cls
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
regsvr32 /u /s "C:\Windows\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1
regsvr32 /u /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
set "targetFolder=%AppData%\Utilities\Themes"
takeown /f "%targetFolder%" /r /d y >nul
icacls "%targetFolder%" /grant %username%:F /t >nul
rd /s /q "%targetFolder%"
cls
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /f >nul 2>&1

:: Reset wallpaper to default
reg delete "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /f >nul 2>&1
cls
timeout /t 1 /nobreak >nul 2>&1

:: Reset theme
start "" "C:\Windows\Resources\Themes\aero.theme" >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1

:: Try alternate approach for testing
PowerShell -Command "Start-Process \"$env:SystemRoot\Resources\Themes\Windows.theme\""
timeout /t 2 /nobreak >nul 2>&1
goto OPTIONS

:CONFIGURE_OFFICE 
COLOR 0A
cls  
echo Installing M365 Office [LATEST]
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/Office.zip' -OutFile '%SystemRoot%\Temp\Office.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Office.zip' -DestinationPath '%Appdata%\Utilities\Office' -Force" >nul 2>&1
cd %Appdata%\Utilities\Office
setup.exe /configure Configuration.xml
cls
echo Installing Outlook
winget install --id=9NRX63209R7B -h --silent --accept-package-agreements --accept-source-agreements 
cls
echo Activating
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /Ohook }"
cls
echo 
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
timeout /t 2 /nobreak >nul 2>&1

goto CONFIGURE
    
:UPDATE_OFFICE_ACTIVATION
cls
echo Updating Activation
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /Ohook }"
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
timeout /t 2 /nobreak >nul 2>&1
goto CONFIGURE

:ACTIVATE_WINDOWS
cls
echo Activating
echo. 
echo. 
call powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /HWID }"
cls
echo 
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo. 
timeout /t 2 /nobreak >nul 2>&1
goto CONFIGURE

:: I was trying to experiment with a logging feature where each command's output gets logged to a .log file for tracking and troubleshooting.
:: Also, a version with no >nul 2>&1 to not have console messages supressed.
:UPGRADE_WITH_LOGS
cls
COLOR 0E

:: Notify & Ensure permissions in one line
echo Enabling Debugging Mode
set "UtilDir=%AppData%\Utilities"
takeown /f "%UtilDir%" /r /d y >nul 2>&1
icacls "%UtilDir%" /grant "%username%":F /t /q >nul 2>&1

:: Create download directory (Setup) and target directory (Shortcuts) efficiently
if not exist "%UtilDir%\Setup" mkdir "%UtilDir%\Setup" >nul 2>&1
if not exist "C:\Utilities\Data\Shortcuts" mkdir "C:\Utilities\Data\Shortcuts" >nul 2>&1

:: Download the file using a single line of PowerShell
set "DownloadURL=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/Misc/Setup_Debug.bat"
set "DownloadPath=%UtilDir%\Setup\Setup_Debug.bat"
powershell -Command "iwr -Uri '%DownloadURL%' -OutFile '%DownloadPath%' -UseBasicParsing -SkipCertificateCheck" >nul 2>&1

:: Verify file integrity (findstr check remains)
findstr /m "^@echo off" "%DownloadPath%" >nul 2>&1
if errorlevel 1 (
    cls
    echo ERROR: Schema Corrupted
    echo.
    pause
    goto MAIN_MENU
)

:: Display ASCII art
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝╚══════╝
timeout /t 2 /nobreak >nul
powershell -NoProfile -Command "New-BurntToastNotification -Text 'Developer Mode','Debugging Mode Enabled' -AppLogo \"$env:APPDATA\Utilities\Shell\support.ico\""

:: Launch the downloaded setup file
cls
call "%DownloadPath%"
exit

:UPGRADE
cls
echo. 
echo  ██╗   ██╗██████╗  ██████╗ ██████╗  █████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
echo  ██║   ██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝ 
echo  ██║   ██║██████╔╝██║  ███╗██████╔╝███████║██║  ██║██║██╔██╗ ██║██║  ███╗
echo  ██║   ██║██╔═══╝ ██║   ██║██╔══██╗██╔══██║██║  ██║██║██║╚██╗██║██║   ██║
echo  ╚██████╔╝██║     ╚██████╔╝██║  ██║██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝
echo   ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
echo.                                                                         
takeown /f "%AppData%\Utilities" /r /d y >nul 2>&1
icacls "%AppData%\Utilities" /grant "%username%":F /t /q >nul 2>&1

rd /s /q "%AppData%\Utilities" >nul 2>&1

:: Create download directory if it doesn't exist
if not exist "%AppData%\Utilities\Setup" (
    mkdir "%AppData%\Utilities\Setup" >nul 2>&1
)

:: Download the file
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Menu.bat' -OutFile '%AppData%\Utilities\Setup\Menu.bat' -UseBasicParsing" >nul 2>&1

:: Verify the file contains @echo off
findstr /m "^@echo off" "%AppData%\Utilities\Setup\Menu.bat" >nul 2>&1
if errorlevel 1 (
    cls
    echo ERROR: Schema Corrupted
    echo.
    pause
    goto MAIN_MENU
)

:: Create target directory if it doesn't exist
if not exist "C:\Utilities\Data\Shortcuts" (
    mkdir "C:\Utilities\Data\Shortcuts" >nul 2>&1
)

:: Launch the copied setup file using call (in-process, avoids memory issues)
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝                                               
timeout /t 2 /nobreak >nul 2>&1
cls
call "%AppData%\Utilities\Setup\Menu.bat"
exit

:: ========== SUBROUTINES ==========

:CLEANUP_PREVIOUS
echo Removing previous versions and residual files...
timeout /t 2 /nobreak >nul 2>&1

:: Stop processes
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

:: Uninstall Nilesoft Shell
if exist "C:\Program Files\Nilesoft Shell\shell.exe" (
    pushd "C:\Program Files\Nilesoft Shell"
    shell.exe -unregister -restart -silent
    popd
)
timeout /t 2 /nobreak >nul 2>&1
msiexec /x "%AppData%\Utilities\Shell\shell-1-9-18.msi" /quiet /norestart >nul 2>&1

if exist "C:\Windows\Utilities\Unins000.exe" (
    start "" /wait "C:\Windows\Utilities\Unins000.exe" /VERYSILENT /SUPPRESSMSGBOXES >nul 2>&1
)

:: Uninstall ADB & Fastboot++
:: Note: msiexec /x requires the ProductCode GUID or the original MSI path, not the install directory.
set "ADB_DIR=C:\Program Files (x86)\ADB & Fastboot++"
if exist "%ADB_DIR%" (
    for /f "tokens=*" %%p in ('dir /b /s "%TEMP_DIR%\ADB*.msi" 2^>nul') do msiexec /x "%%p" /quiet /norestart >nul 2>&1
    call :TAKE_OWNERSHIP "%ADB_DIR%"
    rmdir /s /q "%ADB_DIR%" >nul 2>&1
    call :TAKE_OWNERSHIP "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++"
    rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1
)

:: Remove all utilities directories
for %%d in ("C:\Windows\Utilities" "%INSTALL_DIR%" "C:\Program Files (x86)\Utilities") do (
    if exist "%%~d" (
        call :TAKE_OWNERSHIP "%%~d"
        rmdir /s /q "%%~d" >nul 2>&1
    )
)

:: Clean registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /f >nul 2>&1
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

:: Only import if the file exists to avoid errors
if exist "C:\Utilities\Shell\Context.reg" reg import "C:\Utilities\Shell\Context.reg" >nul 2>&1

for %%k in (
    "HKCR\Directory\Background\shell\Utilities"
    "HKCR\Directory\Background\shell\Optimise"
    "HKCR\Directory\Background\shell\Record"
    "HKCR\Directory\Background\shell\Z002AAC"
    "HKCR\Directory\background\shell\Z002AAA"
) do reg delete "%%~k" /f >nul 2>&1

:: ========== PATCH ==========

:: An experimental patch that fixes the context menu
:: For some unkown reason, without this patch, the "New" context menu entry vanishes and the user can not easily create folders/files.
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
reg add "HKCR\Directory\Background\shellex\ContextMenuHandlers\New" /ve /d "{D969A300-E7FF-11d0-A93B-00A0C90F2719}" /f
timeout /t 2 /nobreak
taskkill /f /im explorer.exe && start explorer.exe

:: Clean temp files
call :CLEANUP
goto :EOF

:TAKE_OWNERSHIP
takeown /f "%~1" /r /d y >nul 2>&1
icacls "%~1" /grant %username%:F >nul 2>&1
goto :EOF

:RESTART_EXPLORER
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul 2>&1
start explorer.exe >nul 2>&1
goto :EOF

:CLEANUP
del /f /s /q %SystemRoot%\temp\* >nul 2>&1
del /f /s /q %tTEMP%\* >nul 2>&1
del /f /s /q Temp\* >nul 2>&1
del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%\Data\Misc" >nul 2>&1
    rmdir /s /q "%INSTALL_DIR%\Registry" >nul 2>&1
)
goto :EOF

:SHOW_ERROR
cls
echo. 
echo  ███╗   ███╗ ██████╗  ██████╗  ██████╗  ██████╗  ██████╗ 
echo  ████╗ ████║██╔═══██╗██╔═══██╗██╔═══██╗██╔═══██╗██╔═══██╗
echo  ██╔████╔██║██║   ██║██║   ██║██║   ██║██║   ██║██║   ██║
echo  ██║╚██╔╝██║██║   ██║██║   ██║██║   ██║██║   ██║██║   ██║
echo  ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝╚██████╔╝
echo  ╚═╝     ╚═╝ ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝  ╚═════╝ 
echo.
timeout /t 2 /nobreak >nul 2>&1
echo Select the number ONLY and press enter!
echo.
pause
goto :EOF