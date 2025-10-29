import 'dart:convert';

import 'package:core/language/core_language.dart';


class RegisterResponseParser {
  static RegisterSuccessEntity parseResponse(String jsonResponse) {
    try {
     return RegisterSuccessEntity.fromJson(jsonDecode(jsonResponse));   ///Throw Custom exception if not a SuccessResponse
    } catch (e) {
  //    print("RegisterResponseParser:$e");
      String failureMessage = RegisterFailureEntity.extractAllErrorsAsString(jsonResponse);
      throw CustomException(message: failureMessage, debugMessage: e.toString());
    }
  }
}


/// Represents the result of a registration request.
///
/// This class is designed to only parse and store the minimal data necessary
/// to determine whether the registration was successful. This approach helps
/// reduce unnecessary parsing overhead, saving space and improving performance.
///
/// We only check the `code` field to determine success or failure. This reduces
/// the risk of bugs if the backend API structure changes in the future. By
/// coupling the logic with the data we need (just the `code`), we minimize the
/// impact of changes to the backend, preventing our code from breaking if the
/// API returns new or unnecessary fields.
class RegisterSuccessEntity {
  final bool isSuccess;

  RegisterSuccessEntity({
    required this.isSuccess,
  });

  ///Throw Custom exception if not a SuccessResponse
  factory RegisterSuccessEntity.fromJson(Map<String, dynamic> json) {
    final code = json['code'] as int?;

    if (code == null || code != 201) {
      // If the code is null or not 201, consider it a failure and throw an exception.
      throw CustomException(message: 'Something is went wrong', debugMessage: 'Registration failed with code: $code');
    }

    return RegisterSuccessEntity(isSuccess: true);  // If code is 201, it's successful.
  }

  @override
  String toString() {
    return 'RegisterSuccessEntity(isSuccess: $isSuccess)';
  }
}



class RegisterDataEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String image;
  final int gender;
  final bool isApproved;
  final bool isVerified;
  final bool isStaff;
  final bool isSuperuser;
  final String token;

  RegisterDataEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.image,
    required this.gender,
    required this.isApproved,
    required this.isVerified,
    required this.isStaff,
    required this.isSuperuser,
    required this.token,
  });

  // Factory constructor to create an instance from JSON
  factory RegisterDataEntity.fromJson(Map<String, dynamic> json) {
    return RegisterDataEntity(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      image: json['image'] as String,
      gender: json['gender'] as int,
      isApproved: json['is_approved'] as bool,
      isVerified: json['is_verified'] as bool,
      isStaff: json['is_staff'] as bool,
      isSuperuser: json['is_superuser'] as bool,
      token: json['token'] as String,
    );
  }

  @override
  String toString() {
    return 'RegisterDataEntity(id: $id, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, image: $image, gender: $gender, isApproved: $isApproved, isVerified: $isVerified, isStaff: $isStaff, isSuperuser: $isSuperuser, token: $token)';
  }
}

class RegisterFailureEntity {
  static String extractAllErrorsAsString(String jsonResponse) {
    try {
      final json = jsonDecode(jsonResponse) as Map<String, dynamic>;

      if (json.containsKey('errors') && json['errors'] is Map<String, dynamic>) {
        final errors = json['errors'] as Map<String, dynamic>;
        List<String> errorMessages = [];

        for (var key in errors.keys) {
          if (errors[key] is List && errors[key].isNotEmpty) {
            errorMessages.addAll(List<String>.from(errors[key]));
          }
        }

        return errorMessages.join(', ');
      }

      return 'No errors found';
    } catch (e) {
      return 'Invalid error response format';
    }
  }
}



