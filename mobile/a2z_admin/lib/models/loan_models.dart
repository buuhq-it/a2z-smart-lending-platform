class CreateLoanRequest {
  final String requestId;
  final String traceId;
  final String requestTime;
  final LoanRequestBody body;

  CreateLoanRequest({
    required this.requestId,
    required this.traceId,
    required this.requestTime,
    required this.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'traceId': traceId,
      'requestTime': requestTime,
      'body': body.toJson(),
    };
  }
}

class LoanRequestBody {
  final String customerNationalId;
  final String customerFullName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final int loanAmount;
  final double loanRate;
  final int tenor;
  final int income;
  final int age;
  final int gender; // 0: Nam, 1: Nữ
  final int numberOfChildren;
  final bool hasOwnCar;
  final bool hasOwnRealty;

  LoanRequestBody({
    required this.customerNationalId,
    required this.customerFullName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.loanAmount,
    required this.loanRate,
    required this.tenor,
    required this.income,
    required this.age,
    required this.gender,
    required this.numberOfChildren,
    required this.hasOwnCar,
    required this.hasOwnRealty,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerNationalId': customerNationalId,
      'customerFullName': customerFullName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'loanAmount': loanAmount,
      'loanRate': loanRate,
      'tenor': tenor,
      'income': income,
      'age': age,
      'gender': gender,
      'numberOfChildren': numberOfChildren,
      'hasOwnCar': hasOwnCar,
      'hasOwnRealty': hasOwnRealty,
    };
  }
}

class CreateLoanResponse {
  final bool success;
  final String message;
  final String? loanId;

  CreateLoanResponse({
    required this.success,
    required this.message,
    this.loanId,
  });

  factory CreateLoanResponse.fromJson(Map<String, dynamic> json) {
    return CreateLoanResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Tạo khoản vay thành công',
      loanId: json['loanId'],
    );
  }
}
