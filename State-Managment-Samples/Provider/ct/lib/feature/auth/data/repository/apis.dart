class ApiEndpoints {
  // Base URL
  static const String baseUrl = "";

  // Endpoints
  static const String LOGIN = '$baseUrl/login/';
  static const String SIGN_UP = '$baseUrl/signup/';
  static const String resendVerification = '$baseUrl/verification/resend/';
  static const String confirmVerification = '$baseUrl/account/verify/';
  static const String resetPassword = '$baseUrl/forget/password/confirm/';
}
