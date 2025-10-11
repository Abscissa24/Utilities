@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
:: mode con: cols=62 lines=20

:: Check for admin rights
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process '%~s0' -Verb runAs"
    exit /b
)

set "UTILITIES_URL=https://github.com/Abscissa24/Utilities/raw/main"
set "TEMP_DIR=%SystemRoot%\Temp"
set "INSTALL_DIR=C:\Utilities"

:: Prompt for GUI switch
cls
if exist "C:\Utilities\Uninstall\Unins000.exe" goto GUI_DETECTED
if not exist "C:\Utilities\Uninstall\Unins000.exe" goto PRE_CONFIG

:GUI_DETECTED
    cls
    echo WARNING: GUI Version detected!
    echo.
    set /p choice=Abort CLI version and migrate to GUI channel? (Y/N): 

    if /i "%choice%"=="Y" goto DEV_GUI
    if /i "%choice%"=="N" goto PRE_CONFIG

    :: Invalid choice
    call :SHOW_ERROR
    goto MAIN_MENU

:PRE_CONFIG
:: Ensure required directories exist
if not exist "%AppData%\Utilities\Setup" md "%AppData%\Utilities\Setup"
if not exist "%AppData%\Utilities\Shell" md "%AppData%\Utilities\Shell"

:: Remove deprecated figlet if present
if exist "%AppData%\Utilities\Figlet\figlet.exe" (
    cls
    del /f /q "%AppData%\Utilities\Figlet\figlet.exe"
)

:: Download Setup.bat if missing
if not exist "%AppData%\Utilities\Setup\Setup.bat" (
    title Configuring
    cls
    echo Fetching Resource: setup_plugin
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%AppData%\Utilities\Setup\Setup.bat' -UseBasicParsing" >nul 2>&1
)

:: Download support.ico if missing
if not exist "%AppData%\Utilities\Shell\support.ico" (
    title Configuring
    cls
    echo Fetching Resource: support_plugin
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/support.ico' -OutFile '%AppData%\Utilities\Shell\support.ico' -UseBasicParsing" >nul 2>&1
)

:: All resources ready, proceed to main menu
cls
goto MAIN_MENU

:MAIN_MENU
cls
title Utilities
COLOR 0B
echo. 
echo  ██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗███████╗███████╗
echo  ██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝██║██╔════╝██╔════╝
echo  ██║   ██║   ██║   ██║██║     ██║   ██║   ██║█████╗  ███████╗
echo  ██║   ██║   ██║   ██║██║     ██║   ██║   ██║██╔══╝  ╚════██║
echo  ╚██████╔╝   ██║   ██║███████╗██║   ██║   ██║███████╗███████║
echo   ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝   ╚═╝╚══════╝╚══════╝
echo. 

if not exist "C:\Utilities" goto MAIN_MENU_OPTIONS
if exist "C:\Utilities" goto MAIN_MENU_OPTIONS_ALT
::Main menu

:MAIN_MENU_OPTIONS

echo 1) Installation
echo 2) GitHub Homepage
echo 3) Configurations
echo 4) Upgrade Installer
echo. 
echo 5) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto INSTALL_MENU
if "%choice%"=="2" goto GITHUB_LAUNCH
if "%choice%"=="3" goto CONFIGURE
if "%choice%"=="4" goto UPGRADE
if "%choice%"=="5" goto END

::Easter egg
if /i "%choice%"=="TYRA" goto TURTLE
if /i "%choice%"=="dev_menu" goto DEV_MENU
if /i "%choice%"=="dev_gui" goto DEV_GUI
if /i "%choice%"=="info" goto DEV_INFO
if /i "%choice%"=="dev_info" goto DEV_INFO
if /i "%choice%"=="MAWZES" goto MAWZES
if /i "%choice%"=="purge" goto PURGE
if /i "%choice%"=="watermark" goto END

:: Invalid choice
call :SHOW_ERROR
goto MAIN_MENU
)

:MAIN_MENU_OPTIONS_ALT

echo 1) Manage Utilities
echo 2) GitHub Homepage
echo 3) Configurations
echo 4) Upgrade Installer
echo. 
echo 5) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto MANAGE_MENU
if "%choice%"=="2" goto GITHUB_LAUNCH
if "%choice%"=="3" goto CONFIGURE
if "%choice%"=="4" goto UPGRADE
if "%choice%"=="5" goto END

