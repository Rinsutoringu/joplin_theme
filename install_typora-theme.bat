@echo off
REM filepath: d:\dev\joplin_theme\install_typora-theme.bat

REM 获取当前用户的用户名
set "USERNAME=%USERNAME%"
set "TYPORA_DIR=C:\Users\%USERNAME%\AppData\Roaming\Typora\themes"
set "CURRENT_DIR=%~dp0"

REM 获取当前日期和时间
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set "DATE=%datetime:~0,8%"
set "TIME=%datetime:~8,6%"
set "TIME=%TIME::=-%"

REM 定义备份文件夹路径
set "BACKUP_DIR=%CURRENT_DIR%backup_typora-theme_%DATE%_%TIME%"

REM 提示用户是否安装主题
set /p INSTALL_THEME="Do you want to install the Typora theme? (y/n): "

if /i "%INSTALL_THEME%"=="y" (
    REM 创建备份文件夹
    if not exist "%BACKUP_DIR%" (
        mkdir "%BACKUP_DIR%"
    )

    REM 备份 Typora 主题文件夹
    if exist "%TYPORA_DIR%" (
        xcopy "%TYPORA_DIR%\*" "%BACKUP_DIR%\" /E /H /C /Y
        echo Typora themes have been backed up to %BACKUP_DIR%.
    ) else (
        echo Typora themes folder does not exist, skipping backup.
    )

    REM 覆盖 typora_theme 文件夹内容到 Typora 主题目录
    if exist "%CURRENT_DIR%typora_theme" (
        xcopy "%CURRENT_DIR%typora_theme\*" "%TYPORA_DIR%\" /E /H /C /Y
        echo All files from typora_theme have been copied to the Typora themes directory.
    ) else (
        echo typora_theme folder does not exist in the script directory.
    )

    REM 弹窗提示完成
    msg * "Typora theme installation completed successfully!"
) else (
    REM 用户取消操作
    msg * "Installation canceled by the user."
)

exit /b