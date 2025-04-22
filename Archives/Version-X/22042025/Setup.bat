@echo off
setlocal enabledelayedexpansion

:: Check for admin rights
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process '%~s0' -Verb runAs"
    exit /b
)

:: Initialize
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
echo. 
echo 4) [BETA] Configurations
echo 5) [BETA] Synchronise Data Schema
echo. 
echo 6) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto INSTALL_MENU
if "%choice%"=="2" goto UNINSTALL_MENU
if "%choice%"=="3" goto GITHUB_LAUNCH
if "%choice%"=="4" goto CONFIGURE
if "%choice%"=="5" goto UPGRADE
if "%choice%"=="6" goto END
::Easter egg
if /i "%choice%"=="TYRA" goto TURTLE

:: Invalid choice
call :SHOW_ERROR
goto MAIN_MENU

:INSTALL_MENU
cls
figlet Install
echo. 
echo 1) Utilities-X
echo 2) Experimental-X
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
echo 1) Version-7.0
echo 2) Version-8.0
echo 3) Version-9.0
echo 4) Version-9.1
echo 5) Version-X
echo 6) Main Menu
echo.
set /p "choice=Select an option: "

if "%choice%"=="1" (
    set "version=7.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="2" (
    set "version=8.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="3" (
    set "version=9.0"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="4" (
    set "version=9.1"
    goto INSTALL_ARCHIVE
)
if "%choice%"=="5" goto VERSION_X_MENU
if "%choice%"=="6" goto MAIN_MENU
goto SHOW_ERROR

:VERSION_X_MENU
cls
figlet Build Date
echo. 
echo 1) 20 April 2025
echo 2) 04 April 2025
echo 3) 03 April 2025
echo 4) 01 April 2025
echo 5) 31 March 2025
echo 6) 25 March 2025
echo 7) 24 March 2025
echo 8) Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" set "version=2042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="2" set "version=04042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="3" set "version=03042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="4" set "version=01042025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="5" set "version=31032025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="6" set "version=25032025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="7" set "version=24032025" && goto INSTALL_ARCHIVE_X
if "%choice%"=="8" goto INSTALL_ARCHIVED_VERSIONS
call :SHOW_ERROR
goto VERSION_X_MENU

:INSTALL_STABLE
COLOR 0A
cls
figlet Installing
timeout /t 2 >nul 2>&1
cls
echo Removing previous versions and residual files
call :CLEANUP_PREVIOUS >nul 2>&1
timeout /t 1 >nul 2>&1

cls
echo Performing shell integration
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Assets/shell-1-9-18.msi' -OutFile '%TEMP_DIR%\shell-1-9-18.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\shell-1-9-18.msi" /qn /norestart /passive >nul 2>&1

robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" support.ico /COPYALL /R:3 /W:5 >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"

call :RESTART_EXPLORER >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1
call :CLEANUP >nul 2>&1
cls
echo Success!
echo. 
echo Please read the documentation carefully
timeout /t 2 >nul 2>&1
start C:\Utilities\Info\Stable.pdf"
goto MAIN_MENU

:INSTALL_EXPERIMENTAL
COLOR 0A
cls
figlet Installing
timeout /t 2 >nul 2>&1
cls
echo Removing previous versions and residual files
call :CLEANUP_PREVIOUS >nul 2>&1
timeout /t 1 >nul 2>&1

cls
echo Performing shell integration
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Utilities-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/download/v1.1.2/uad-ng-windows.exe' -OutFile 'C:\Utilities\Data\ADB\uad-ng-windows.exe' -UseBasicParsing" >nul 2>&1
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.2/scrcpy-win64-v3.2.zip' -OutFile '%TEMP_DIR%\scrcpy-win64-v3.1.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\scrcpy-win64-v3.1.zip' -DestinationPath '%INSTALL_DIR%\Data\Record' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Assets/shell-1-9-18.msi' -OutFile '%TEMP_DIR%\shell-1-9-18.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\shell-1-9-18.msi" /qn /norestart /passive >nul 2>&1

robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" support.ico /COPYALL /R:3 /W:5 >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"

call :RESTART_EXPLORER

:: Install additional experimental components
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi' -OutFile '%TEMP_DIR%\UniversalAdbDriverSetup.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\UniversalAdbDriverSetup.msi" /qn /norestart /passive >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\ADB" >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\Shortcuts" >nul 2>&1

