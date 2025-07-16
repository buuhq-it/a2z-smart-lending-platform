import 'package:a2z_admin/pages/risk_prediction_page.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../services/dashboard_service.dart';
import '../services/token_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/loan_list_item.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DashboardService _dashboardService = DashboardService();
  DashboardStats? _stats;
  List<LoanSummary> _recentLoans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final stats = await _dashboardService.getDashboardStats();
      final loans = await _dashboardService.getRecentLoans();
      
      if (mounted) {
        setState(() {
          _stats = stats;
          _recentLoans = loans;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải dữ liệu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await TokenService.clearToken();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'A2Z Smart Lending',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 8),
                    Text('Thông tin cá nhân'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Cài đặt'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng thông tin cá nhân')),
                  );
                  break;
                case 'settings':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng cài đặt')),
                  );
                  break;
                case 'logout':
                  _handleLogout();
                  break;
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[600]!, Colors.blue[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chào mừng Admin!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hôm nay là ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats grid
                    if (_stats != null) ...[
                      const Text(
                        'Tổng quan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          StatCard(
                            title: 'Tổng số khoản vay',
                            value: formatNumber(_stats!.totalLoans),
                            icon: Icons.receipt_long,
                            color: Colors.blue,
                          ),
                          StatCard(
                            title: 'Đang hoạt động',
                            value: formatNumber(_stats!.activeLoans),
                            icon: Icons.trending_up,
                            color: Colors.green,
                          ),
                          StatCard(
                            title: 'Quá hạn',
                            value: formatNumber(_stats!.overdueLoans),
                            icon: Icons.warning,
                            color: Colors.red,
                          ),
                          StatCard(
                            title: 'Hoàn thành',
                            value: formatNumber(_stats!.completedLoans),
                            icon: Icons.check_circle,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Financial stats
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.5,
                        children: [
                          StatCard(
                            title: 'Tổng giá trị cho vay',
                            value: formatCurrency(_stats!.totalLoanAmount),
                            icon: Icons.account_balance_wallet,
                            color: Colors.orange,
                          ),
                          StatCard(
                            title: 'Doanh thu',
                            value: formatCurrency(_stats!.totalRevenue),
                            icon: Icons.monetization_on,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    
                    // Recent loans
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Khoản vay gần đây',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Xem tất cả khoản vay')),
                            );
                          },
                          child: const Text('Xem tất cả'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    if (_recentLoans.isEmpty)
                      const Center(
                        child: Text(
                          'Không có khoản vay nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recentLoans.length,
                        itemBuilder: (context, index) {
                          return LoanListItem(
                            loan: _recentLoans[index],
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Chi tiết khoản vay ${_recentLoans[index].id}'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.blue),
                    title: const Text('Tạo khoản vay mới'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tạo khoản vay mới')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.psychology, color: Colors.purple),
                    title: const Text('Dự đoán rủi ro AI'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RiskPredictionPage()),
                      );
                    },
                  ),
                  SizedBox(height: 35,)
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm mới'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