::Easter egg
if /i "%choice%"=="TYRA" goto TURTLE
if /i "%choice%"=="dev_menu" goto DEV_MENU
if /i "%choice%"=="dev_gui" goto DEV_GUI
if /i "%choice%"=="dev_info" goto DEV_INFO
if /i "%choice%"=="info" goto DEV_INFO
if /i "%choice%"=="MAWZES" goto MAWZES
if /i "%choice%"=="purge" goto PURGE
if /i "%choice%"=="watermark" goto END

:: Invalid choice
call :SHOW_ERROR
goto MAIN_MENU
)

:PURGE
shutdown /r /f /t 0 /c "" >nul 2>&1

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
COLOR 0E
echo. 
echo  ███████╗██╗  ██╗██████╗ ███████╗██████╗ ██╗███╗   ███╗███████╗███╗   ██╗████████╗ █████╗ ██╗     
echo  ██╔════╝╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██║     
echo  █████╗   ╚███╔╝ ██████╔╝█████╗  ██████╔╝██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████║██║     
echo  ██╔══╝   ██╔██╗ ██╔═══╝ ██╔══╝  ██╔══██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██║██║     
echo  ███████╗██╔╝ ██╗██║     ███████╗██║  ██║██║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ██║  ██║███████╗
echo  ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
echo.   

if not exist "C:\Utilities\Scripts\Experimental" goto EXP1
if exist "C:\Utilities\Scripts\Experimental" goto EXP2

:EXP1
                                                                                             
echo 1) Install Features
echo. 
echo 2) Back to Manager
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto INSTALL_EXPERIMENTAL
if "%choice%"=="2" goto MANAGE_MENU

call :SHOW_ERROR
goto MANAGE_EXPERIMENTAL

:EXP2

echo 1) Uninstall Features
echo 2) Reinstall Features
echo. 
echo 3) Back to Manager
echo.
set /p choice=Select an option: 

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
echo. 
echo 3) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto POINT
if "%choice%"=="2" goto VERSION_X_MENU
if "%choice%"=="3" goto INSTALL_MENU
call :SHOW_ERROR
goto INSTALL_ARCHIVED_VERSIONS

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
echo 1) September 2025
echo 2) August 2025
echo 3) June 2025
echo 4) May 2025
echo 5) April 2025
echo 6) March 2025
echo. 
echo 7) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto VERSION_X_SEPTEMBER
if "%choice%"=="2" goto VERSION_X_AUGUST
if "%choice%"=="3" goto VERSION_X_JUNE
if "%choice%"=="4" goto VERSION_X_MAY
if "%choice%"=="5" goto VERSION_X_APRIL
if "%choice%"=="6" goto VERSION_X_MARCH
if "%choice%"=="7" goto INSTALL_ARCHIVED_VERSIONS
call :SHOW_ERROR
goto VERSION_X_MENU

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
echo 1) 10 June 2025
echo. 
echo 2) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=10062025" && goto INSTALL_ARCHIVE_X
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

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1

robocopy "C:\Utilities\Data\Speedtest" "%AppData%\Ookla\Speedtest CLI" "speedtest-cli.ini" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0 >nul 2>&1
robocopy "C:\Utilities\Data\Shortcuts" "%AppData%\Utilities\Shortcuts" *.lnk /S /ZB /COPYALL /R:1 /W:1 >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /t REG_SZ /d "C:\\Utilities\\Shell\\support.ico" /f >nul 2>&1

setx /M PATH "!PATH!;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1
setx /M PATH "!PATH!;%AppData%\Utilities\Setup" >nul 2>&1

call :CLEANUP >nul 2>&1
cls
echo. 
echo  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
echo  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
echo  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
echo  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
echo  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo.                                                          
echo Please read the documentation carefully!
timeout /t 2 /nobreak >nul 2>&1

start C:\Utilities\Info\Stable.pdf"
goto MAIN_MENU

:INSTALL_EXPERIMENTAL
COLOR 06
cls
echo. 
echo  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗ 
echo  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝ 
echo  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗
echo  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║
echo  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝
echo  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
echo. 

if exist "C:\Utilities" (

echo. 
call "C:\Utilities\Data\Shortcuts\Para2.bat"

)

