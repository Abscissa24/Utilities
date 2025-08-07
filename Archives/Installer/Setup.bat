@echo off
setlocal enabledelayedexpansion

:: Check for admin rights
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process '%~s0' -Verb runAs"
    exit /b
)

title Utilities - Abscissa

COLOR 03
set "UTILITIES_URL=https://github.com/Abscissa24/Utilities/raw/main"
set "TEMP_DIR=%SystemRoot%\Temp"
set "INSTALL_DIR=C:\Utilities"
set "SHELL_DIR=C:\Program Files\Nilesoft Shell"

:MAIN_MENU
COLOR 03
cls

:: Configuration Settings

if not exist "%Appdata%\Utilities\Setup\Setup.bat" (
    cls
    echo Configuring
    mkdir "%Appdata%\Utilities\Setup"
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%Appdata%\Utilities\Setup\Setup.bat' -UseBasicParsing" >nul 2>&1
)

if not exist "%Appdata%\Utilities\Shell\Support.ico" (
    cls
    mkdir "%Appdata%\Utilities\Shell"
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/support.ico' -OutFile '%Appdata%\Utilities\Shell\support.ico' -UseBasicParsing" >nul 2>&1
)

if not exist "%Appdata%\Utilities\Figlet\figlet.exe" (
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Assets/FLGlet.zip' -OutFile '%TEMP_DIR%\FLGlet.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP_DIR%\FLGlet.zip' -DestinationPath '%Appdata%\Utilities\Figlet' -Force" >nul 2>&1
    del "%TEMP_DIR%\FLGlet.zip" >nul 2>&1
)

if exist "%Appdata%\Utilities\Figlet\figlet.exe" (
    cd /d "%Appdata%\Utilities\Figlet"
    figlet UTILITIES
    echo.
)

:: Main menu
echo 1) Install
echo 2) Uninstall
echo 3) GitHub Homepage
echo 4) Upgrade Installer
echo. 
echo 5) [BETA] Configurations
echo. 
echo 6) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto INSTALL_MENU
if "%choice%"=="2" goto UNINSTALL_MENU
if "%choice%"=="3" goto GITHUB_LAUNCH
if "%choice%"=="4" goto UPGRADE
if "%choice%"=="5" goto CONFIGURE
if "%choice%"=="6" goto END

::Easter egg
if /i "%choice%"=="TYRA" goto TURTLE

::Easter egg
if /i "%choice%"=="dev_menu" goto DEV_MENU

::Easter egg
if /i "%choice%"=="dev_gui" goto DEV_GUI

::Easter egg
if /i "%choice%"=="MAWZES" goto MAWZES

:: Invalid choice
call :SHOW_ERROR
goto MAIN_MENU

:INSTALL_MENU
cls
figlet Install
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

:UNINSTALL_MENU
cls
figlet Uninstall
echo. 
echo 1) Experimental ONLY
echo 2) Complete
echo 3) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto UNINSTALL_EXPERIMENTAL
if "%choice%"=="2" goto UNINSTALL_ALL
if "%choice%"=="3" goto MAIN_MENU
call :SHOW_ERROR
goto UNINSTALL_MENU

:INSTALL_ARCHIVED_VERSIONS
cls
figlet Archive
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
figlet Point-Release
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
figlet Build Month
echo. 
echo 1) June 2025
echo 2) May 2025
echo 3) April 2025
echo 4) March 2025
echo. 
echo 5) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto VERSION_X_JUNE
if "%choice%"=="2" goto VERSION_X_MAY
if "%choice%"=="3" goto VERSION_X_APRIL
if "%choice%"=="4" goto VERSION_X_MARCH
if "%choice%"=="5" goto INSTALL_ARCHIVED_VERSIONS
call :SHOW_ERROR
goto VERSION_X_MENU

:VERSION_X_JUNE
cls
figlet Build Date
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
figlet Build Date
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
figlet Build Date
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
figlet Build Date
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
figlet Installing
timeout /t 2 >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
timeout /t 1 >nul 2>&1
robocopy "C:\Utilities\Data\Speedtest" "%AppData%\Ookla\Speedtest CLI" "speedtest-cli.ini" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0 >nul 2>&1
robocopy "C:\Utilities\Shell" "%AppData%\Utilities\Shell" "shell-1-9-18.msi" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0 >nul 2>&1
robocopy "C:\Utilities\Data\Shortcuts" "%AppData%\Utilities\Setup" *.lnk /S /ZB /COPYALL /R:1 /W:1 >nul 2>&1
timeout /t 1 >nul 2>&1
msiexec /i "%AppData%\Utilities\Shell\shell-1-9-18.msi" /qn /norestart /passive >nul 2>&1
timeout /t 2 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /t REG_SZ /d "C:\\Utilities\\Shell\\support.ico" /f >nul 2>&1

