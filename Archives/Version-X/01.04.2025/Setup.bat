@echo off
COLOR 03

NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (

    powershell -Command "Start-Process '%~s0' -Verb runAs"
    exit /b
)

:start
cls

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1

setlocal

if exist "%Appdata%\Utilities\Figlet\figlet.exe" (
    cls
        cd /d "%Appdata%\Utilities\Figlet"
        figlet UTILITIES
        echo. 

) else (
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/FLGlet.zip' -OutFile '%SystemRoot%\Temp\FLGlet.zip' -UseBasicParsing" >nul 2>&1
    powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\FLGlet.zip' -DestinationPath '%Appdata%\Utilities\Figlet' -Force" >nul 2>&1
    del "%SystemRoot%\Temp\FLGlet.zip" >nul 2>&1

    if exist "%Appdata%\Utilities\Figlet\figlet.exe" (
        cls
        cd /d "%Appdata%\Utilities\Figlet"
        figlet UTILITIES
        echo.
    ) 
)

endlocal

echo 1) Install
echo 2) Uninstall
echo 3) Open GitHub
echo. 
echo 4) [BETA] Install Archived Versions
echo 5) [BETA] Bypass_Local_Install_DEBLOAT_REMOTELY 

echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto MAIN_INSTALL_BRANCH
if "%choice%"=="2" goto MAIN_UNINSTALL_BRANCH
if "%choice%"=="3" goto GITHUB_LAUNCH
if "%choice%"=="4" goto option4
if "%choice%"=="5" goto BETA_BYPASS_LOCAL_INSTALL_DEBLOAT

echo. 
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet MOOOOOO
timeout /t 2 >nul 2>&1
echo. 
echo Select the number ONLY and press enter!
echo. 
pause
goto start

:MAIN_INSTALL_BRANCH

cls

echo 1) Utilities
echo 2) Experimental
echo 3) Main Menu

echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3

echo. 
cd /d "%Appdata%\Utilities\Figlet"
figlet MOOOOOO
timeout /t 2 >nul 2>&1
echo. 
echo Select the number ONLY and press enter!
echo. 
pause
goto start

:option1
@echo off
COLOR 0A
cls
echo Installing Utilities-X
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1

takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
del /q/f/s C:\Windows\Temp\* >nul 2>&1

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Latest/Utilities-X.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls
 
timeout /t 2 >nul 2>&1

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

timeout /t 2 >nul 2>&1

cls
echo Success!
echo. 
echo Please read the documentation carefully!
timeout /t 2 >nul 2>&1
cls
start C:\Utilities\Info\Stable.pdf

) exit /b

goto end

:option2

@echo off

COLOR 0A
cls
echo Installing Utilities-X [Experimental]
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Clearing old versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1 

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Latest/Utilities-X.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/download/v1.1.2/uad-ng-windows.exe' -OutFile 'C:\Utilities\Data\Misc\uad-ng-windows.exe' -UseBasicParsing" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.1/scrcpy-win64-v3.1.zip' -OutFile '%SystemRoot%\Temp\scrcpy-win64-v3.1.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\scrcpy-win64-v3.1.zip' -DestinationPath 'C:\Utilities\Data\Record' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/K3V1991/ADB-and-FastbootPlusPlus/releases/download/v1.1.1/ADB-and-Fastboot++_v1.1.1.msi' -OutFile '%SystemRoot%\Temp\ADB-and-Fastboot++_v1.1.1.msi' -UseBasicParsing" >nul 2>&1

cd %SystemRoot%\Temp
msiexec /i "ADB-and-Fastboot++_v1.1.1.msi" /qn /norestart

del /f /q "C:\Users\Public\Desktop\ADB & Fastboot++.lnk" >nul 2>&1
del /f /q "C:\Users\Public\Desktop\Commands.lnk" >nul 2>&1
del /f /q "C:\Users\Public\Desktop\Developer Options & USB Debugging.lnk" >nul 2>&1
del /f /q "C:\Users\Public\Desktop\Toolkit.lnk" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

timeout /t 1 >nul 2>&1
start explorer.exe >nul 2>&1