if not exist "C:\Utilities" (

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1

robocopy "C:\Utilities\Data\Speedtest" "%AppData%\Ookla\Speedtest CLI" "speedtest-cli.ini" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0
robocopy "C:\Utilities\Data\Shortcuts" "%AppData%\Utilities\Shortcuts" *.lnk /S /ZB /COPYALL /R:1 /W:1

regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /t REG_SZ /d "C:\\Utilities\\Shell\\support.ico" /f

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/download/v1.1.2/uad-ng-windows.exe' -OutFile 'C:\Utilities\Data\ADB\uad-ng-windows.exe' -UseBasicParsing" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.3.2/scrcpy-win64-v3.3.2.zip -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\scrcpy-win64-v3.3.2.zip' -DestinationPath '%INSTALL_DIR%\Data\Record' -Force" >nul 2>&1

:: Install additional experimental components
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi' -OutFile '%TEMP_DIR%\UniversalAdbDriverSetup.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\UniversalAdbDriverSetup.msi" /qn /norestart /passive >nul 2>&1

setx /M PATH "!PATH!;%INSTALL_DIR%\Data\ADB" >nul 2>&1
setx /M PATH "!PATH!;%AppData%\Utilities\Setup" >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Experimental-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
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
echo  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
echo.   
echo Please read the documentation carefully!
timeout /t 2 /nobreak >nul 2>&1

start C:\Utilities\Info\Experimental.pdf"
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
COLOR 0C
cls
echo Removing from shell

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC\shell\Z007ACD" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\background\shell\Z002AAC\shell\Z007ACE" /f >nul 2>&1

takeown /f "%INSTALL_DIR%\Scripts\Experimental" /r /d y >nul 2>&1
icacls "%INSTALL_DIR%\Scripts\Experimental" /grant %username%:F >nul 2>&1
rmdir /s /q "%INSTALL_DIR%\Scripts\Experimental" >nul 2>&1
rmdir /s /q "%INSTALL_DIR%\Data\Record" >nul 2>&1
del /f /q "%INSTALL_DIR%\Info\Experimental.pdf" >nul 2>&1

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

goto MAIN_MENU

:UNINSTALL_ALL
COLOR 0C
cls
echo Uninstalling
call :CLEANUP_PREVIOUS >nul 2>&1
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

start explorer.exe
goto MAIN_MENU

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

:TURTLE
cls
echo. 
echo  ██▓    ██▓     ▒█████   ██▒   █▓▓█████    ▓██   ██▓ ▒█████   █    ██  ▐██▌ 
echo ▓██▒   ▓██▒    ▒██▒  ██▒▓██░   █▒▓█   ▀     ▒██  ██▒▒██▒  ██▒ ██  ▓██▒ ▐██▌ 
echo ▒██▒   ▒██░    ▒██░  ██▒ ▓██  █▒░▒███        ▒██ ██░▒██░  ██▒▓██  ▒██░ ▐██▌ 
echo ░██░   ▒██░    ▒██   ██░  ▒██ █░░▒▓█  ▄      ░ ▐██▓░▒██   ██░▓▓█  ░██░ ▓██▒ 
echo ░██░   ░██████▒░ ████▓▒░   ▒▀█░  ░▒████▒     ░ ██▒▓░░ ████▓▒░▒▒█████▓  ▒▄▄  
echo ░▓     ░ ▒░▓  ░░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░      ██▒▒▒ ░ ▒░▒░▒░ ░▒▓▒ ▒ ▒  ░▀▀▒ 
echo  ▒ ░   ░ ░ ▒  ░  ░ ▒ ▒░    ░ ░░   ░ ░  ░    ▓██ ░▒░   ░ ▒ ▒░ ░░▒░ ░ ░  ░  ░ 
echo  ▒ ░     ░ ░   ░ ░ ░ ▒       ░░     ░       ▒ ▒ ░░  ░ ░ ░ ▒   ░░░ ░ ░     ░ 
echo  ░         ░  ░    ░ ░        ░     ░  ░    ░ ░         ░ ░     ░      ░    
echo                              ░              ░ ░                             
echo. 
pause >nul 2>&1
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
if "%choice%"=="6" goto MAIN_MENU

:: Invalid choice
call :SHOW_ERROR
goto DEV_MENU

:SWITCH_TO_LEGACY_SHORTCUTS
:: Ensure shortcuts folder exists first
if not exist "C:\Utilities\Data\Shortcuts" (
    cls
    echo No Installed Scheme!
    echo.
    pause
    goto DEV_MENU
)

cls
:: Use choice to get a clean Y/N answer without parsing oddities
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
echo [BETA] Fetching latest GUI
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/GUI/Utilities.exe' -OutFile '%USERPROFILE%\Desktop\Utilities.exe' -UseBasicParsing" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

cls
start "" "%USERPROFILE%\Desktop\Utilities.exe"
goto MAIN_MENU

:DEV_INFO
cls 
echo. 
echo  ██╗███╗   ██╗███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
echo  ██║████╗  ██║██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
echo  ██║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██╔████╔██║███████║   ██║   ██║██║   ██║██╔██╗ ██║
echo  ██║██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
echo  ██║██║ ╚████║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
echo  ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
echo.  
                                                                                      
echo Setup Version: 10.25092025
echo Code Name: Project Zen
if exist "C:/Utilities/Uninstall/Unins000.exe" (
echo GUI Found: TRUE)
if not exist "C:/Utilities/Uninstall/Unins000.exe" (
echo GUI Found: FALSE [Running CLI Version-X])
echo. 
echo Build Date: 25th September 2025
echo Developer: Armiel Pillay
echo Alias: Abscissa24
echo GitHub: https://github.com/Abscissa24/Utilities
echo. 
if exist "C:/Utilities/Scripts" (
echo Utilities Size-On-Disk: 16.3MB [Installed])
if not exist "C:/Utilities" (
echo Utilities Size-On-Disk: 0MB [NOT INSTALLED])
if exist "C:/Utilities/Uninstall/Unins000.exe" (
echo. 
echo EXE Wrapper Version: 3.0.0.0)
echo. 
echo GIT Health: Excellent
echo Package Health: Excellent
echo Commit Rate: Fair
echo Repository Size: 230.8MB
echo. 
pause 
goto MAIN_MENU
)