powershell -nologo -noprofile -command "Expand-Archive -LiteralPath 'C:\Utilities\Data\Wise.zip' -DestinationPath 'C:\Program Files (x86)' -Force" >nul 2>&1

setx /M PATH "!PATH!;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1
setx /M PATH "!PATH!;%AppData%\Utilities\Setup" >nul 2>&1

cd C:\Program Files\Nilesoft Shell
shell.exe -treat -register -restart -silent

call :CLEANUP >nul 2>&1
figlet Success
timeout /t 2 >nul 2>&1
cls
echo Please read the documentation carefully
timeout /t 2 >nul 2>&1
start C:\Utilities\Info\Stable.pdf"
goto MAIN_MENU

:INSTALL_EXPERIMENTAL
COLOR 0A
cls
figlet Installing
timeout /t 2 >nul 2>&1

if exist "C:\Utilities" (

echo. 
call "C:\Utilities\Data\Shortcuts\Para2.bat"

)

if not exist "C:\Utilities" (

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
timeout /t 1 >nul 2>&1
robocopy "C:\Utilities\Data\Speedtest" "%AppData%\Ookla\Speedtest CLI" "speedtest-cli.ini" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0
robocopy "C:\Utilities\Shell" "%AppData%\Utilities\Shell" "shell-1-9-18.msi" /NFL /NDL /NJH /NJS /NC /NS /NP /R:0 /W:0
robocopy "C:\Utilities\Data\Shortcuts" "%AppData%\Utilities\Setup" *.lnk /S /ZB /COPYALL /R:1 /W:1
timeout /t 1 >nul 2>&1
msiexec /i "%AppData%\Utilities\Shell\shell-1-9-18.msi" /qn /norestart /passive >nul 2>&1
timeout /t 2 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /t REG_SZ /d "C:\\Utilities\\Shell\\support.ico" /f

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/download/v1.1.2/uad-ng-windows.exe' -OutFile 'C:\Utilities\Data\ADB\uad-ng-windows.exe' -UseBasicParsing" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.2/scrcpy-win64-v3.2.zip' -OutFile '%TEMP_DIR%\scrcpy-win64-v3.1.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\scrcpy-win64-v3.1.zip' -DestinationPath '%INSTALL_DIR%\Data\Record' -Force" >nul 2>&1

:: Install additional experimental components
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi' -OutFile '%TEMP_DIR%\UniversalAdbDriverSetup.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\UniversalAdbDriverSetup.msi" /qn /norestart /passive >nul 2>&1

setx /M PATH "!PATH!;%INSTALL_DIR%\Data\ADB" >nul 2>&1
setx /M PATH "!PATH!;%AppData%\Utilities\Setup" >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1

:: Extract using PowerShell
powershell -nologo -noprofile -command "Expand-Archive -LiteralPath 'C:\Utilities\Data\Wise.zip' -DestinationPath 'C:\Program Files (x86)' -Force"

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Experimental-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Experimental.reg" >nul 2>&1

)
cd C:\Program Files\Nilesoft Shell
shell.exe -treat -register -restart -silent

call :CLEANUP >nul 2>&1
cls
figlet Success!
timeout /t 2 >nul 2>&1
cls
echo Please read the documentation carefully!
timeout /t 2 >nul 2>&1
start C:\Utilities\Info\Experimental.pdf"
goto MAIN_MENU

:INSTALL_ARCHIVE
COLOR 0A
cls
echo Installing Version-%version%
timeout /t 2 >nul 2>&1
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
echo Success!

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

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.1/scrcpy-win64-v3.1.zip' -OutFile '%TEMP_DIR%\scrcpy-win64-v3.1.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\scrcpy-win64-v3.1.zip' -DestinationPath '%INSTALL_DIR%\Data\Record' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi' -OutFile '%AppData%\Utilities\Shell\shell-1-9-18.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%AppData%\Utilities\Shell\shell-1-9-18.msi" /qn /norestart /passive >nul 2>&1

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

