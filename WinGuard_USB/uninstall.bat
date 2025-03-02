@echo off
setlocal

:: Kiểm tra quyền admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Vui lòng chạy script với quyền Administrator.
    pause
    exit /b
)

set INSTALL_DIR=%ProgramFiles%\WinGuard
set REG_KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Run
set REG_NAME=WinGuard
set EXE_NAME=WinGuard.exe

:: Kiểm tra và dừng tiến trình nếu đang chạy
tasklist | find /i "%EXE_NAME%" >nul
if %errorLevel% equ 0 (
    echo Đang dừng tiến trình %EXE_NAME%...
    taskkill /f /im "%EXE_NAME%" >nul 2>&1
    timeout /t 2 >nul
)

:: Xóa khỏi registry
echo Xóa WinGuard khỏi khởi động Windows...
reg delete "%REG_KEY%" /v "%REG_NAME%" /f >nul 2>&1
if %errorLevel% neq 0 (
    echo Không tìm thấy khóa registry. Có thể đã bị xóa trước đó.
)

:: Xóa thư mục cài đặt nếu tồn tại
if exist "%INSTALL_DIR%" (
    echo Xóa thư mục cài đặt...
    rd /s /q "%INSTALL_DIR%"
    if exist "%INSTALL_DIR%" (
        echo Lỗi: Không thể xóa thư mục. Hãy kiểm tra lại quyền truy cập.
        pause
        exit /b
    )
) else (
    echo Thư mục cài đặt không tồn tại. Có thể đã bị xóa trước đó.
)

echo Gỡ cài đặt thành công!
pause
exit /b
