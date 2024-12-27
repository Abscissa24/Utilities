:::::::::::::::::::::::
::Uninstall Script v3::
:::::::::::::::::::::::

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

start /b "" "progress-bar.bat" 80 25 60 c 

taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1

takeown /f "C:\Windows\Utilities" /r /d y >nul 2>&1
icacls "C:\Windows\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Windows\Utilities" >nul 2>&1

takeown /f "C:\Utilities" /r /d y >nul 2>&1
icacls "C:\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Utilities" >nul 2>&1

takeown /f "C:\Program Files (x86)\Utilities" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)\Utilities" /grant %username%:F >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\Utilities" >nul 2>&1

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Record" /f >nul 2>&1

timeout /t 2

taskkill /f /im getcolor.exe >nul 2>&1
del "%~dp0getcolor.exe" >nul 2>&1

taskkill /f /im darkbox.exe >nul 2>&1
del "%~dp0darkbox.exe" >nul 2>&1

del "%~dp0progress-bar.bat" >nul 2>&1
taskkill /f /im cmd.exe >nul 2>&1