timeout /t 1 >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\Wise Program Uninstaller.lnk" >nul 2>&1

call :CLEANUP
cls
echo Success!
echo. 
echo Please read the documentation carefully!
timeout /t 2 >nul 2>&1
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
echo Success!
timeout /t 2 >nul 2>&1
goto MAIN_MENU

:UNINSTALL_ALL
COLOR 0C
cls
echo Uninstalling
call :CLEANUP_PREVIOUS >nul 2>&1
cls
echo Success!
timeout /t 2 >nul 2>&1
start explorer.exe
goto MAIN_MENU

:GITHUB_LAUNCH
cls
figlet GitHub
start https://github.com/Abscissa24/Utilities
pause
goto MAIN_MENU

:TURTLE
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet I LOVE YOU!
timeout /t 5 >nul 2>&1
goto MAIN_MENU

:: Hidden DEV Menu
:DEV_MENU
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet DEV MENU
echo. 
echo 1) SETUP_INFO
echo 2) CREATE_LOCAL_DEV_REPOSITORY
echo 3) GIT_LAUNCH
echo 4) PARA_EXECUTE
echo. 
echo 5) MAIN_MENU
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto DEV_INFO
if "%choice%"=="2" goto DEV_MAKE_REPO
if "%choice%"=="3" goto GITHUB_LAUNCH
if "%choice%"=="4" goto PARA_MAIN
if "%choice%"=="5" goto MAIN_MENU

:: Invalid choice
call :SHOW_ERROR
goto DEV_MENU

:DEV_GUI

cls
echo [BETA] Fetching latest GUI
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/GUI/Utilities.exe' -OutFile '%USERPROFILE%\Desktop\Utilities.exe' -UseBasicParsing" >nul 2>&1
timeout /t 1 >nul 2>&1
cls
start "" "%USERPROFILE%\Desktop\Utilities.exe"
goto MAIN_MENU

:DEV_INFO
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet Information
echo.
echo Setup Version: 10.01072025
echo. 
echo Build Date: 01st July 2025
echo Developer: Armiel Pillay
echo Alias: Abscissa24
echo. 
echo Utilities Size-On-Disk: 36.0MB
echo EXE Wrapper Version: 2.4.4.0
echo. 
echo GIT Health: Excellent
echo Package Health: Good
echo Commit Rate: Fair
echo Repository Size: 187.6MB
echo. 
pause
goto DEV_MENU

:MAWZES
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet Mawzes
echo.
echo 1) Configure System
echo 2) Remove all patches
echo 3) GitHub Homepage
echo.
echo 4) [BETA] Install Software
echo.
echo 5) Main Menu

echo.
set /p choice=Select an option:

if "%choice%"=="1" goto MAWZES_CONFIGURE
if "%choice%"=="2" goto MAWZES_UNINSTALL
if "%choice%"=="3" goto GITHUB_LAUNCH
if "%choice%"=="4" goto MAWZES_SOFTWARE
if "%choice%"=="5" goto MAIN_MENU

:MAWZES_CONFIGURE
cls
echo [BETA] Fetching latest GUI (Custom Patched for MAWZES)
echo. 
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/GUI/Utilities.exe' -OutFile '%USERPROFILE%\Desktop\Utilities.exe' -UseBasicParsing" >nul 2>&1
timeout /t 1 >nul 2>&1
cls
start "" "%USERPROFILE%\Desktop\Utilities.exe"

cls
cd /d "%Appdata%\Utilities\Figlet"
figlet IMR
timeout /t 2 >nul 2>&1
cls

echo Activating Windows 11 Pro
timeout /t 2 >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /HWID }"
cls

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
echo Installing Lively Wallpaper...
echo. 
winget install --id=rocksdanister.LivelyWallpaper --silent --accept-package-agreements --accept-source-agreements
cls
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
    echo Syncing Theme Repository
    timeout /t 2 >nul 2>&1
    echo. 
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes.zip' -OutFile '%TEMP%\Themes.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Themes.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
    timeout /t 2 >nul 2>&1

    cls
    echo Applying Custom Theme (Mawzes)
    timeout /t 2 >nul 2>&1
    cd /d %userprofile%\AppData\Local >nul 2>&1
    del IconCache.db /a >nul 2>&1

    timeout /t 1 >nul 2>&1
    regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1
    cls

    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Mawzes\Icons\folder.ico,0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Mawzes\Icons\folder.ico,0" /f >nul 2>&1

    taskkill /IM explorer.exe /F >nul 2>&1
    timeout /t 1 >nul 2>&1
    start explorer.exe >nul 2>&1
    timeout /t 2 >nul 2>&1
    start "" "%AppData%\Utilities\Themes\Mawzes\Mawzes.theme" >nul 2>&1
)

