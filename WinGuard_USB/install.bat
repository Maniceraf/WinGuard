@echo off
setlocal enabledelayedexpansion

:: Kiểm tra quyền admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Vui lòng chạy script với quyền Administrator.
    pause
    exit /b
)

set EXE_NAME=WinGuard.exe
set INSTALL_DIR=%ProgramFiles%\WinGuard
set REG_KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Run
set REG_NAME=WinGuard

:: Tìm ổ USB chứa thư mục WinGuard
set USB_DRIVE=
for %%D in (F) do (
    if exist "%%D:\WinGuard\%EXE_NAME%" (
        set USB_DRIVE=%%D:\WinGuard\
        goto :FoundUSB
    )
)

:: Nếu không tìm thấy USB chứa file, thông báo lỗi và thoát
echo Không tìm thấy %EXE_NAME% trong thư mục WinGuard trên bất kỳ ổ USB nào. Hãy kiểm tra lại.
pause
exit /b

:FoundUSB
echo Đang cài đặt %EXE_NAME% từ ổ USB (%USB_DRIVE%) vào %INSTALL_DIR%...

:: Tạo thư mục cài đặt nếu chưa tồn tại
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Sao chép file và kiểm tra lỗi
copy "%USB_DRIVE%%EXE_NAME%" "%INSTALL_DIR%\%EXE_NAME%" /Y >nul 2>&1
if %errorLevel% neq 0 (
    echo Lỗi khi sao chép file. Kiểm tra quyền truy cập và thử lại.
    pause
    exit /b
)

:: Thêm vào khởi động cùng Windows
reg add "%REG_KEY%" /v "%REG_NAME%" /t REG_SZ /d "\"%INSTALL_DIR%\%EXE_NAME%\"" /f >nul 2>&1
if %errorLevel% neq 0 (
    echo Lỗi khi thêm vào khởi động Windows. Kiểm tra quyền admin.
    pause
    exit /b
)

echo Cài đặt hoàn tất! %EXE_NAME% sẽ tự động chạy khi khởi động lại máy.
pause
exit /b
