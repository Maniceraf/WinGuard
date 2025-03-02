# 🛡 WinGuard

**WinGuard** is a Windows screen-locking tool that enhances security by requiring a password to unlock and blocking dangerous key combinations. It can run directly from a USB drive or be installed on the system for automatic startup.

## 🔹 Features
- 🔒 **Screen Lock**: Requires a password to unlock the screen.
- 🚫 **Blocks Key Combinations**: Prevents the use of `Ctrl + Alt + Del`, `Alt + F4`, `Win + D`, and other shortcuts.
- 🔄 **Auto Startup**: Can be configured to run automatically when Windows starts.
- 💾 **Runs from USB**: Supports running the application directly from a USB drive.
- 🛠 **SQLite Database**: Stores credentials securely in a local SQLite database.

## 🚀 Installation
### **Run from USB**
1. Copy `WinGuard.exe` to your USB drive (e.g., `F:\WinGuard.exe`).
2. Run the executable to start the lock screen.

### **Install on Windows**
1. Copy `WinGuard.exe` to the `C:\Program Files\WinGuard` directory.
2. Use the following `.bat` script to set it up for auto-start:
   ```bat
   @echo off
   set EXE_NAME=WinGuard.exe
   set INSTALL_DIR=C:\Program Files\WinGuard
   set REG_KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Run
   set REG_NAME=WinGuard
   
   echo Installing %EXE_NAME% to %INSTALL_DIR%...
   mkdir "%INSTALL_DIR%" >nul 2>&1
   copy "%~dp0%EXE_NAME%" "%INSTALL_DIR%\%EXE_NAME%" /Y
   
   echo Adding WinGuard to startup...
   reg add "%REG_KEY%" /v "%REG_NAME%" /t REG_SZ /d "\"%INSTALL_DIR%\%EXE_NAME%\"" /f
   
   echo Installation complete! WinGuard will start automatically on boot.
   pause
   ```
3. Run the batch file as Administrator.
4. Restart your computer to apply the changes.

## 🔑 Default Password
- **Username:** `admin`
- **Password:** `1234`
- (You can modify the password in the SQLite database: `users.db`)

## ❓ How to Unlock
1. Enter the correct password.
2. Click **Confirm** to unlock the screen.

## ⚠️ Warning
- Once locked, the only way to unlock is by entering the correct password.
- If the database file is deleted, the default password will reset.

## 📌 License
This project is open-source under the [MIT License](LICENSE).

## 🌍 Contributing
Feel free to submit pull requests or report issues!

🔗 **GitHub Repo:** [github.com/your-repo/WinGuard](https://github.com/your-repo/WinGuard)
