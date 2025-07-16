import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/prediction_models.dart';
import '../services/prediction_service.dart';
import '../widgets/stat_card.dart';

class RiskPredictionPage extends StatefulWidget {
  const RiskPredictionPage({super.key});

  @override
  State<RiskPredictionPage> createState() => _RiskPredictionPageState();
}

class _RiskPredictionPageState extends State<RiskPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final _predictionService = PredictionService();
  
  // Controllers for form fields
  final _incomeController = TextEditingController();
  final _creditController = TextEditingController();
  final _annuityController = TextEditingController();
  final _goodsPriceController = TextEditingController();
  final _ageController = TextEditingController();
  final _employmentController = TextEditingController();
  final _childrenController = TextEditingController();
  final _extSourceController = TextEditingController();
  
  bool _ownCar = false;
  bool _ownRealty = false;
  bool _isLoading = false;
  PredictionResult? _predictionResult;

  @override
  void dispose() {
    _incomeController.dispose();
    _creditController.dispose();
    _annuityController.dispose();
    _goodsPriceController.dispose();
    _ageController.dispose();
    _employmentController.dispose();
    _childrenController.dispose();
    _extSourceController.dispose();
    super.dispose();
  }

  Future<void> _predictRisk() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    try {
      // Convert age to days (approximate)
      final age = int.parse(_ageController.text);
      final daysBirth = age * 365;
      
      // Convert employment years to days
      final employmentYears = double.parse(_employmentController.text);
      final daysEmployed = (employmentYears * 365).round();

      final request = PredictionRequest(
        amtIncomeTotal: double.parse(_incomeController.text),
        amtCredit: double.parse(_creditController.text),
        amtAnnuity: double.parse(_annuityController.text),
        amtGoodsPrice: double.parse(_goodsPriceController.text),
        daysBirth: daysBirth,
        daysEmployed: daysEmployed,
        cntChildren: int.parse(_childrenController.text),
        flagOwnCar: _ownCar ? 1 : 0,
        flagOwnRealty: _ownRealty ? 1 : 0,
        extSource2: double.parse(_extSourceController.text),
      );

      final response = await _predictionService.predictLoanRisk(request);
      
      if (response.status == 'success') {
        setState(() {
          _predictionResult = response.prediction;
        });
      } else {
        throw Exception('Prediction failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi dự đoán: $e'),
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
    _incomeController.clear();
    _creditController.clear();
    _annuityController.clear();
    _goodsPriceController.clear();
    _ageController.clear();
    _employmentController.clear();
    _childrenController.clear();
    _extSourceController.clear();
    setState(() {
      _ownCar = false;
      _ownRealty = false;
      _predictionResult = null;
    });
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isRequired = true,
    String? suffix,
    double? min,
    double? max,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
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
          'Dự đoán rủi ro AI',
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
                  colors: [Colors.purple[600]!, Colors.purple[400]!],
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
                        Icons.psychology,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AI Risk Assessment',
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
                    'Nhập thông tin khách hàng để đánh giá rủi ro tín dụng',
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
                  const Text(
                    'Thông tin tài chính',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Thu nhập tổng',
                    controller: _incomeController,
                    hint: 'VD: 10000000',
                    suffix: 'VNĐ',
                    min: 0,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Số tiền vay',
                    controller: _creditController,
                    hint: 'VD: 5000000',
                    suffix: 'VNĐ',
                    min: 0,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Số tiền trả hàng tháng',
                    controller: _annuityController,
                    hint: 'VD: 1000000',
                    suffix: 'VNĐ',
                    min: 0,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Giá trị tài sản',
                    controller: _goodsPriceController,
                    hint: 'VD: 2000000',
                    suffix: 'VNĐ',
                    min: 0,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Thông tin cá nhân',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  
                  _buildNumberField(
                    label: 'Số năm làm việc',
                    controller: _employmentController,
                    hint: 'VD: 5.5',
                    suffix: 'năm',
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
                  
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Điểm tín dụng ngoài',
                    controller: _extSourceController,
                    hint: 'VD: 0.5 (0-1)',
                    min: 0,
                    max: 1,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Checkboxes
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
                          value: _ownCar,
                          onChanged: (value) {
                            setState(() {
                              _ownCar = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Sở hữu bất động sản'),
                          value: _ownRealty,
                          onChanged: (value) {
                            setState(() {
                              _ownRealty = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Predict button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _predictRisk,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[600],
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
                                Icon(Icons.psychology),
                                SizedBox(width: 8),
                                Text(
                                  'Dự đoán rủi ro',
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
            
            // Results
            if (_predictionResult != null) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _predictionResult!.riskIcon,
                          color: _predictionResult!.riskColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Kết quả dự đoán',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Risk level
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _predictionResult!.riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Mức độ rủi ro: ${_predictionResult!.riskLevel}',
                        style: TextStyle(
                          color: _predictionResult!.riskColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Probabilities
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Xác suất trả nợ',
                            value: '${(_predictionResult!.probabilityRepaid * 100).toStringAsFixed(1)}%',
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatCard(
                            title: 'Xác suất vỡ nợ',
                            value: '${(_predictionResult!.probabilityDefault * 100).toStringAsFixed(1)}%',
                            icon: Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Recommendation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.blue[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Khuyến nghị',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getRecommendation(_predictionResult!.riskLevel),
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getRecommendation(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return 'Khách hàng có rủi ro thấp, có thể phê duyệt khoản vay với lãi suất ưu đãi.';
      case 'medium':
        return 'Khách hàng có rủi ro trung bình, cần xem xét thêm tài liệu và có thể yêu cầu tài sản đảm bảo.';
      case 'high':
        return 'Khách hàng có rủi ro cao, không nên phê duyệt hoặc cần tài sản đảm bảo có giá trị cao.';
      default:
        return 'Cần đánh giá thêm thông tin để đưa ra quyết định.';
    }
  }
}