:MAWZES
cls
echo. 
echo  ███▄ ▄███▓ ▄▄▄       █     █░▒███████▒▓█████   ██████ 
echo ▓██▒▀█▀ ██▒▒████▄    ▓█░ █ ░█░▒ ▒ ▒ ▄▀░▓█   ▀ ▒██    ▒ 
echo ▓██    ▓██░▒██  ▀█▄  ▒█░ █ ░█ ░ ▒ ▄▀▒░ ▒███   ░ ▓██▄   
echo ▒██    ▒██ ░██▄▄▄▄██ ░█░ █ ░█   ▄▀▒   ░▒▓█  ▄   ▒   ██▒
echo ▒██▒   ░██▒ ▓█   ▓██▒░░██▒██▓ ▒███████▒░▒████▒▒██████▒▒
echo ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▓░▒ ▒  ░▒▒ ▓░▒░▒░░ ▒░ ░▒ ▒▓▒ ▒ ░
echo ░  ░      ░  ▒   ▒▒ ░  ▒ ░ ░  ░░▒ ▒ ░ ▒ ░ ░  ░░ ░▒  ░ ░
echo ░      ░     ░   ▒     ░   ░  ░ ░ ░ ░ ░   ░   ░  ░  ░  
echo        ░         ░  ░    ░      ░ ░       ░  ░      ░  
echo                               ░                                                                                 
echo. 
echo 1) Configure System
echo 2) Inject MAWZES Theme
echo 3) Remove all patches
echo.
echo 4) [BETA] Install Benchmarking Software
echo 5) [BETA] Install Requested Software [CRACKED]
echo.
echo 6) Main Menu

echo.
set /p choice=Select an option:

if "%choice%"=="1" goto MAWZES_CONFIGURE
if "%choice%"=="2" goto MAWZES_THEME
if "%choice%"=="3" goto MAWZES_UNINSTALL
if "%choice%"=="4" goto MAWZES_BENCHMARK
if "%choice%"=="5" goto MAWZES_SOFTWARE
if "%choice%"=="6" goto MAIN_MENU

:: Invalid choice
call :SHOW_ERROR
goto MAWZES

:MAWZES_THEME

cls
regsvr32 /u /s "C:\Windows\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1

regsvr32 /u /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1

cd /d %USERPROFILE%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
del /q /f /s "%localappdata%\Microsoft\Windows\Themes\*.*" && rmdir /s /q "%localappdata%\Microsoft\Windows\Themes\" >nul 2>&1
cls
taskkill /f /im explorer.exe >nul 2>&1
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
timeout /t 2 /nobreak >nul 2>&1

