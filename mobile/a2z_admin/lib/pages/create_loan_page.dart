import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan_models.dart';
import '../services/loan_service.dart';
import '../widgets/stat_card.dart';

class CreateLoanPage extends StatefulWidget {
  const CreateLoanPage({super.key});

  @override
  State<CreateLoanPage> createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final _loanService = LoanService();
  
  // Controllers for form fields
  final _nationalIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _loanRateController = TextEditingController();
  final _tenorController = TextEditingController();
  final _incomeController = TextEditingController();
  final _ageController = TextEditingController();
  final _childrenController = TextEditingController();
  
  int _selectedGender = 0; // 0: Nam, 1: Nữ
  bool _hasOwnCar = false;
  bool _hasOwnRealty = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _loanAmountController.dispose();
    _loanRateController.dispose();
    _tenorController.dispose();
    _incomeController.dispose();
    _ageController.dispose();
    _childrenController.dispose();
    super.dispose();
  }

  Future<void> _createLoan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final loanBody = LoanRequestBody(
        customerNationalId: _nationalIdController.text.trim(),
        customerFullName: _fullNameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        customerAddress: _addressController.text.trim(),
        loanAmount: int.parse(_loanAmountController.text),
        loanRate: double.parse(_loanRateController.text) / 100, // Convert % to decimal
        tenor: int.parse(_tenorController.text),
        income: int.parse(_incomeController.text),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        numberOfChildren: int.parse(_childrenController.text),
        hasOwnCar: _hasOwnCar,
        hasOwnRealty: _hasOwnRealty,
      );

      final response = await _loanService.createLoan(loanBody);
      
      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
          
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Thành công'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Khoản vay đã được tạo thành công!'),
                  if (response.loanId != null) ...[
                    const SizedBox(height: 8),
                    Text('Mã khoản vay: ${response.loanId}'),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Back to home
                  },
                  child: const Text('Đóng'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    _clearForm(); // Clear form for new loan
                  },
                  child: const Text('Tạo khoản vay khác'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tạo khoản vay: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nationalIdController.clear();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _loanAmountController.clear();
    _loanRateController.clear();
    _tenorController.clear();
    _incomeController.clear();
    _ageController.clear();
    _childrenController.clear();
    setState(() {
      _selectedGender = 0;
      _hasOwnCar = false;
      _hasOwnRealty = false;
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
    String? suffix,
    int? maxLines,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[600]!),
        ),
      ),
      validator: validator ?? (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isRequired = true,
    String? suffix,
    double? min,
    double? max,
    bool allowDecimal = false,
  }) {
    return _buildTextField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: TextInputType.number,
      isRequired: isRequired,
      suffix: suffix,
      inputFormatters: [
        if (allowDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Vui lòng nhập $label';
        }
        if (value != null && value.isNotEmpty) {
          final number = double.tryParse(value);
          if (number == null) {
            return 'Vui lòng nhập số hợp lệ';
          }
          if (min != null && number < min) {
            return 'Giá trị phải >= $min';
          }
          if (max != null && number > max) {
            return 'Giá trị phải <= $max';
          }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tạo khoản vay mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _clearForm,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Xóa form',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[600]!, Colors.green[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_business,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tạo khoản vay mới',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhập đầy đủ thông tin khách hàng và khoản vay',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information
                  const Text(
                    'Thông tin khách hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    label: 'CMND/CCCD',
                    controller: _nationalIdController,
                    hint: 'VD: 123456789012',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập CMND/CCCD';
                      }
                      if (value.length < 9 || value.length > 12) {
                        return 'CMND/CCCD phải có 9-12 số';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    label: 'Họ và tên',
                    controller: _fullNameController,
                    hint: 'VD: Nguyễn Văn An',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'VD: example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    label: 'Số điện thoại',
                    controller: _phoneController,
                    hint: 'VD: 0901234567',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    label: 'Địa chỉ',
                    controller: _addressController,
                    hint: 'VD: 123 Đường ABC, Quận XYZ, TP.HCM',
                    maxLines: 2,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Tuổi',
                    controller: _ageController,
                    hint: 'VD: 35',
                    suffix: 'tuổi',
                    min: 18,
                    max: 100,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Gender selection
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giới tính',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<int>(
                                title: const Text('Nam'),
                                value: 0,
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value ?? 0;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<int>(
                                title: const Text('Nữ'),
                                value: 1,
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value ?? 0;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Thu nhập hàng tháng',
                    controller: _incomeController,
                    hint: 'VD: 15000000',
                    suffix: 'VNĐ',
                    min: 0,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Số con',
                    controller: _childrenController,
                    hint: 'VD: 2',
                    min: 0,
                    max: 20,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Loan Information
                  const Text(
                    'Thông tin khoản vay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Số tiền vay',
                    controller: _loanAmountController,
                    hint: 'VD: 50000000',
                    suffix: 'VNĐ',
                    min: 1000000, // Tối thiểu 1 triệu
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Lãi suất',
                    controller: _loanRateController,
                    hint: 'VD: 12.5',
                    suffix: '%/năm',
                    min: 0.1,
                    max: 100,
                    allowDecimal: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Thời hạn vay',
                    controller: _tenorController,
                    hint: 'VD: 12',
                    suffix: 'tháng',
                    min: 1,
                    max: 360,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Assets
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tài sản sở hữu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          title: const Text('Sở hữu ô tô'),
                          value: _hasOwnCar,
                          onChanged: (value) {
                            setState(() {
                              _hasOwnCar = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Sở hữu bất động sản'),
                          value: _hasOwnRealty,
                          onChanged: (value) {
                            setState(() {
                              _hasOwnRealty = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Create button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createLoan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_business),
                                SizedBox(width: 8),
                                Text(
                                  'Tạo khoản vay',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
