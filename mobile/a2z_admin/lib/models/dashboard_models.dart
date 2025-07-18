import 'package:flutter/material.dart';

class DashboardStats {
  final double totalLoanAmount;
  final int totalLoans;
  final int activeLoans;
  final int completedLoans;
  final int overdueLoans;
  final double totalRevenue;
  final double pendingAmount;

  DashboardStats({
    required this.totalLoanAmount,
    required this.totalLoans,
    required this.activeLoans,
    required this.completedLoans,
    required this.overdueLoans,
    required this.totalRevenue,
    required this.pendingAmount,
  });
}

class LoanSummary {
  final String id;
  final String customerName;
  final double amount;
  final String appStatus;
  final String appStage;
  final String? reason;
  final DateTime dueDate;
  final String phoneNumber;

  LoanSummary({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.appStatus,
    required this.appStage,
    this.reason,
    required this.dueDate,
    required this.phoneNumber,
  });
}

enum StatusApp {
  pending('Chờ duyệt', Colors.orange),
  approved('Đã duyệt', Colors.green),
  rejected('Từ chối', Colors.red);

  const StatusApp(this.label, this.color);
  final String label;
  final Color color;
}

enum StatusStage {
  acquisition('Tiếp nhận hồ sơ', Colors.orange),
  esign('Ký hợp đồng', Colors.blue),
  completed('Hoàn thành', Colors.green),
  other('Khác', Colors.grey);

  const StatusStage(this.label, this.color);
  final String label;
  final Color color;

  static StatusStage fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'acquisition':
        return StatusStage.acquisition;
      case 'esign':
        return StatusStage.esign;
      case 'completed':
        return StatusStage.completed;
      default:
        return StatusStage.other;
    }
  }
}