:: Reset theme
start "" "C:\Windows\Resources\Themes\aero.theme" >nul 2>&1

    cls
    echo Syncing Theme Repository: Mawzes

    echo. 
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Mawzes.zip' -OutFile '%TEMP%\Mawzes.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Mawzes.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
    timeout /t 2 /nobreak >nul 2>&1

)
    cls
    echo Applying Custom Theme: Mawzes
    timeout /t 2 /nobreak >nul 2>&1

    cd /d %userprofile%\AppData\Local >nul 2>&1
    del IconCache.db /a >nul 2>&1

    timeout /t 1 /nobreak >nul 2>&1

    regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
    cls

    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Mawzes\Icons\folder.ico,0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Mawzes\Icons\folder.ico,0" /f >nul 2>&1

    taskkill /IM explorer.exe /F >nul 2>&1
    timeout /t 1 /nobreak >nul 2>&1

    start explorer.exe >nul 2>&1
    timeout /t 2 /nobreak >nul 2>&1

    start "" "%AppData%\Utilities\Themes\Mawzes\Mawzes.theme" >nul 2>&1
)
call :CLEANUP >nul 2>&1

goto MAWZES

:MAWZES_CONFIGURE
cls
echo. 
echo  ██╗███╗   ███╗██████╗ 
echo  ██║████╗ ████║██╔══██╗
echo  ██║██╔████╔██║██████╔╝
echo  ██║██║╚██╔╝██║██╔══██╗
echo  ██║██║ ╚═╝ ██║██║  ██║
echo  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
echo.                      

call :ACTIVATE_WINDOWS >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/GUI/Utilities.exe' -OutFile '%USERPROFILE%\Desktop\Utilities.exe' -UseBasicParsing" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

cls
start "" "%USERPROFILE%\Desktop\Utilities.exe"

echo Installing Windhawk...
echo. 
winget install --id=RamenSoftware.Windhawk --silent --accept-package-agreements --accept-source-agreements
cls
echo Installing WinToys...
echo. 
winget install --id=9P8LTPGCBZXD --silent --accept-package-agreements --accept-source-agreements
cls
echo Installing StartAllBack...
echo. 
winget install --id=StartIsBack.StartAllBack --silent --accept-package-agreements --accept-source-agreements
cls

if not exist "%AppData%\Utilities\Themes" (

    cls
echo Syncing Theme Repository: Mawzes

    echo. 
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Mawzes.zip' -OutFile '%TEMP%\Themes\Mawzes.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Mawzes.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
    timeout /t 2 /nobreak >nul 2>&1

)
    cls
    echo Applying Custom Theme: Mawzes
    timeout /t 2 /nobreak >nul 2>&1

    cd /d %userprofile%\AppData\Local >nul 2>&1
    del IconCache.db /a >nul 2>&1

    timeout /t 1 /nobreak >nul 2>&1

    regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
    cls

    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Mawzes\Icons\folder.ico,0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Mawzes\Icons\folder.ico,0" /f >nul 2>&1

    taskkill /IM explorer.exe /F >nul 2>&1
    timeout /t 1 /nobreak >nul 2>&1

    start explorer.exe >nul 2>&1
    timeout /t 2 /nobreak >nul 2>&1

    start "" "%AppData%\Utilities\Themes\Mawzes\Mawzes.theme" >nul 2>&1
)
call :CLEANUP >nul 2>&1

goto MAWZES

:MAWZES_BENCHMARK

echo Installing GPU-Z...
echo. 
winget install --id=TechPowerUp.GPU-Z --silent --accept-package-agreements --accept-source-agreements
cls
echo Installing CPU-Z...
echo. 
winget install --id=CPUID.CPU-Z --silent --accept-package-agreements --accept-source-agreements
cls
echo Installing CrystalDiskMark...
echo. 
winget install --id=CrystalDewWorld.CrystalDiskMark --silent --accept-package-agreements --accept-source-agreements
cls
echo Installing Cinebench...
echo. 
winget install --id=Maxon.CinebenchR23 --silent --accept-package-agreements --accept-source-agreements
cls

goto MAWZES

:MAWZES_UNINSTALL
if exist "C:\Utilities\Uninstall\unins000.exe" (
start "" "C:\Utilities\Uninstall\unins000.exe" >nul 2>&1
)
winget uninstall --id=Nilesoft.Shell >nul 2>&1
winget uninstall --id=StartIsBack.StartAllBack >nul 2>&1
call :UNINSTALL_ALL
timeout /t 2 /nobreak >nul 2>&1
call :REVERT

goto MAWZES

:MAWZES_SOFTWARE
cls
if exist "%USERPROFILE%\Downloads\Resources\autoplay.exe" goto INSTALL_ADOBE
if not exist "%USERPROFILE%\Downloads\Resources.zip" goto FETCH_ADOBE
if exist "%USERPROFILE%\Downloads\Resources.zip" goto EXTRACT_ADOBE

