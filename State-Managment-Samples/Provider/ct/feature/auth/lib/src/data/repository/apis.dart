class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://backend.snowtex.org/api/v1/auth';

  // Endpoints
  static const String LOGIN = '$baseUrl/login/';
  static const String SIGN_UP = '$baseUrl/signup/';
  static const String resendVerification = '$baseUrl/verification/resend/';
  static const String confirmVerification = '$baseUrl/account/verify/';
  static const String resetPassword = '$baseUrl/forget/password/confirm/';
}
