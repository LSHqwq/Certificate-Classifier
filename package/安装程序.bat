@echo off
chcp 65001 >nul
echo ================================================
echo    图像识别分类器 - 安装程序
echo ================================================
echo.

set "INSTALL_DIR=%LOCALAPPDATA%\图像识别分类器"
set "TESSERACT_URL=https://github.com/tesseract-ocr/tesseract/releases/download/5.4.0.20240606/tesseract-ocr-w64-setup-5.4.0.20240606.exe"
set "TESSERACT_SETUP=%TEMP%\tesseract-setup.exe"

echo [1/4] 创建安装目录...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\tesseract" mkdir "%INSTALL_DIR%\tesseract"
if not exist "%INSTALL_DIR%\app" mkdir "%INSTALL_DIR%\app"
echo      完成！
echo.

echo [2/4] 检查Tesseract OCR...
where tesseract >nul 2>&1
if %errorlevel% equ 0 (
    echo      检测到Tesseract OCR已安装
    set "TESSERACT_READY=1"
) else (
    echo      Tesseract OCR未安装
    echo      请手动下载并安装Tesseract OCR
    echo      下载地址: https://github.com/tesseract-ocr/tesseract/releases
    echo.
    echo      安装时请选择安装中文语言包
    echo.
    echo      安装完成后，请运行"开始分类"快捷方式启动程序
    echo      或者手动将Tesseract添加到系统PATH环境变量
    set "TESSERACT_READY=0"
)
echo.

echo [3/4] 复制程序文件...
xcopy /E /Y /Q "%~dp0app\*" "%INSTALL_DIR%\app\" >nul 2>&1
echo      完成！
echo.

echo [4/4] 创建快捷方式...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=%DESKTOP%\开始分类.lnk"

echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\createshortcut.vbs"
echo Set oShortcut = WshShell.CreateShortcut("%SHORTCUT%") >> "%TEMP%\createshortcut.vbs"
echo oShortcut.TargetPath = "%INSTALL_DIR%\app\图像识别分类器.exe" >> "%TEMP%\createshortcut.vbs"
echo oShortcut.WorkingDirectory = "%INSTALL_DIR%\app" >> "%TEMP%\createshortcut.vbs"
echo oShortcut.Description = "图像识别分类器" >> "%TEMP%\createshortcut.vbs"
echo oShortcut.IconLocation = "%INSTALL_DIR%\app\图像识别分类器.exe,0" >> "%TEMP%\createshortcut.vbs"
echo oShortcut.Save >> "%TEMP%\createshortcut.vbs"

cscript //B "%TEMP%\createshortcut.vbs"
del /F /Q "%TEMP%\createshortcut.vbs" >nul 2>&1
echo      完成！
echo.

echo ================================================
echo    安装完成！
echo ================================================
echo.
if %TESSERACT_READY% equ 1 (
    echo   点击桌面上的"开始分类"快捷方式启动程序
) else (
    echo   警告: 请先安装Tesseract OCR
    echo   安装说明:
    echo   1. 访问: https://github.com/tesseract-ocr/tesseract/releases
    echo   2. 下载 tesseract-ocr-w64-setup-5.4.0.20240606.exe
    echo   3. 运行安装程序，选择安装中文语言包
    echo   4. 安装完成后，点击"开始分类"启动程序
)
echo.
echo   程序目录: %INSTALL_DIR%
echo.
pause