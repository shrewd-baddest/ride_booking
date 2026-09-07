class LoginResponse {
  final String message;
  final Map<String, dynamic>? data;
  final bool success;
  LoginResponse({required this.message, this.data, required this.success});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String,
      data: json['data'],
      success: json['success'] as bool,
    );
  }
}