winget install WiseCleaner.WiseProgramUninstaller >nul 2>&1
timeout /t 1 >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\Wise Program Uninstaller.lnk" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Latest/Experimental-X.zip' -OutFile '%TEMP_DIR%\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\Utilities.zip' -DestinationPath '%INSTALL_DIR%' -Force" >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Experimental.reg" >nul 2>&1

call :CLEANUP >nul 2>&1
cls
echo Success!
echo. 
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

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%UTILITIES_URL%/Assets/shell-1-9-18.msi' -OutFile '%TEMP_DIR%\shell-1-9-18.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\shell-1-9-18.msi" /qn /norestart /passive >nul 2>&1

robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "%INSTALL_DIR%\Shell" "%SHELL_DIR%" support.ico /COPYALL /R:3 /W:5 >nul 2>&1
regedit /s "%INSTALL_DIR%\Registry\Utilities.reg"
regedit /s "%INSTALL_DIR%\Registry\Experimental.reg" >nul 2>&1

call :RESTART_EXPLORER >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi' -OutFile '%TEMP_DIR%\UniversalAdbDriverSetup.msi' -UseBasicParsing" >nul 2>&1
msiexec /i "%TEMP_DIR%\UniversalAdbDriverSetup.msi" /qn /norestart /passive >nul 2>&1
setx /M PATH "!PATH!;%INSTALL_DIR%\Data\ADB" >nul 2>&1

winget install WiseCleaner.WiseProgramUninstaller >nul 2>&1
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

:CONFIGURE

cls
figlet Configs
echo. 
echo 1) Themes
echo 2) Applications
echo 3) Microsoft Office
echo 4) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto CONFIGURE_THEMES
if "%choice%"=="2" goto CONFIGURE_APPS
if "%choice%"=="3" goto CONFIGURE_OFFICE
if "%choice%"=="4" goto MAIN_MENU
call :SHOW_ERROR

:CONFIGURE_THEMES

cls
figlet Themes

echo. 
echo 1) Pure Dark
echo 2) Pure Light
echo 3) Abstract
echo. 
echo 4) Main Menu
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto DARK
if "%choice%"=="2" goto LIGHT
if "%choice%"=="3" goto ABSTRACT
if "%choice%"=="4" goto MAIN_MENU
call :SHOW_ERROR

:DARK
cls

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Item 'C:\Utilities\Data\Themes\Pure Dark.deskthemepack' >$null 2>&1; Start-Sleep -Seconds 2; Stop-Process -Name SystemSettings -Force >$null 2>&1"

winget install StartIsBack.StartAllBack --scope machine >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/StartAllBack.zip' -OutFile '%AppData\Utilities\Themes\StartAllBack.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%AppData%\Utilities\Themes\StartAllBack.zip' -DestinationPath 'C:\Program Files\StartAllBack' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/StartAllBack_cache.zip' -OutFile '%AppData\Utilities\Themes\StartAllBack_cache.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%AppData%\Utilities\Themes\StartAllBack_cache.zip' -DestinationPath 'AppData\Local' -Force" >nul 2>&1

goto MAIN_MENU

:LIGHT

cls
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Item 'C:\Utilities\Data\Themes\Pure Light.deskthemepack' >$null 2>&1; Start-Sleep -Seconds 2; Stop-Process -Name SystemSettings -Force >$null 2>&1"

winget install StartIsBack.StartAllBack --scope machine >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/StartAllBack.zip' -OutFile '%AppData\Utilities\Themes\StartAllBack.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%AppData%\Utilities\Themes\StartAllBack.zip' -DestinationPath 'C:\Program Files\StartAllBack' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/StartAllBack_cache.zip' -OutFile '%AppData\Utilities\Themes\StartAllBack_cache.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%AppData%\Utilities\Themes\StartAllBack_cache.zip' -DestinationPath 'AppData\Local' -Force" >nul 2>&1

goto MAIN_MENU

:ABSTRACT
cls

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/Abstract.deskthemepack' -OutFile 'C:\Utilities\Data\Themes\Abstract.deskthemepack' -UseBasicParsing" >nul 2>&1

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Item 'C:\Utilities\Data\Themes\Abstract.deskthemepack' >$null 2>&1; Start-Sleep -Seconds 2; Stop-Process -Name SystemSettings -Force >$null 2>&1"

