import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/login_models.dart';

class AuthService {
  static const String baseUrl = 'https://smart-lending.technote.online/api';
  
  // // Generate random IDs
  // String _generateRequestId() {
  //   final random = Random();
  //   return random.nextInt(999999999999).toString().padLeft(12, '0');
  // }
  
  // String _generateTraceId() {
  //   final random = Random();
  //   return random.nextInt(99999999).toString().padLeft(8, '0');
  // }
  
  Future<LoginResponse> login(String username, String password) async {
    try {
      const requestId = "112233445566";
      const traceId = "11223344";
      final requestTime = DateTime.now().toUtc().toIso8601String();
      
      final loginRequest = LoginRequest(
        requestId: requestId,
        traceId: traceId,
        requestTime: requestTime,
        body: LoginBody(
          username: username,
          password: password,
        ),
        metadata: {
          "additionalProp1": {},
          "additionalProp2": {},
          "additionalProp3": {}
        },
      );

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
