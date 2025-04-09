@echo off
REM filepath: d:\dev\joplin_theme\install_joplin-theme.bat

REM 获取当前用户的用户名
set "USERNAME=%USERNAME%"
set "JOPLIN_DIR=C:\Users\%USERNAME%\.config\joplin-desktop"
set "CURRENT_DIR=%~dp0"

REM 获取当前日期和时间
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set "DATE=%datetime:~0,8%"
set "TIME=%datetime:~8,6%"
set "TIME=%TIME::=-%"

REM 定义备份文件夹路径
set "BACKUP_DIR=%CURRENT_DIR%backup_joplin-theme_%DATE%_%TIME%"

REM 提示用户是否安装主题
set /p INSTALL_THEME="Do you want to install the Joplin theme? (y/n): "

if /i "%INSTALL_THEME%"=="y" (
    REM 创建备份文件夹
    if not exist "%BACKUP_DIR%" (
        mkdir "%BACKUP_DIR%"
    )

    REM 备份 userchrome.css
    if exist "%JOPLIN_DIR%\userchrome.css" (
        copy "%JOPLIN_DIR%\userchrome.css" "%BACKUP_DIR%\"
        echo userchrome.css has been backed up.
    ) else (
        echo userchrome.css does not exist, skipping backup.
    )

    REM 备份 userstyle.css
    if exist "%JOPLIN_DIR%\userstyle.css" (
        copy "%JOPLIN_DIR%\userstyle.css" "%BACKUP_DIR%\"
        echo userstyle.css has been backed up.
    ) else (
        echo userstyle.css does not exist, skipping backup.
    )

    REM 覆盖 joplin_theme 文件夹内容到 Joplin 根目录
    if exist "%CURRENT_DIR%joplin_theme" (
        xcopy "%CURRENT_DIR%joplin_theme\*" "%JOPLIN_DIR%\" /E /H /C /Y
        echo All files from joplin_theme have been copied to the Joplin directory.
    ) else (
        echo joplin_theme folder does not exist in the script directory.
    )

    REM 弹窗提示完成
    msg * "Joplin theme installation completed successfully!"
) else (
    REM 用户取消操作
    msg * "Installation canceled by the user."
)

exit /b