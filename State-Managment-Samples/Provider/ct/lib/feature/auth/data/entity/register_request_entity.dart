class RegisterRequestEntity {
  final String firstName;
  final String lastName;
  final String dob;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final int country;
  final int gender;

  RegisterRequestEntity({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
    required this.country,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'email': email,
      'mobile': mobile,
      'password': password,
      'confirm_password': confirmPassword,
      'country': country,
      'gender': gender,
    };
  }

  @override
  String toString() {
    return 'RegisterRequestEntity(first_name: $firstName, last_name: $lastName, dob: $dob, email: $email, mobile: $mobile, country: $country, gender: $gender)';
  }
}
