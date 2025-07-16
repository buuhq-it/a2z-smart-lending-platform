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
  final String status;
  final DateTime dueDate;
  final String phoneNumber;

  LoanSummary({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.dueDate,
    required this.phoneNumber,
  });
}

enum LoanStatus {
  pending('Chờ duyệt', Colors.orange),
  active('Đang vay', Colors.blue),
  completed('Hoàn thành', Colors.green),
  overdue('Quá hạn', Colors.red);

  const LoanStatus(this.label, this.color);
  final String label;
  final Color color;
}