timeout /t 2 >nul 2>&1

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Latest/Experimental-X.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Copy-Item -Path 'C:\Utilities\Data\Misc\Shortcuts\*.lnk' -Destination 'C:\Program Files (x86)\ADB & Fastboot++\' -Force -ErrorAction SilentlyContinue" ^
    2>nul

regedit /s "C:\Utilities\Registry\Experimental.reg" >nul 2>&1

rd /s /q "C:\Utilities\Registry" >nul 2>&1

cls
echo Success!
echo. 
echo Please read the documentation carefully!
timeout /t 2 >nul 2>&1

start C:\Utilities\Info\Experimental.pdf

) exit /b

goto end

:option3
goto start

:MAIN_UNINSTALL_BRANCH

cls

echo 1) Remove Experimental Only
echo 2) Complete Uninstall
echo 3) Main Menu

echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto MAIN_MENU

echo. 
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet MOOOOOO
timeout /t 2 >nul 2>&1
echo. 
echo Select the number ONLY and press enter!
echo. 
pause
goto start

:option1

:option1
@echo off
COLOR 0C
cls
echo Removing from shell

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC\shell\Z007ACD" /f >nul 2>&1
timeout /t 2 >nul 2>&1
cls
COLOR 0A
 

takeown /f "C:\Utilities\Scripts\Experimental" /r /d y >nul 2>&1
icacls "C:\Utilities\Scripts\Experimental" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities\Scripts\Experimental" >nul 2>&1
rmdir /s /q "C:\Utilities\Data\Record" >nul 2>&1

del /f /q "C:\Utilities\Info\Experimental.pdf" >nul 2>&1

timeout /t 2 >nul 2>&1
cls
echo Success!
timeout /t 2 >nul 2>&1

exit /b

goto end

:option2

@echo off
cls
color 0c
echo Uninstalling
timeout /t 2 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

COLOR 0A
cls
echo Success!
timeout /t 2 >nul 2>&1
start explorer.exe

) exit /b

goto end

:MAIN_MENU

goto start

:GITHUB_LAUNCH

start https://github.com/Abscissa24/Utilities

goto start

:option4

cls

echo 1) Version 8
echo 2) Version 9
echo 3) Version 9.1
echo 4) Main Menu
echo 5) Experimental

echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
if "%choice%"=="4" goto option4
if "%choice%"=="5" goto option5

echo.
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet MOOOOOO
timeout /t 2 >nul 2>&1
echo. 
echo Select the number ONLY and press enter!
echo. 
pause
goto start


:option1

@echo off
COLOR 0A
cls
echo Installing version 8 
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1 

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Utilities/Utilities-8.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

cls
echo Success!

) exit /b

goto end

:option2

@echo off
COLOR 0A
cls
echo Installing version 9
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1 

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Utilities/Utilities-9.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1 


cls
echo Success!

) exit /b

goto end

:option3

@echo off
COLOR 0A
cls
echo Installing version 9.1
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Utilities/Utilities-9.1.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls
 
echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1 

cls
echo Success!

) exit /b

goto end

:option4

goto start

:option5

cls

echo 1) Experimental v1
echo 2) Experimental v2
echo 3) Experimental v3
echo 4) Main Menu

echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
if "%choice%"=="4" goto option4

echo.
cls
cd /d "%Appdata%\Utilities\Figlet"
figlet MOOOOOO
timeout /t 2 >nul 2>&1
echo. 
echo Select the number ONLY and press enter!
echo. 
pause
goto start

:option1

@echo off
COLOR 0A
cls
echo Installing experimental v1
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Utilities/Experimental-1.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1
timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1 

takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
del /q/f/s C:\Windows\Temp\* >nul 2>&1

cls
echo Success!

) exit /b

goto end

:option2

@echo off
COLOR 0A
cls
echo Installing experimental v2
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1 

takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
del /q/f/s C:\Windows\Temp\* >nul 2>&1

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Utilities/Experimental-2.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1 
timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1 

cls
echo Success!

) exit /b

goto end

:option3

