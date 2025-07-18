import 'package:flutter/material.dart';
import '../models/loan_models.dart';
import '../services/loan_service.dart';
import '../models/dashboard_models.dart';
import '../widgets/loan_list_item.dart';

class LoanListPage extends StatefulWidget {
  const LoanListPage({super.key});

  @override
  State<LoanListPage> createState() => _LoanListPageState();
}

class _LoanListPageState extends State<LoanListPage> {
  final LoanService _loanService = LoanService();
  late Future<List<LoanApplication>> _futureLoans;

  @override
  void initState() {
    super.initState();
    _futureLoans = _loanService.getAllLoanApplications();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureLoans = _loanService.getAllLoanApplications();
    });
  }

  LoanSummary _toLoanSummary(LoanApplication loan) {
    return LoanSummary(
      id: loan.processInstance.toString(),
      customerName: loan.customerFullName,
      amount: loan.loanAmount.toDouble(),
      appStatus: loan.appStatus,
      appStage: loan.appStage,
      reason: loan.reason,
      dueDate: DateTime.now().add(Duration(days: 30)),
      phoneNumber: loan.customerPhone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách khoản vay'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<LoanApplication>>(
          future: _futureLoans,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có khoản vay nào.'));
            }
            final loans = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final loan = loans[index];
                return LoanListItem(
                  loan: _toLoanSummary(loan),
                  onTap: () async {
                    // Xem chi tiết hoặc thao tác khác nếu cần
                  },
                  onApprove: () async {
                    try {
                      final success = await _loanService
                          .approveLoanApplication(loan.processInstance);
                      if (success) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Duyệt khoản vay thành công!'),
                                backgroundColor: Colors.green),
                          );
                          _refresh();
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Duyệt khoản vay thất bại!'),
                                backgroundColor: Colors.red),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Lỗi: $e'),
                              backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
