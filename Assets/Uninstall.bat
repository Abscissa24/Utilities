@echo off
setlocal enabledelayedexpansion

:: Strict admin rights enforcement with automatic elevation
NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"%~dp0\" && \"%~f0\"' -Verb runAs" >nul 2>&1
    exit /b
)

:: Process termination block
taskkill /f /im adb.exe >nul 2>&1
taskkill /f /im scrcpy.exe >nul 2>&1
taskkill /f /im caffeine64.exe >nul 2>&1

:: Nilesoft Shell uninstallation
if exist "C:\Program Files\Nilesoft Shell\" (
    pushd "C:\Program Files\Nilesoft Shell\" >nul 2>&1
    shell.exe -unregister -silent >nul 2>&1
    timeout /t 1 >nul 2>&1
    if exist "C:\Utilities\Shell\shell-1-9-18.msi" (
        msiexec /x "C:\Utilities\Shell\shell-1-9-18.msi" /quiet >nul 2>&1
    )
    popd >nul 2>&1
)

:: ADB Fastboot++ removal
if exist "C:\Program Files (x86)\ADB & Fastboot++\" (
    takeown /f "C:\Program Files (x86)\ADB & Fastboot++" /r /d y >nul 2>&1
    icacls "C:\Program Files (x86)\ADB & Fastboot++" /grant administrators:F /t /c >nul 2>&1
    rmdir /s /q "C:\Program Files (x86)\ADB & Fastboot++" >nul 2>&1
    
    takeown /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /r /d y >nul 2>&1
    icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" /grant administrators:F /t /c >nul 2>&1
    rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ADB & Fastboot++" >nul 2>&1
)

:: Registry cleanup operations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\C\DefaultIcon" /ve /f >nul 2>&1
reg delete "HKCR\*\shellex\ContextMenuHandlers" /f >nul 2>&1
reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers" /f >nul 2>&1

:: Context menu structure reset
reg add "HKCR\*\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCR\Directory\shell" /ve /t REG_SZ /d "none" /f >nul 2>&1

:: Context menu backup restoration
if exist "C:\Utilities\Shell\Context.reg" (
    reg import "C:\Utilities\Shell\Context.reg" >nul 2>&1
)

:: Specific context menu item removal
for %%K in (
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Utilities"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Optimise"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Record"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAC"
    "HKEY_CLASSES_ROOT\Directory\Background\shell\Z002AAA"
) do (
    reg delete "%%~K" /f >nul 2>&1
)

:: Immersive menu CLSID cleanup
reg delete "HKLM\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

:: PATH environment cleanup
powershell -nop -c "$env:PATH=[Environment]::GetEnvironmentVariable('PATH','Machine').Replace(';C:\Utilities\Data\Shortcuts',''); [Environment]::SetEnvironmentVariable('PATH',$env:PATH,'Machine')" >nul 2>&1

:: Utilities directory removal
if exist "C:\Utilities\" (
    takeown /f "C:\Utilities" /r /d y >nul 2>&1
    icacls "C:\Utilities" /grant administrators:F /t /c >nul 2>&1
    rmdir /s /q "C:\Utilities" >nul 2>&1
)

:: Legacy menu item cleanup
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\New" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shell\cmd" /f >nul 2>&1
reg delete "HKCR\Drive\shell\cmd" /f >nul 2>&1

:: Windows 11 context menu restoration
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul 2>&1

exit /b