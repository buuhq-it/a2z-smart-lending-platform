import '../models/dashboard_models.dart';

class DashboardService {
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
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      LoanSummary(
        id: 'LN001',
        customerName: 'Nguyễn Văn An',
        amount: 50000000,
        status: 'active',
        dueDate: DateTime.now().add(const Duration(days: 15)),
        phoneNumber: '0901234567',
      ),
      LoanSummary(
        id: 'LN002',
        customerName: 'Trần Thị Bình',
        amount: 30000000,
        status: 'overdue',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        phoneNumber: '0912345678',
      ),
      LoanSummary(
        id: 'LN003',
        customerName: 'Lê Văn Cường',
        amount: 75000000,
        status: 'pending',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        phoneNumber: '0923456789',
      ),
      LoanSummary(
        id: 'LN004',
        customerName: 'Phạm Thị Dung',
        amount: 25000000,
        status: 'completed',
        dueDate: DateTime.now().subtract(const Duration(days: 10)),
        phoneNumber: '0934567890',
      ),
      LoanSummary(
        id: 'LN005',
        customerName: 'Hoàng Văn Em',
        amount: 60000000,
        status: 'active',
        dueDate: DateTime.now().add(const Duration(days: 20)),
        phoneNumber: '0945678901',
      ),
    ];
  }
}