:FETCH_ADOBE
cls
echo Fetching Resources - 2.80GB
echo.
start https://store-na-phx-2.gofile.io/download/web/44c61ece-bc14-4cb3-9387-9758cdab102e/Resources.zip
echo. 
echo After the download is complete
pause
if exist "%USERPROFILE%\Downloads\Resources.zip" (
cls
echo Resources Detected
echo.
powershell -Command "Expand-Archive -Path '%USERPROFILE%\Downloads\Resources.zip' -DestinationPath '%USERPROFILE%\Downloads\Resources' -Force" >nul 2>&1
cls
echo Installing
start "" "%USERPROFILE%\Downloads\Resources\autoplay.exe"
echo. 
pause)
if not exist "%USERPROFILE%\Downloads\Resources.zip" goto RESOURCE_CHECK

:RESOURCE_CHECK
cls 
echo ERROR: Resources not found!
echo. 
echo If Resources.zip downloaded successfully, copy/move it to your downloads folder!
echo Then, run the script again. It will automatically search for the resources
echo You can execute the above task directly from this menu. PRESS R
echo. 
echo However, if the Resources.zip is corrupted, or did not download successfully - PRESS Y
echo This will remove corrupted files and ATTEMPT to download and install again!
echo. 
echo Alternatively, PRESS N to remove corrupted files and EXIT without retrying to download
echo. 
echo If you are getting the error: "docContent not found in DB"
echo It means that Resources.zip is no longer in the database! 
echo You can just message me and I will restore the .db archive to include it :)
echo. 
echo Yes, I did account for everything :)
echo. 
set /p choice=Select an option:

if "%choice%"=="R" goto EXTRACT_ADOBE
if "%choice%"=="r" goto EXTRACT_ADOBE
if "%choice%"=="Y" goto ADOBE_FALLBACK
if "%choice%"=="y" goto ADOBE_FALLBACK
if "%choice%"=="N" goto ADOBE_FALLBACK_1
if "%choice%"=="n" goto ADOBE_FALLBACK_1

:: Invalid choice
call :SHOW_ERROR
goto MAWZES
)
goto MAWZES

:ADOBE_FALLBACK
cls
echo Running redundancy profile
timeout /t 2 /nobreak >nul 2>&1

echo. 
del "%USERPROFILE%\Downloads\Resources.zip"
rmdir /s /q "%USERPROFILE%\Downloads\Resources"
goto FETCH_ADOBE

:ADOBE_FALLBACK_1
cls
del "%USERPROFILE%\Downloads\Resources.zip"
rmdir /s /q "%USERPROFILE%\Downloads\Resources"
goto MAWZES

:EXTRACT_ADOBE
cls
if not exist "%USERPROFILE%\Downloads\Resources.zip" (
echo ERROR: Resources not found
timeout /t 2 /nobreak >nul 2>&1

goto RESOURCE_CHECK)

if exist "%USERPROFILE%\Downloads\Resources.zip" (
echo Resources Detected
echo. 
powershell -Command "Expand-Archive -Path '%USERPROFILE%\Downloads\Resources.zip' -DestinationPath '%USERPROFILE%\Downloads\Resources' -Force" >nul 2>&1
cls
echo Installing
start "" "%USERPROFILE%\Downloads\Resources\autoplay.exe"
echo. 
pause
goto MAWZES
)

:INSTALL_ADOBE
cls
echo Installing
start "" "%USERPROFILE%\Downloads\Resources\autoplay.exe"
echo. 
pause
goto MAWZES

:DEV_MAKE_REPO
cls

:: Set temp paths
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
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%USERPROFILE%\Desktop\GitHub Development\Setup.bat' -UseBasicParsing" >nul 2>&1
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
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%USERPROFILE%\Desktop\GitHub Development\Setup.bat' -UseBasicParsing" >nul 2>&1
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
echo 2) Applications
echo 3) Microsoft Office
echo 4) Activate Windows
echo. 
echo 5) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto CONFIGURE_THEMES
if "%choice%"=="2" goto CONFIGURE_APPS
if "%choice%"=="3" goto CONFIGURE_OFFICE
if "%choice%"=="4" goto ACTIVATE_WINDOWS
if "%choice%"=="5" goto MAIN_MENU
call :SHOW_ERROR

:CONFIGURE_THEMES

