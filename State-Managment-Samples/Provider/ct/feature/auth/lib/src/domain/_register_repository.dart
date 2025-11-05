part of 'domain.dart';
abstract interface class RegisterRepository{
  Future<dynamic> registerOrThrow(RegisterModel model);
}

class RegisterModel {
  final String firstName, lastName,confirmPassword,email,mobile,password;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.confirmPassword,
    required this.email,
    required this.mobile,
    required this.password,
  });

  @override
  String toString() {
    return 'RegisterModel(first_name: $firstName, last_name: $lastName, confirmPassword: $confirmPassword, email: $email, mobile: $mobile)';
  }
}