@echo off
COLOR 0A
cls
echo Installing experimental v3
timeout /t 2 >nul 2>&1
echo. 
echo Author: Abscissa
timeout /t 2 >nul 2>&1

cls
echo Removing previous versions and residual files
timeout /t 2 >nul 2>&1
cd C:\Program Files\Nilesoft Shell >nul 2>&1
shell -unregister >nul 2>&1

rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

takeown /f "C:\Program Files\Nilesoft Shell" /r /d y >nul 2>&1
icacls "C:\Program Files\Nilesoft Shell" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files\Nilesoft Shell" >nul 2>&1

msiexec /x "C:\Program Files (x86)\ADB & Fastboot++" /quiet >nul 2>&1

takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1

cls
echo Performing shell integration
timeout /t 2 >nul 2>&1

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Archives/Utilities/Experimental-3.zip' -OutFile '%SystemRoot%\Temp\Utilities.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Utilities.zip' -DestinationPath 'C:\Utilities' -Force" >nul 2>&1

set "msi_url=https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Assets/shell-1-9-18.msi"
set "msi_file=%SystemRoot%\Temp\shell-1-9-18.msi"

powershell -Command "(New-Object Net.WebClient).DownloadFile('%msi_url%', '%msi_file%')"

if not exist "%msi_file%" (

    exit /b 1
)

msiexec /i "%msi_file%" /qn /norestart /passive >nul 2>&1

timeout /t 2 >nul 2>&1

robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" shell.nss /COPYALL /R:3 /W:5 >nul 2>&1
robocopy "C:\Utilities\Shell" "C:\Program Files\Nilesoft Shell" support.ico /COPYALL /R:3 /W:5 >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"

cls
echo This is supposed to happen :)
timeout /t 1 >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul 2>&1
start explorer.exe >nul 2>&1

cls

echo Cleaning up

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1
rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1
timeout /t 2 >nul 2>&1

rd /s /q "C:\Utilities\Data\Misc" >nul 2>&1
rd /s /q "C:\Utilities\Registry" >nul 2>&1

cls
echo Success!

) exit /b

goto end

:option4

goto start

:BETA_BYPASS_LOCAL_INSTALL_DEBLOAT
cls
@echo off
COLOR 0A
echo DEBLOAT_SYSTEM

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/LeDragoX/Win-Debloat-Tools/archive/main.zip' -OutFile '%SystemRoot%\Temp\Win-Debloat-Tools-main.zip' -UseBasicParsing" >nul 2>&1
powershell -Command "Expand-Archive -Path '%SystemRoot%\Temp\Win-Debloat-Tools-main.zip' -DestinationPath '%SystemRoot%\Temp\Win-Debloat-Tools-main' -Force" >nul 2>&1

cd %SystemRoot%\Temp\Win-Debloat-Tools-main\Win-Debloat-Tools-main

powershell -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force; Get-ChildItem -Recurse *.ps1 | Unblock-File; .\WinDebloatTools.ps1 'CLI'"

) exit /b

goto end

:end

del /f /s /q %systemroot%\temp\* >nul 2>&1

del /f /s /q %temp%\* >nul 2>&1

del /f /s /q temp\* >nul 2>&1

del /f /s /q C:\Users\%USERNAME%\AppData\Local\Temp\* >nul 2>&1

cls
        cd /d "%Appdata%\Utilities\Figlet"
        figlet Made by Armiel
        echo. 
timeout /t 2 >nul 2>&1
exit /b

  __  __           _        _                                     _      _ 
 |  \/  |         | |      | |               /\                  (_)    | |
 | \  / | __ _  __| | ___  | |__  _   _     /  \   _ __ _ __ ___  _  ___| |
 | |\/| |/ _` |/ _` |/ _ \ | '_ \| | | |   / /\ \ | '__| '_ ` _ \| |/ _ \ |
 | |  | | (_| | (_| |  __/ | |_) | |_| |  / ____ \| |  | | | | | | |  __/ |
 |_|  |_|\__,_|\__,_|\___| |_.__/ \__, | /_/    \_\_|  |_| |_| |_|_|\___|_|
                                   __/ |                                   
                                  |___/                                    