if not exist "%AppData%\Utilities\Themes" (

    cls
echo Syncing Theme Repository

    echo. 
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/SamuraiCatto.zip.zip' -OutFile '%TEMP%\SamuraiCatto.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Samurai.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Mawzes.zip' -OutFile '%TEMP%\Mawzes.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Mawzes.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/BubuDudu.zip' -OutFile '%TEMP%\BubuDudu.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\BubuDudu.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/Abstract.zip' -OutFile '%TEMP%\Abstract.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Abstract.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes/PrettyPink.zip' -OutFile '%TEMP%\PrettyPink.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\PrettyPink.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

:THEMES
echo. 
echo ▄▄▄█████▓ ██░ ██ ▓█████  ███▄ ▄███▓▓█████   ██████ 
echo ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀ ▓██▒▀█▀ ██▒▓█   ▀ ▒██    ▒ 
echo ▒ ▓██░ ▒░▒██▀▀██░▒███   ▓██    ▓██░▒███   ░ ▓██▄   
echo ░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄ ▒██    ▒██ ▒▓█  ▄   ▒   ██▒
echo   ▒██▒ ░ ░▓█▒░██▓░▒████▒▒██▒   ░██▒░▒████▒▒██████▒▒
echo   ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░░ ▒░   ░  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
echo     ░     ▒ ░▒░ ░ ░ ░  ░░  ░      ░ ░ ░  ░░ ░▒  ░ ░
echo   ░       ░  ░░ ░   ░   ░      ░      ░   ░  ░  ░  
echo           ░  ░  ░   ░  ░       ░      ░  ░      ░  
echo.  
echo. 
echo. 
echo 1) Abstract
echo 2) Pretty Pink
echo 3) Bubu and Dudu
echo 4) Samurai Catto
echo. 
echo 5) Options
echo 6) Back
echo. 
set /p choice=Select an option: 

if "%choice%"=="1" goto ABSTRACT
if "%choice%"=="2" goto PINK
if "%choice%"=="3" goto BUBU_DUDU
if "%choice%"=="4" goto SAMURAI_CATTO
if "%choice%"=="5" goto OPTIONS

if "%choice%"=="6" goto CONFIGURE
call :SHOW_ERROR

:SAMURAI_CATTO

cls

echo In progress
timeout /t 2 /nobreak >nul 2>&1

goto THEMES

:PINK

cls
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

:BUBU_DUDU

cls
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

start "" "%AppData%\Utilities\Themes\Bubu\BubuDudu.theme" >nul 2>&1

goto THEMES

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
echo 1) Remove explorer blur
echo 2) Revert to default theme
echo. 
echo 3) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto MICA_GONE
if "%choice%"=="2" goto REVERT
if "%choice%"=="3" goto CONFIGURE_THEMES

:ABSTRACT

cls
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

:MICA_GONE
cls
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

regsvr32 /u /s "C:\Windows\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1

regsvr32 /u /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll"
timeout /t 1 /nobreak >nul 2>&1

start explorer.exe >nul 2>&1

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
timeout /t 2 /nobreak >nul 2>&1

:: Reset theme
start "" "C:\Windows\Resources\Themes\aero.theme" >nul 2>&1

goto OPTIONS

:CONFIGURE_APPS

where winget >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo Winget not found. Installing/updating App Installer...
    cls
    powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile '$env:TEMP\AppInstaller.appxbundle'"
    cls
    timeout /t 2 /nobreak >nul
    cls
    powershell -Command "Add-AppxPackage -Path '$env:TEMP\AppInstaller.appxbundle' -ForceApplicationShutdown -ErrorAction SilentlyContinue"
    cls
    timeout /t 5 /nobreak >nul
)

winget install --id=RamenSoftware.Windhawk -e --silent --accept-package-agreements --accept-source-agreements
winget install --id=Starpine.Screenbox -e --silent --accept-package-agreements --accept-source-agreements
winget install --id=9NKSQGP7F2NH -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9WZDNCRFHVN5 -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9P8LTPGCBZXD -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9PFD136M8457 -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9NMPJ99VJBWV -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9PG9N9FTR590 -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9PLJWWSV01LK -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9N97ZCKPD60Q -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=9NRX63209R7B -h --silent --accept-package-agreements --accept-source-agreements 
winget install --id=XPFFTQ032PTPHF -h --silent --accept-package-agreements --accept-source-agreements
winget install --id=VSCodium.VSCodium -e --silent --accept-package-agreements --accept-source-agreements
winget install --id=OBSProject.OBSStudio -e --silent --accept-package-agreements --accept-source-agreements
winget install --id=StartIsBack.StartAllBack -e --silent --accept-package-agreements --accept-source-agreements

del "%TEMP%\AppInstaller.appxbundle" >nul 2>&1
timeout /t 2 /nobreak >nul

