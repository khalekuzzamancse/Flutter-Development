class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;


  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
  });
// CopyWith method to create a new instance with updated fields
  RegisterModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? password,
    String? confirmPassword,
  }) {
    return RegisterModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
  @override
  String toString() {
    return 'RegisterModel(first_name: $firstName, last_name: $lastName, email: $email, mobile: $mobile)';
  }
}
