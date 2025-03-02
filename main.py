import sys
import sqlite3
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QLineEdit, QPushButton, QVBoxLayout
from PyQt5.QtCore import Qt
import keyboard

# ================================
# 🔹 CHẶN TỔ HỢP PHÍM NGUY HIỂM
# ================================

blocked_keys = ["esc", "alt", "ctrl", "win", "tab"]
for key in blocked_keys:
    keyboard.block_key(key)

keyboard.add_hotkey("alt+tab", lambda: None, suppress=True)
keyboard.add_hotkey("win+d", lambda: None, suppress=True)

# ================================
# 🔹 KẾT NỐI DATABASE SQLITE
# ================================

conn = sqlite3.connect("users.db")
cursor = conn.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS users (username TEXT, password TEXT)")
conn.commit()

cursor.execute("SELECT * FROM users WHERE username='admin'")
if cursor.fetchone() is None:
    cursor.execute("INSERT INTO users VALUES ('admin', '1234')")  # Mật khẩu mặc định là 1234
    conn.commit()

# ================================
# 🔹 MÀN HÌNH KHÓA
# ================================

class LockScreen(QWidget):
    password_verified = False  # Biến theo dõi trạng thái đăng nhập

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        """Cấu hình giao diện khóa màn hình"""
        self.setWindowFlags(Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.X11BypassWindowManagerHint)
        self.showFullScreen()

        self.layout = QVBoxLayout()

        self.label = QLabel("🔒 Nhập mã PIN hoặc mật khẩu để tiếp tục")
        self.layout.addWidget(self.label)

        self.password_input = QLineEdit()
        self.password_input.setEchoMode(QLineEdit.Password)
        self.layout.addWidget(self.password_input)

        self.btn_login = QPushButton("Xác nhận")
        self.btn_login.clicked.connect(self.check_password)
        self.layout.addWidget(self.btn_login)

        self.setLayout(self.layout)

    def check_password(self):
        """Kiểm tra mật khẩu"""
        cursor.execute("SELECT password FROM users WHERE username='admin'")
        correct_password = cursor.fetchone()[0]

        if self.password_input.text() == correct_password:
            print("✅ Đúng mật khẩu, thoát chương trình!")
            LockScreen.password_verified = True  # Đánh dấu đã nhập đúng mật khẩu
            self.close()
        else:
            print("❌ Sai mật khẩu!")
            self.label.setText("❌ Sai mật khẩu! Thử lại.")

    def closeEvent(self, event):
        """Chặn Alt + F4, chỉ cho phép đóng khi nhập đúng mật khẩu"""
        if LockScreen.password_verified:
            event.accept()  # Cho phép đóng nếu đã nhập đúng mật khẩu
        else:
            event.ignore()  # Ngăn đóng nếu chưa nhập đúng mật khẩu
            print("🚫 Không thể thoát nếu chưa nhập đúng mật khẩu!")

# ================================
# 🔹 CHẠY ỨNG DỤNG
# ================================

app = QApplication(sys.argv)
lockscreen = LockScreen()
lockscreen.show()
sys.exit(app.exec_())