start "" "C:\Utilities\Scripts\Optimise\System.bat" >nul 2>&1
start "" "C:\Utilities\Scripts\Optimise\Network.bat" >nul 2>&1

goto MAWZES

:MAWZES_UNINSTALL
start "" "C:\Utilities\Uninstall\unins000.exe" >nul 2>&1
winget uninstall --id=StartIsBack.StartAllBack >nul 2>&1
call %AppData%\Utilities\Shortcuts\Parax.bat
goto MAWZES

:MAWZES_SOFTWARE
cls
echo Still in development :)
echo.
pause
goto MAWZES

:DEV_MAKE_REPO

cls
set /p choice=ENTER_PASSWORD: 

if "%choice%"=="24072411" goto DEV_PASS_UNLOCK

:: Invalid choice
call :DEV_PASS_LOCK

:DEV_PASS_LOCK
cls
echo Incorrect Password
echo. 
pause
goto DEV_MENU

:DEV_PASS_UNLOCK
cls
echo Configuring
echo. 

if exist "%TEMP%\Utilities-main" (

    robocopy "%TEMP%\Utilities-main\Utilities-main" "%USERPROFILE%\Desktop\GitHub Development" /E /ZB /COPYALL /R:1 /W:1 /TEE
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%USERPROFILE%\Desktop\GitHub Development\Setup.bat' -UseBasicParsing" >nul 2>&1
)

if not exist "%TEMP%\Utilities-main" (

    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/archive/refs/heads/main.zip' -OutFile '%TEMP%\Utilities-main.zip'"
    timeout /t 2 >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Utilities-main.zip' -DestinationPath '%TEMP%\Utilities-main'"
    robocopy "%TEMP%\Utilities-main\Utilities-main" "%USERPROFILE%\Desktop\GitHub Development" /E /ZB /COPYALL /R:1 /W:1 /TEE
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%USERPROFILE%\Desktop\GitHub Development\Setup.bat' -UseBasicParsing" >nul 2>&1
)

:CONFIGURE

cls
figlet Configs
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
    timeout /t 2 >nul 2>&1
    echo. 
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/main/Assets/Themes.zip' -OutFile '%TEMP%\Themes.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%TEMP%\Themes.zip' -DestinationPath '%AppData%\Utilities\Themes' -Force" >nul 2>&1
)

cls
cd %appdata%\Utilities\Figlet
figlet Themes
echo. 
echo 1) Tyra
echo 2) Options
echo. 
echo 3) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto TYRA_THEME
if "%choice%"=="2" goto OPTIONS
if "%choice%"=="3" goto CONFIGURE

if "%choice%"=="dev_abs" goto ABSTRACT

call :SHOW_ERROR

:TYRA_THEME

cls
cd %appdata%\Utilities\Figlet
figlet Tyra Themes
echo. 
echo 1) Pretty Pink
echo 2) Bubu and Dudu
echo 3) Samurai Catto
echo. 
echo 4) Back
echo. 
set /p choice=Select an option: 

if "%choice%"=="1" goto PINK
if "%choice%"=="2" goto BUBU_DUDU
if "%choice%"=="3" goto SAMURAI_CATTO
if "%choice%"=="4" goto CONFIGURE_THEMES
call :SHOW_ERROR


:SAMURAI_CATTO

cls
cd %appdata%\Utilities\Figlet
figlet In progress
timeout /t 2 >nul 2>&1
goto TYRA_THEME


:PINK

cls
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1

timeout /t 1 >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1

cls

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Pink\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Pink\Icons\folder.ico,0" /f >nul 2>&1

taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 >nul 2>&1
start "" "%AppData%\Utilities\Themes\Pink\Pink.theme" >nul 2>&1

goto TYRA_THEME

:BUBU_DUDU

cls
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1

timeout /t 1 >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1

cls

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Pink\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Pink\Icons\folder.ico,0" /f >nul 2>&1

taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 >nul 2>&1
start "" "%AppData%\Utilities\Themes\Bubu\BubuDudu.theme" >nul 2>&1

