#!/usr/bin/env python3
"""
Test script đơn giản để kiểm tra API

Chạy script này sau khi khởi động API để test thử
"""

import requests
import json

API_URL = "http://localhost:5000"

def test_health():
    """Test health endpoint"""
    try:
        response = requests.get(f"{API_URL}/health")
        print("🔍 Health Check:")
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False

def test_model_info():
    """Test model info endpoint"""
    try:
        response = requests.get(f"{API_URL}/model_info")
        print("\n📊 Model Info:")
        print(f"Status: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Model info failed: {e}")
        return False

def test_prediction():
    """Test prediction endpoint"""
    test_data = {
        "AMT_INCOME_TOTAL": 162297.0,
        "AMT_CREDIT": 406597.5,
        "AMT_ANNUITY": 24700.5,
        "AMT_GOODS_PRICE": 351000.0,
        "DAYS_BIRTH": -9461,
        "DAYS_EMPLOYED": -637,
        "CNT_CHILDREN": 0,
        "FLAG_OWN_CAR": 0,
        "FLAG_OWN_REALTY": 1
    }
    
    try:
        response = requests.post(
            f"{API_URL}/predict", 
            json=test_data,
            headers={'Content-Type': 'application/json'}
        )
        print("\n🎯 Prediction Test:")
        print(f"Status: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Prediction failed: {e}")
        return False

def main():
    print("🧪 Testing API Dự Đoán Khả Năng Trả Nợ")
    print("=" * 50)
    print("Đảm bảo API đang chạy tại http://localhost:5000")
    print()
    
    # Test all endpoints
    health_ok = test_health()
    model_ok = test_model_info()
    predict_ok = test_prediction()
    
    print("\n" + "=" * 50)
    if health_ok and model_ok and predict_ok:
        print("✅ Tất cả tests PASS! API hoạt động tốt.")
    else:
        print("❌ Có lỗi xảy ra. Kiểm tra lại API.")
    
    print("\n💡 Để test thêm, truy cập: http://localhost:5000")

if __name__ == "__main__":
    main() 