winget install StartIsBack.StartAllBack --scope machine >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/StartAllBack.zip' -OutFile '%AppData\Utilities\Themes\StartAllBack.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%AppData%\Utilities\Themes\StartAllBack.zip' -DestinationPath 'C:\Program Files\StartAllBack' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/StartAllBack_cache.zip' -OutFile '%AppData\Utilities\Themes\StartAllBack_cache.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%AppData%\Utilities\Themes\StartAllBack_cache.zip' -DestinationPath 'AppData\Local' -Force" >nul 2>&1

goto MAIN_MENU

:CONFIGURE_APPS
cls
echo Installing ShareX
winget install --id=ShareX.ShareX -e
cls
echo Installing Brave
winget install --id=Brave.Brave -e
cls
echo Installing WindHawk
winget install --id=RamenSoftware.Windhawk -e
cls
echo Installing ScreenBox
winget install --id=Starpine.Screenbox -e

::cls
::echo Installing PowerToys
::winget install --id=Microsoft.PowerToys -e

cls
echo Installing Steam
winget install --id=Valve.Steam -e
cls
echo Installing WhatsApp
winget install --id=WhatsApp.WhatsApp -e  # 9NKSQGP7F2NH
cls
echo Installing Windows Calculator
winget install --id=Microsoft.WindowsCalculator -e  # 9WZDNCRFHVN5
cls
echo Installing Paint
winget install --id=Microsoft.Paint -e  # 9PCFS5B6T72H
cls
echo Installing ClipChamp
winget install --id=Clipchamp.Clipchamp -e  # 9P1J8S7CCWWT
cls
echo Installing WinToys
winget install --id=WinToys -e  # 9P8LTPGCBZXD
cls

echo Applications Configured!
timeout /t 2 >nul 2>&1
goto CONFIGURE

:CONFIGURE_OFFICE
cls
COLOR 0A

echo Installing Office

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/Office.zip' -OutFile '%SystemRoot%\Temp\Office.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Office.zip' -DestinationPath '%Appdata%\Utilities\Office' -Force" >nul 2>&1

cd %Appdata%\Utilities\Office
setup.exe /configure Configuration.xml

cls
echo Installing Outlook
winget install --id=Microsoft.OutlookForWindows -e  # 9NRX63209R7B
cls

echo Activating

cd C:\Utilities\Scripts\Experimental\Setup\Office

powershell -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force; Get-ChildItem -Recurse *.ps1 | Unblock-File; .\Activator.ps1 'CLI'"

cls
echo Success!
timeout /t 2 >nul 2>&1

goto CONFIGURE

:UPGRADE
cls
echo Fetching Latest Setup

:: Set paths
set "DOWNLOAD_DIR=%Appdata%\Utilities\Setup"
set "DOWNLOAD_FILE=%DOWNLOAD_DIR%\Setup.bat"
set "TARGET_DIR=C:\Utilities\Data\Shortcuts"
set "TARGET_FILE=%TARGET_DIR%\Setup.bat"

:: Create download directory if needed
if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%" >nul 2>&1
)

:: Download the file
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/releases/download/Rolling-Release/Setup.bat' -OutFile '%DOWNLOAD_FILE%' -UseBasicParsing" >nul 2>&1

:: Verify the file contains @echo off
findstr /m "^@echo off" "%DOWNLOAD_FILE%" >nul 2>&1
if errorlevel 1 (
    echo Schema Invalid
    pause
    exit /b 1
)

:: Create target directory if needed
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%" >nul 2>&1
)

:: Use robocopy to replace the target file (mirror mode)
robocopy "%DOWNLOAD_DIR%" "%TARGET_DIR%" "Setup.bat" /IS /NFL /NDL /NJH /NJS >nul
if errorlevel 8 (
    echo Schema Invalid
    pause
    exit /b 1
)

:: Launch the target file
start "" "%Appdata%\Utilities\Setup"
timeout /t 1 >nul 2>&1
start "" /D "%TARGET_DIR%" "Setup.bat"
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
if exist "%SHELL_DIR%" (
    cd /d "%SHELL_DIR%"
    shell -unregister >nul 2>&1
    call :TAKE_OWNERSHIP "%SHELL_DIR%"
    rmdir /s /q "%SHELL_DIR%" >nul 2>&1
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

reg import "C:\Utilities\Shell\Context.reg" >nul 2>&1

for %%k in (
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Record"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC"
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