goto TYRA_THEME

:OPTIONS

cls
cd %appdata%\Utilities\Figlet
figlet Options
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

timeout /t 1 >nul 2>&1
regsvr32 /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll" >nul 2>&1

cls

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /t REG_SZ /d "%AppData%\Utilities\Themes\Abstract\Icons\folder.ico,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /t REG_SZ /d "%AppData%\Utilities\Themes\Abstract\Icons\folder.ico,0" /f >nul 2>&1

taskkill /IM explorer.exe /F >nul 2>&1
timeout /t 1 >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 >nul 2>&1
start "" "%AppData%\Utilities\Themes\Abstract\Abstract.theme" >nul 2>&1

goto TYRA_THEME

:MICA_GONE
cls
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul 2>&1
regsvr32 /u /s "C:\Windows\Release\ExplorerBlurMica.dll"
timeout /t 1 >nul 2>&1
regsvr32 /u /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll"
timeout /t 1 >nul 2>&1
start explorer.exe >nul 2>&1

goto OPTIONS

:REVERT
cls
cd /d %userprofile%\AppData\Local >nul 2>&1
del IconCache.db /a >nul 2>&1
del /q /f /s "%localappdata%\Microsoft\Windows\Themes\*.*" && rmdir /s /q "%localappdata%\Microsoft\Windows\Themes\" >nul 2>&1
cls
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul 2>&1
regsvr32 /u /s "C:\Windows\Release\ExplorerBlurMica.dll"
timeout /t 1 >nul 2>&1
regsvr32 /u /s "%AppData%\Utilities\Themes\Release\ExplorerBlurMica.dll"
timeout /t 1 >nul 2>&1
start explorer.exe >nul 2>&1
timeout /t 2 >nul 2>&1
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
timeout /t 2 >nul 2>&1
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
timeout /t 2 >nul 2>&1
goto CONFIGURE

:CONFIGURE_OFFICE
cls

if exist "C:\Program Files\Microsoft Office" (

    cls Microsoft Office: Installation Found!
    timeout /t 2 >nul 2>&1
    cls
    echo Updating Activation
    powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /Ohook }"
    cls
    echo Success!
    timeout /t 2 >nul 2>&1
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
echo Success!
timeout /t 2 >nul 2>&1

goto CONFIGURE
)

:ACTIVATE_WINDOWS

cls
echo Activating
cls
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { & ([ScriptBlock]::Create((Invoke-RestMethod 'https://get.activated.win'))) /HWID }"
cls
goto CONFIGURE

:UPGRADE
cls
echo Fetching Latest Setup

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

:: Copy the setup file to the target directory
robocopy "%AppData%\Utilities\Setup" "C:\Utilities\Data\Shortcuts" "Setup.bat" /IS /NFL /NDL /NJH /NJS >nul
set RC=%ERRORLEVEL%
if %RC% GEQ 8 (
    cls
    echo ERROR: Schema Inheritance FAIL
    echo.
    pause
    goto MAIN_MENU
)

:: Launch the copied setup file using call (in-process, avoids memory issues)
cls
echo Installer Succesfully Upgraded!
timeout /t 2 >nul 2>&1
cls
call "%AppData%\Utilities\Setup\Setup.bat"
exit

:: ========== SUBROUTINES ==========

:CLEANUP_PREVIOUS
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1

:: Stop processes
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

:: Uninstall Nilesoft Shell
cd C:\Program Files\Nilesoft Shell
shell.exe -unregister -restart -silent
timeout /t 2 >nul 2>&1
msiexec /x "%AppData%\Utilities\Shell\shell-1-9-18.msi" /quiet

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
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1
goto :EOF

:CLEANUP
del /f /s /q %systemroot%\temp\* >nul 2>&1
del /f /s /q %temp%\* >nul 2>&1
del /f /s /q temp\* >nul 2>&1
del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%\Data\Misc" >nul 2>&1
    rmdir /s /q "%INSTALL_DIR%\Registry" >nul 2>&1
)
goto :EOF

:SHOW_ERROR
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet MOOOOOO
timeout /t 2 >nul 2>&1
echo.
echo Select the number ONLY and press enter!
echo.
pause
goto :EOF

:END
call :CLEANUP
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet Made by Armiel
echo.
timeout /t 2 >nul 2>&1
exit /b
