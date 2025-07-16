import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_models.dart';
import 'token_service.dart';

class PredictionService {
  static const String baseUrl = 'https://smart-lending.technote.online';

  Future<PredictionResponse> predictLoanRisk(PredictionRequest request) async {
    try {
      final token = await TokenService.getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/ai/predict'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return PredictionResponse.fromJson(responseData);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối API: $e');
    }
  }
}