cls
echo Applications Configured!
timeout /t 2 /nobreak >nul 2>&1

goto CONFIGURE

:CONFIGURE_OFFICE
cls

if exist "C:\Program Files\Microsoft Office" (

    cls Microsoft Office: Installation Found!
    timeout /t 2 /nobreak >nul 2>&1

    cls
    echo Updating Activation
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
)

if not exist "C:\Program Files\Microsoft Office" (

COLOR 0A
cls
echo Installing Office

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
)

:ACTIVATE_WINDOWS
cls
echo Activating
cls
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /HWID }"
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
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%AppData%\Utilities\Setup\Setup.bat' -UseBasicParsing" >nul 2>&1

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

:: ========== SUBROUTINES ==========

:CLEANUP_PREVIOUS
echo Removing previous versions and residual files
timeout /t 2 /nobreak >nul 2>&1


:: Stop processes
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

:: Uninstall Nilesoft Shell
cd C:\Program Files\Nilesoft Shell
shell.exe -unregister -restart -silent
timeout /t 2 /nobreak >nul 2>&1

msiexec /x "%AppData%\Utilities\Shell\shell-1-9-18.msi" /quiet

if exist "C:\Windows\Utilities\Unins000.exe" (

start "C:\Windows\Utilities\Unins000.exe" >nul 2>&1
)

:: Uninstall ADB & Fastboot++
set "ADB_DIR=C:\Program Files (x86)\ADB & Fastboot++"
if exist "%ADB_DIR%" (
    msiexec /x "%ADB_DIR%" /quiet >nul 2>&1
    call :TAKE_OWNERSHIP "%ADB_DIR%"
    rmdir /s /q "%ADB_DIR%" >nul 2>&1
    call :TAKE_OWNERSHIP "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++"
    rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1
)

:: Remove all utilities directories
for %%d in (
    "C:\Windows\Utilities"
    "%INSTALL_DIR%"
    "C:\Program Files (x86)\Utilities"
) do if exist %%d (
    call :TAKE_OWNERSHIP "%%d"
    rmdir /s /q "%%d" >nul 2>&1
)

:: Clean registry

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /f
reg delete "HKLM\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
reg import "C:\Utilities\Shell\Context.reg" >nul 2>&1

for %%k in (
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Record"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC"
    "HKEY_CLASSES_ROOT\Directory\background\shell\Z002AAA"
) do reg delete "%%k" /f >nul 2>&1

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
echo  ███▄ ▄███▓ ▒█████   ▒█████  
echo ▓██▒▀█▀ ██▒▒██▒  ██▒▒██▒  ██▒
echo ▓██    ▓██░▒██░  ██▒▒██░  ██▒
echo ▒██    ▒██ ▒██   ██░▒██   ██░
echo ▒██▒   ░██▒░ ████▓▒░░ ████▓▒░
echo ░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░▒░▒░ 
echo ░  ░      ░  ░ ▒ ▒░   ░ ▒ ▒░ 
echo ░      ░   ░ ░ ░ ▒  ░ ░ ░ ▒  
echo        ░       ░ ░      ░ ░  
                             
timeout /t 2 /nobreak >nul 2>&1

echo.
echo Select the number ONLY and press enter!
echo.
pause
goto :EOF

:END
call :CLEANUP
cls
echo. 
echo    ▄████████ ▀█████████▄     ▄████████  ▄████████  ▄█     ▄████████    ▄████████    ▄████████ 
echo   ███    ███   ███    ███   ███    ███ ███    ███ ███    ███    ███   ███    ███   ███    ███ 
echo   ███    ███   ███    ███   ███    █▀  ███    █▀  ███▌   ███    █▀    ███    █▀    ███    ███ 
echo   ███    ███  ▄███▄▄▄██▀    ███        ███        ███▌   ███          ███          ███    ███ 
echo ▀███████████ ▀▀███▀▀▀██▄  ▀███████████ ███        ███▌ ▀███████████ ▀███████████ ▀███████████ 
echo   ███    ███   ███    ██▄          ███ ███    █▄  ███           ███          ███   ███    ███ 
echo   ███    ███   ███    ███    ▄█    ███ ███    ███ ███     ▄█    ███    ▄█    ███   ███    ███ 
echo   ███    █▀  ▄█████████▀   ▄████████▀  ████████▀  █▀    ▄████████▀   ▄████████▀    ███    █▀  
echo.
timeout /t 2 /nobreak >nul 2>&1

exit /b
