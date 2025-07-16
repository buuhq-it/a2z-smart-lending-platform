import 'package:flutter/material.dart';

class PredictionRequest {
  final double amtIncomeTotal;
  final double amtCredit;
  final double amtAnnuity;
  final double amtGoodsPrice;
  final int daysBirth;
  final int daysEmployed;
  final int cntChildren;
  final int flagOwnCar;
  final int flagOwnRealty;
  final double extSource2;

  PredictionRequest({
    required this.amtIncomeTotal,
    required this.amtCredit,
    required this.amtAnnuity,
    required this.amtGoodsPrice,
    required this.daysBirth,
    required this.daysEmployed,
    required this.cntChildren,
    required this.flagOwnCar,
    required this.flagOwnRealty,
    required this.extSource2,
  });

  Map<String, dynamic> toJson() {
    return {
      'AMT_INCOME_TOTAL': amtIncomeTotal,
      'AMT_CREDIT': amtCredit,
      'AMT_ANNUITY': amtAnnuity,
      'AMT_GOODS_PRICE': amtGoodsPrice,
      'DAYS_BIRTH': daysBirth,
      'DAYS_EMPLOYED': daysEmployed,
      'CNT_CHILDREN': cntChildren,
      'FLAG_OWN_CAR': flagOwnCar,
      'FLAG_OWN_REALTY': flagOwnRealty,
      'EXT_SOURCE_2': extSource2,
    };
  }
}

class PredictionResponse {
  final String status;
  final PredictionResult prediction;
  final String timestamp;

  PredictionResponse({
    required this.status,
    required this.prediction,
    required this.timestamp,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      status: json['status'] ?? '',
      prediction: PredictionResult.fromJson(json['prediction'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class PredictionResult {
  final int prediction;
  final double probabilityDefault;
  final double probabilityRepaid;
  final String riskLevel;

  PredictionResult({
    required this.prediction,
    required this.probabilityDefault,
    required this.probabilityRepaid,
    required this.riskLevel,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction: json['prediction'] ?? 0,
      probabilityDefault: (json['probability_default'] ?? 0.0).toDouble(),
      probabilityRepaid: (json['probability_repaid'] ?? 0.0).toDouble(),
      riskLevel: json['risk_level'] ?? 'Unknown',
    );
  }

  Color get riskColor {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get riskIcon {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Icons.check_circle;
      case 'medium':
        return Icons.warning;
      case 'high':
        return Icons.error;
      default:
        return Icons.help;
    }
  }
}
