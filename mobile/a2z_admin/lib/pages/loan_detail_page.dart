import 'package:flutter/material.dart';
import '../models/loan_models.dart';
import '../services/loan_service.dart';

class LoanDetailPage extends StatefulWidget {
  final int loanAppId;
  const LoanDetailPage({super.key, required this.loanAppId});

  @override
  State<LoanDetailPage> createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  final LoanService _loanService = LoanService();
  late Future<LoanApplication> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _loanService.getLoanDetail(widget.loanAppId);
  }

  Widget _infoRow(
      {required IconData icon,
      required String label,
      required String value,
      Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey[400]),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết khoản vay'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<LoanApplication>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy khoản vay.'));
          }
          final loan = snapshot.data!;
          final isEsign = loan.appStage.toLowerCase() == 'esign';
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (isEsign)
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: SizedBox(
                    height: 44,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final success = await _loanService
                              .approveLoanApplication(loan.processInstance);
                          if (success) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Duyệt khoản vay thành công!'),
                                    backgroundColor: Colors.green),
                              );
                              setState(() {
                                _futureDetail = _loanService
                                    .getLoanDetail(widget.loanAppId);
                              });
                              Navigator.pop(context,
                                  true); // Báo về trang trước để reload list
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        elevation: 0,
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_circle,
                              size: 36, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(loan.customerFullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Text('Mã hồ sơ: ${loan.id}',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _infoRow(
                          icon: Icons.badge,
                          label: 'CMND/CCCD',
                          value: loan.customerNationalId),
                      _infoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: loan.customerEmail),
                      _infoRow(
                          icon: Icons.phone,
                          label: 'SĐT',
                          value: loan.customerPhone),
                      _infoRow(
                          icon: Icons.home,
                          label: 'Địa chỉ',
                          value: loan.customerAddress),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monetization_on,
                              color: Colors.green[700], size: 28),
                          const SizedBox(width: 8),
                          const Text('Thông tin khoản vay',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _infoRow(
                          icon: Icons.attach_money,
                          label: 'Số tiền vay',
                          value: '${loan.loanAmount} VNĐ',
                          valueColor: Colors.green[800]),
                      _infoRow(
                          icon: Icons.percent,
                          label: 'Lãi suất',
                          value:
                              '${(loan.loanRate * 100).toStringAsFixed(2)}%'),
                      _infoRow(
                          icon: Icons.schedule,
                          label: 'Thời hạn',
                          value: '${loan.tenor} tháng'),
                      _infoRow(
                          icon: Icons.account_balance_wallet,
                          label: 'Thu nhập',
                          value: '${loan.income} VNĐ'),
                      _infoRow(
                          icon: Icons.cake,
                          label: 'Tuổi',
                          value: '${loan.age}'),
                      _infoRow(
                          icon: Icons.family_restroom,
                          label: 'Số con',
                          value: '${loan.numberOfChildren}'),
                      _infoRow(
                          icon: Icons.directions_car,
                          label: 'Sở hữu ô tô',
                          value: loan.hasOwnCar ? 'Có' : 'Không'),
                      _infoRow(
                          icon: Icons.house,
                          label: 'Sở hữu BĐS',
                          value: loan.hasOwnRealty ? 'Có' : 'Không'),
                      _infoRow(
                          icon: Icons.wc,
                          label: 'Giới tính',
                          value: loan.gender == 0 ? 'Nam' : 'Nữ'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700], size: 28),
                          const SizedBox(width: 8),
                          const Text('Trạng thái hồ sơ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Chip(
                            label: Text(loan.appStatus,
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor:
                                loan.appStatus.toLowerCase() == 'approved'
                                    ? Colors.green
                                    : loan.appStatus.toLowerCase() == 'rejected'
                                        ? Colors.red
                                        : Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            label: Text(loan.appStage,
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor:
                                loan.appStage.toLowerCase() == 'esign'
                                    ? Colors.blue
                                    : loan.appStage.toLowerCase() == 'completed'
                                        ? Colors.green
                                        : Colors.orange,
                          ),
                        ],
                      ),
                      if (loan.reason != null && loan.reason!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.error,
                                  color: Colors.red, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Lý do từ chối: ${loan.reason}',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
