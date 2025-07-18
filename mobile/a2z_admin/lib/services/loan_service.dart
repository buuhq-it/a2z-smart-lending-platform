import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/loan_models.dart';
import 'token_service.dart';

class LoanService {
  static const String baseUrl = 'https://smart-lending.technote.online/api';

  // Generate random IDs
  String _generateRequestId() {
    // final random = Random();
    return "112233445566";
  }

  String _generateTraceId() {
    // final random = Random();
    // return random.nextInt(99999999).toString().padLeft(8, '0');
    return "11223344";
  }

  Future<CreateLoanResponse> createLoan(LoanRequestBody loanBody) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final requestId = _generateRequestId();
      final traceId = _generateTraceId();
      final requestTime = DateTime.now().toUtc().toIso8601String();

      final request = CreateLoanRequest(
        requestId: requestId,
        traceId: traceId,
        requestTime: requestTime,
        body: loanBody,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/process/demo-onboarding/acquisition'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // API trả về 200 thành công
        return CreateLoanResponse(
          success: true,
          message: 'Tạo khoản vay thành công',
          loanId: response.body, // Sử dụng requestId làm loanId tạm thời
        );
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi tạo khoản vay: $e');
    }
  }

  Future<List<LoanApplication>> getAllLoanApplications() async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/process/demo-onboarding/getAllApps'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> body = data['body'] ?? [];
        return body.map((e) => LoanApplication.fromJson(e)).toList();
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy danh sách khoản vay: $e');
    }
  }

  Future<bool> approveLoanApplication(String processInstanceId) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }
      final requestId = _generateRequestId();
      final traceId = _generateTraceId();
      final requestTime = DateTime.now().toUtc().toIso8601String();
      final body = {
        'requestId': requestId,
        'traceId': traceId,
        'requestTime': requestTime,
        'body': {
          'processInstanceId': processInstanceId,
        },
        'metadata': {
          'additionalProp1': {},
          'additionalProp2': {},
          'additionalProp3': {},
        },
      };
      final response = await http.post(
        Uri.parse('$baseUrl/process/demo-onboarding/esign'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
        return true;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi duyệt khoản vay: $e');
    }
  }

  Future<LoanApplication> getLoanDetail(int loanAppId) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }
      final requestId = _generateRequestId();
      final traceId = _generateTraceId();
      final requestTime = DateTime.now().toUtc().toIso8601String();
      final body = {
        'requestId': requestId,
        'traceId': traceId,
        'requestTime': requestTime,
        'body': {
          'loanAppId': loanAppId,
        },
        'metadata': {
          'additionalProp1': {},
          'additionalProp2': {},
          'additionalProp3': {},
        },
      };
      final response = await http.post(
        Uri.parse('$baseUrl/process/demo-onboarding/getApp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final detail = data['body'];
        return LoanApplication.fromJson(detail);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy chi tiết khoản vay: $e');
    }
  }
}
