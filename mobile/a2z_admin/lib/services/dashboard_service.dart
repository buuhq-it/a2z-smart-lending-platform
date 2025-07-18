import '../models/dashboard_models.dart';
import '../models/loan_models.dart';
import 'loan_service.dart';

class DashboardService {
  final LoanService _loanService = LoanService();
  // Mock data - sau này bạn có thể thay bằng API thật
  Future<DashboardStats> getDashboardStats() async {
    final loans = await _loanService.getAllLoanApplications();
    int totalLoans = loans.length;
    int activeLoans =
        loans.where((l) => l.appStage.toLowerCase() == 'acquisition').length;
    int completedLoans =
        loans.where((l) => l.appStage.toLowerCase() == 'esign').length;
    int overdueLoans =
        loans.where((l) => l.appStage.toLowerCase() == 'disbursement').length;
    double totalLoanAmount = loans.fold(0, (sum, l) => sum + (l.loanAmount));
    double totalRevenue =
        loans.fold(0, (sum, l) => sum + (l.loanAmount * l.loanRate));
    double pendingAmount = loans
        .where((l) => l.appStage.toLowerCase() == 'pending')
        .fold(0, (sum, l) => sum + (l.loanAmount));
    return DashboardStats(
      totalLoanAmount: totalLoanAmount,
      totalLoans: totalLoans,
      activeLoans: activeLoans,
      completedLoans: completedLoans,
      overdueLoans: overdueLoans,
      totalRevenue: totalRevenue,
      pendingAmount: pendingAmount,
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
