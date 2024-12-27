:::::::::::::::::::::::
::Uninstall Script v5::
:::::::::::::::::::::::

:::::::::::::::::::
::Starting Script::
:::::::::::::::::::

@echo off
mode 80,25
color 0c

NET SESSION >nul 2>&1
if %errorlevel% == 0 (

echo Uninstalling
timeout /t 2 >nul
  
taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

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
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC" /f >nul 2>&1
reg delete HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2} /f

taskkill /f /im getcolor.exe >nul 2>&1
del "%~dp0getcolor.exe" >nul 2>&1

taskkill /f /im darkbox.exe >nul 2>&1
del "%~dp0darkbox.exe" >nul 2>&1

del "%~dp0progress-bar.bat" >nul 2>&1
taskkill /f /im cmd.exe >nul 2>&1"

) else (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit
)
