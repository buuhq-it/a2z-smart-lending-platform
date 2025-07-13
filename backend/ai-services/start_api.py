#!/usr/bin/env python3
"""
Khởi động API dự đoán khả năng trả nợ

Sử dụng: python start_api.py
API sẽ chạy tại: http://localhost:5000
"""

import os
import sys
import subprocess

def main():
    print("🚀 Đang khởi động API dự đoán khả năng trả nợ...")
    print("📊 Sử dụng model Improved Random Forest đã train sẵn")
    print("🌐 API sẽ chạy tại: http://localhost:5000")
    print("📚 Truy cập http://localhost:5000 để xem hướng dẫn API")
    print("\nNhấn Ctrl+C để dừng server\n")
    
    try:
        subprocess.run([sys.executable, "app.py"], check=True)
    except KeyboardInterrupt:
        print("\n🛑 API đã dừng")
    except Exception as e:
        print(f"❌ Lỗi: {e}")

if __name__ == "__main__":
    main() 