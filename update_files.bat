@echo off
REM filepath: d:\dev\joplin_theme\update_files.bat

REM 获取当前用户的用户名
set "USERPROFILE=%USERPROFILE%"
set "USERNAME=%USERNAME%"

REM 定义文件路径
set "JOPLIN_DIR=C:\Users\%USERNAME%\.config\joplin-desktop"
set "TYPORA_DIR=C:\Users\%USERNAME%\AppData\Roaming\Typora\themes"
set "CURRENT_DIR=%~dp0"

set "JOPLIN_THEME_DIR=%CURRENT_DIR%joplin_theme"
set "TYPORA_THEME_DIR=%CURRENT_DIR%Typora_theme"

REM 检查并复制 Joplin 文件
set "JOPLIN_ERROR=0"
if exist "%JOPLIN_DIR%\userchrome.css" (
    copy /Y "%JOPLIN_DIR%\userchrome.css" "%JOPLIN_THEME_DIR%\"
) else (
    echo userchrome.css does not exist
    set "JOPLIN_ERROR=1"
)

if exist "%JOPLIN_DIR%\userstyle.css" (
    copy /Y "%JOPLIN_DIR%\userstyle.css" "%JOPLIN_THEME_DIR%\"
) else (
    echo userstyle.css does not exist
    set "JOPLIN_ERROR=1"
)

REM 检查并复制 Typora 文件
set "TYPORA_ERROR=0"
if exist "%TYPORA_DIR%\drake-light.css" (
    copy /Y "%TYPORA_DIR%\drake-light.css" "%TYPORA_THEME_DIR%\"
) else (
    echo drake-light.css does not exist
    set "TYPORA_ERROR=1"
)

REM 检查错误并弹窗提示
if %JOPLIN_ERROR%==1 (
    msg * "Joplin files are missing. Operation not completed!"
) else if %TYPORA_ERROR%==1 (
    msg * "Typora files are missing. Operation not completed!"
) else (
    msg * "All files have been successfully copied. Process completed!"
)

exit /b