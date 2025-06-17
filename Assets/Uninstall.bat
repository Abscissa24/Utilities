@echo off
setlocal enabledelayedexpansion

:: Ensure administrator privileges
NET SESSION >nul 2>&1 || (
    powershell -Command "Start-Process '%~s0' -Verb runAs" >nul 2>&1
    exit /b
)

:: Kill related processes
for %%P in (adb.exe scrcpy.exe caffeine64.exe) do (
    taskkill /f /im %%P >nul 2>&1
)

:: Unregister and uninstall Nilesoft Shell if present
cd "C:\Program Files\Nilesoft Shell" 2>nul && (
    shell.exe -unregister -silent >nul 2>&1
    timeout /t 2 >nul
    if exist "C:\Utilities\Shell\shell-1-9-18.msi" (
        msiexec /x "C:\Utilities\Shell\shell-1-9-18.msi" /quiet >nul 2>&1
    )
)

:: Uninstall ADB & Fastboot++ if it exists
set "ADB_DIR=C:\Program Files (x86)\ADB & Fastboot++"
if exist "%ADB_DIR%" (
    call :TAKE_OWNERSHIP "%ADB_DIR%"
    rmdir /s /q "%ADB_DIR%" >nul 2>&1
    call :TAKE_OWNERSHIP "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++"
    rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1
)

:: Registry cleanup for icons and context menus
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /f >nul 2>&1
reg delete "HKCR\*\shellex\ContextMenuHandlers" /f >nul 2>&1
reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers" /f >nul 2>&1

:: Restore minimal context shell structure
reg add "HKCR\*\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCR\Directory\shell" /ve /t REG_SZ /d "none" /f >nul 2>&1

:: Restore custom context menu entries if backup exists
if exist "C:\Utilities\Shell\Context.reg" (
    reg import "C:\Utilities\Shell\Context.reg" >nul 2>&1
)

:: Remove custom context menu entries explicitly
for %%K in (
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Record"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAA"
) do (
    reg delete "%%~K" /f >nul 2>&1
)

:: Take ownership and delete C:\Utilities
if exist "C:\Utilities" (
    call :TAKE_OWNERSHIP "C:\Utilities"
    rmdir /s /q "C:\Utilities" >nul 2>&1
)

:: Remove immersive context menu CLSID (if applied for Windows 11)
reg delete "HKLM\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

:: Clean PATH (remove custom Shortcuts path)
powershell -Command "$newPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -replace ';C:\\Utilities\\Data\\Shortcuts', ''; [Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')"

:: Optional: Restore default system path (comment out if not needed)
:: powershell -Command "[Environment]::SetEnvironmentVariable('PATH', 'C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\', 'Machine')"

exit /b

:TAKE_OWNERSHIP
takeown /f "%~1" /r /d y >nul 2>&1
icacls "%~1" /grant administrators:F /t /c >nul 2>&1
exit /b