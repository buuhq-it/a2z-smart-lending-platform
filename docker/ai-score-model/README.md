# API Dự Đoán Khả Năng Trả Nợ

## 🎯 Giới thiệu
API dự đoán khả năng trả nợ sử dụng thuật toán **Improved Random Forest** đã được train sẵn.

## ⚡ Cài đặt & Chạy (2 phút)

### 1. Cài đặt dependencies
```bash
pip install -r requirements.txt
```

### 2. Khởi động API
```bash
python start_api.py
```

API sẽ chạy tại: `http://localhost:5000`

## 🌐 Sử dụng API

### Endpoints có sẵn:
- `GET /` - Trang chủ và hướng dẫn
- `POST /predict` - Dự đoán đơn lẻ  
- `POST /batch_predict` - Dự đoán hàng loạt
- `GET /model_info` - Thông tin model
- `GET /health` - Kiểm tra trạng thái

### Ví dụ dự đoán:

#### Dự đoán đơn lẻ
```bash
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "AMT_INCOME_TOTAL": 162297.0,
    "AMT_CREDIT": 406597.5,
    "AMT_ANNUITY": 24700.5,
    "AMT_GOODS_PRICE": 351000.0,
    "DAYS_BIRTH": -9461,
    "DAYS_EMPLOYED": -637,
    "CNT_CHILDREN": 0,
    "FLAG_OWN_CAR": 0,
    "FLAG_OWN_REALTY": 1
  }'
```

#### Kết quả:
```json
{
  "status": "success",
  "prediction": {
    "prediction": 0,
    "probability_default": 0.15,
    "probability_repaid": 0.85,
    "risk_level": "Low"
  },
  "timestamp": "2025-06-28T11:45:00"
}
```

#### Dự đoán hàng loạt
```bash
curl -X POST http://localhost:5000/batch_predict \
  -H "Content-Type: application/json" \
  -d '{
    "data": [
      {"AMT_INCOME_TOTAL": 150000.0, "AMT_CREDIT": 300000.0, ...},
      {"AMT_INCOME_TOTAL": 80000.0, "AMT_CREDIT": 150000.0, ...}
    ]
  }'
```

## 📊 Thông tin Model

- **Thuật toán**: Improved Random Forest với C5.0 enhancements
- **Độ chính xác**: >90% 
- **Thời gian phản hồi**: <200ms
- **Xử lý class imbalance**: Có

## 🔧 Yêu cầu hệ thống

- Python 3.8+
- RAM: 2GB
- CPU: 1 core
- Dung lượng: 50MB

## ❓ Xử lý lỗi

**API không khởi động được:**
```bash
# Kiểm tra model files
dir models\*.pkl

# Kiểm tra dependencies  
pip install -r requirements.txt
```

**Lỗi prediction:**
- Đảm bảo đúng format JSON
- Kiểm tra tên các trường dữ liệu
- Xem log để biết chi tiết lỗi

## 📞 Hỗ trợ

Truy cập `http://localhost:5000` khi API đang chạy để xem hướng dẫn chi tiết.

---
**🎯 Sẵn sàng để dự đoán khả năng trả nợ với độ chính xác cao!** 