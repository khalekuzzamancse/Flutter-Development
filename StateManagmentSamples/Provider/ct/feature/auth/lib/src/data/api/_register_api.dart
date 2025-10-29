
part of 'api.dart';
abstract interface class RegisterApi{
  Future<dynamic> registerOrThrow(RegisterEntity entity);

}

class RegisterEntity {
  final String firstName, lastName,email,mobile,password;

  RegisterEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.password,
  });

  @override
  String toString() {
    return 'RegisterWriteEntity(first_name: $firstName, last_name: $lastName, email: $email, mobile: $mobile)';
  }
}
