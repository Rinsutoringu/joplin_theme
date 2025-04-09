@echo off
REM filepath: d:\dev\joplin_theme\install_themes.bat

REM 获取当前用户的用户名
set "USERNAME=%USERNAME%"
set "JOPLIN_DIR=C:\Users\%USERNAME%\.config\joplin-desktop"
set "TYPORA_DIR=C:\Users\%USERNAME%\AppData\Roaming\Typora\themes"
set "CURRENT_DIR=%~dp0"

REM 获取当前日期和时间
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set "DATE=%datetime:~0,8%"
set "TIME=%datetime:~8,6%"
set "TIME=%TIME::=-%"

REM 定义备份文件夹路径
set "JOPLIN_BACKUP_DIR=%CURRENT_DIR%backup_joplin-theme_%DATE%_%TIME%"
set "TYPORA_BACKUP_DIR=%CURRENT_DIR%backup_typora-theme_%DATE%_%TIME%"

REM 提示用户选择安装选项
echo Please select an option:
echo [1] Install both Joplin and Typora themes
echo [2] Install Joplin theme only
echo [3] Install Typora theme only
echo [4] Do not install anything
set /p CHOICE="Enter your choice (1/2/3/4): "

if "%CHOICE%"=="4" (
    echo No themes will be installed. Exiting...
    exit /b
)

REM 二次确认
if "%CHOICE%"=="1" (
    set "CONFIRM_TEXT=Are you sure you want to install both Joplin and Typora themes? (y/n): "
) else if "%CHOICE%"=="2" (
    set "CONFIRM_TEXT=Are you sure you want to install the Joplin theme only? (y/n): "
) else if "%CHOICE%"=="3" (
    set "CONFIRM_TEXT=Are you sure you want to install the Typora theme only? (y/n): "
)

set /p CONFIRM="%CONFIRM_TEXT%"
if /i not "%CONFIRM%"=="y" (
    echo Operation canceled by the user.
    exit /b
)

REM 安装 Joplin 主题
if "%CHOICE%"=="1" (
    call :install_joplin
    call :install_typora
) else if "%CHOICE%"=="2" (
    call :install_joplin
) else if "%CHOICE%"=="3" (
    call :install_typora
)

REM 提示完成
msg * "Theme installation process completed successfully!"
exit /b

:install_joplin
    echo Installing Joplin theme...
    REM 创建备份文件夹
    if not exist "%JOPLIN_BACKUP_DIR%" (
        mkdir "%JOPLIN_BACKUP_DIR%"
    )

    REM 备份 userchrome.css
    if exist "%JOPLIN_DIR%\userchrome.css" (
        copy "%JOPLIN_DIR%\userchrome.css" "%JOPLIN_BACKUP_DIR%\" >nul
        echo userchrome.css has been backed up.
    ) else (
        echo userchrome.css does not exist, skipping backup.
    )

    REM 备份 userstyle.css
    if exist "%JOPLIN_DIR%\userstyle.css" (
        copy "%JOPLIN_DIR%\userstyle.css" "%JOPLIN_BACKUP_DIR%\" >nul
        echo userstyle.css has been backed up.
    ) else (
        echo userstyle.css does not exist, skipping backup.
    )

    REM 覆盖 joplin_theme 文件夹内容到 Joplin 根目录
    if exist "%CURRENT_DIR%joplin_theme" (
        xcopy "%CURRENT_DIR%joplin_theme\*" "%JOPLIN_DIR%\" /E /H /C /Y >nul
        echo All files from joplin_theme have been copied to the Joplin directory.
    ) else (
        echo joplin_theme folder does not exist in the script directory.
    )
    goto :eof

:install_typora
    echo Installing Typora theme...
    REM 创建备份文件夹
    if not exist "%TYPORA_BACKUP_DIR%" (
        mkdir "%TYPORA_BACKUP_DIR%"
    )

    REM 备份 Typora 主题文件夹
    if exist "%TYPORA_DIR%" (
        xcopy "%TYPORA_DIR%\*" "%TYPORA_BACKUP_DIR%\" /E /H /C /Y >nul
        echo Typora themes have been backed up to %TYPORA_BACKUP_DIR%.
    ) else (
        echo Typora themes folder does not exist, skipping backup.
    )

    REM 覆盖 typora_theme 文件夹内容到 Typora 主题目录
    if exist "%CURRENT_DIR%typora_theme" (
        xcopy "%CURRENT_DIR%typora_theme\*" "%TYPORA_DIR%\" /E /H /C /Y >nul
        echo All files from typora_theme have been copied to the Typora themes directory.
    ) else (
        echo typora_theme folder does not exist in the script directory.
    )
    goto :eof