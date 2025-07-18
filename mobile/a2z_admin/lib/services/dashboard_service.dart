import '../models/dashboard_models.dart';
import '../models/loan_models.dart';
import 'loan_service.dart';

class DashboardService {
  final LoanService _loanService = LoanService();
  // Mock data - sau này bạn có thể thay bằng API thật
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    return DashboardStats(
      totalLoanAmount: 2500000000, // 2.5 tỷ
      totalLoans: 1250,
      activeLoans: 850,
      completedLoans: 320,
      overdueLoans: 80,
      totalRevenue: 125000000, // 125 triệu
      pendingAmount: 450000000, // 450 triệu
    );
  }

  Future<List<LoanSummary>> getRecentLoans() async {
    final loans = await _loanService.getAllLoanApplications();
    // Lọc các khoản vay theo các trạng thái chính
    final filtered = loans.where((l) {
      final status = l.appStage.toLowerCase();
      return status == 'acquisition' ||
          status == 'approval' ||
          status == 'disbursement' ||
          status == 'repayment' ||
          status == 'esign' ||
          status == 'completed';
    }).toList();
    // Sắp xếp theo id giảm dần (mới nhất trước)
    filtered.sort((a, b) => b.id.compareTo(a.id));
    // Lấy 5 khoản vay gần nhất
    return filtered
        .take(5)
        .map((loan) => LoanSummary(
              id: loan.id.toString(),
              customerName: loan.customerFullName,
              amount: loan.loanAmount.toDouble(),
              appStatus: loan.appStatus,
              appStage: loan.appStage,
              reason: loan.reason,
              dueDate: DateTime.now()
                  .add(const Duration(days: 30)), // Không có trường dueDate
              phoneNumber: loan.customerPhone,
            ))
        .toList();
  }
}
