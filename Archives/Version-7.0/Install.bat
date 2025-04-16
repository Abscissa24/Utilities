:::::::::::::::::::::
::Install Script v5::
:::::::::::::::::::::

:::::::::::::::::::
::Starting Script::
:::::::::::::::::::

@echo off
mode 80,25
color 0f

::Initialising Progress Bar

curl -L -o "%~dp0darkbox.exe" https://github.com/hXR16F/progress-bar/raw/refs/heads/main/darkbox.exe >nul 2>&1
curl -L -o "%~dp0getcolor.exe" https://github.com/hXR16F/progress-bar/raw/refs/heads/main/getcolor.exe >nul 2>&1
curl -L -o "%~dp0progress-bar.bat" https://github.com/hXR16F/progress-bar/raw/refs/heads/main/progress-bar.bat >nul 2>&1

if defined __ goto :main
set __=.
darkbox | call %0 %* | darkbox
set __=
pause >nul
goto :eof

:main

start /b "" "progress-bar.bat" 80 25 60 0 2

curl -L -o %TEMP%\Utilities.zip https://github.com/Abscissa24/Utilities/raw/refs/heads/main/Utilities.zip >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP%\Utilities.zip' -DestinationPath 'C:\Utilities'" >nul 2>&1

curl -L -o C:\Utilities\Data\VisualCppRedist_AIO_x86_x64.exe https://github.com/abbodi1406/vcredist/releases/download/v0.85.0/VisualCppRedist_AIO_x86_x64.exe >nul 2>&1

regedit /s "C:\Utilities\Registry\Utilities.reg"
reg add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /d "" /f >nul 2>&1

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe

takeown /f "C:\Utilities\Scripts\Optimise\Optimise.bat" /r /d y >nul 2>&1

takeown /f "C:\Utilities\Scripts\Record\Record.bat" /r /d y >nul 2>&1

takeown /f "C:\Utilities\Scripts\Insomnia\ToggleON.bat" /r /d y >nul 2>&1
takeown /f "C:\Utilities\Scripts\Insomnia\ToggleOFF.bat" /r /d y >nul 2>&1

rd /s /q "C:\Utilities\Registry" >nul 2>&1

"C:\Utilities\Data\scrcpy-win64-v3.1\scrcpy.exe" >nul 2>&1

taskkill /f /im getcolor.exe >nul 2>&1
del "%~dp0getcolor.exe" >nul 2>&1

taskkill /f /im darkbox.exe >nul 2>&1
del "%~dp0darkbox.exe" >nul 2>&1

del "%~dp0progress-bar.bat" >nul 2>&1



taskkill /f /im cmd.exe >nul 2>&1
