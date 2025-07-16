class LoginRequest {
  final String requestId;
  final String traceId;
  final String requestTime;
  final LoginBody body;
  final Map<String, dynamic> metadata;

  LoginRequest({
    required this.requestId,
    required this.traceId,
    required this.requestTime,
    required this.body,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'traceId': traceId,
      'requestTime': requestTime,
      'body': body.toJson(),
      'metadata': metadata,
    };
  }
}

class LoginBody {
  final String username;
  final String password;

  LoginBody({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final String requestId;
  final String traceId;
  final LoginResponseBody? body;
  final String? errorCode;
  final String? errorDesc;
  final bool success;
  final int totalSize;
  final int pageSize;
  final int pageIndex;
  final String timestamp;
  final Map<String, dynamic> metadata;

  LoginResponse({
    required this.requestId,
    required this.traceId,
    this.body,
    this.errorCode,
    this.errorDesc,
    required this.success,
    required this.totalSize,
    required this.pageSize,
    required this.pageIndex,
    required this.timestamp,
    required this.metadata,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      requestId: json['requestId'] ?? '',
      traceId: json['traceId'] ?? '',
      body: json['body'] != null ? LoginResponseBody.fromJson(json['body']) : null,
      errorCode: json['errorCode'],
      errorDesc: json['errorDesc'],
      success: json['success'] ?? false,
      totalSize: json['totalSize'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      pageIndex: json['pageIndex'] ?? 0,
      timestamp: json['timestamp'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }
}

class LoginResponseBody {
  final String token;

  LoginResponseBody({
    required this.token,
  });

  factory LoginResponseBody.fromJson(Map<String, dynamic> json) {
    return LoginResponseBody(
      token: json['token'] ?? '',
    );
  }
}
