import 'dart:convert';

import 'package:core/language/core_language.dart';



//@formatter:off
class LoginResponseParser {
  static const _class='LoginResponseParser';
  ///Must pass the LoginResponseEntity format json (data filed response)
  static LoginSuccessResponseEntity parseOrThrow(String jsonResponse) {

    const tag='$_class::parseOrThrow';
    try {
      final responseJson = jsonDecode(jsonResponse);
      final data=responseJson['data'];
      return LoginSuccessResponseEntity.fromJson(data);
      ///Throw Custom exception if not a SuccessResponse
    } catch (e) {
      String failureMessage = LoginErrorResponseParser.extractFailureMessage(jsonResponse);
      throw CustomException(message: failureMessage, debugMessage: '$tag->${e.toString()}\n');
    }
  }
}

class LoginSuccessResponseEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String image;
  final bool isVerified;
  ///Token is null if the not verified yet
  final String? token;

  LoginSuccessResponseEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.image,
    required this.token,
    required this.isVerified,
  });

  // Factory constructor to create an instance from JSON

  factory LoginSuccessResponseEntity.fromJson(Map<String, dynamic> json){
    //TODO: do not do explicit type cast it can causes ERROR
    return LoginSuccessResponseEntity(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      mobile: json['mobile'],
      image: json['image'],
      token: json['token'],
      isVerified: json['is_verified']
    );
  }

  @override
  String toString() {
    return 'LoginSuccessResponseEntity(id: $id, firstName: $firstName, lastName: $lastName, email: $email, isVerified:$isVerified,mobile: $mobile, image: $image, token: $token)';
  }
}

/// A utility class to handle and extract error messages from inconsistent failure responses.
///
/// Backend APIs sometimes return error responses with inconsistent structures. For example:
///
/// **Failure Response 1:**
/// ```json
/// {
///   "status": "error",
///   "code": 400,
///   "data": null,
///   "message": "Invalid login credentials",
///   "errors": {}
/// }
/// ```
///
/// **Failure Response 2:**
/// ```json
/// {
///   "status": "error",
///   "code": 400,
///   "data": null,
///   "message": null,
///   "errors": {
///     "mobile": [
///       "User with mobile +8801571378538 does not exist"
///     ]
///   }
/// }
/// ```
///
/// In these cases, the error message can either be in the `message` field or nested
/// inside the `errors` map. Writing separate entities or handling each structure explicitly
/// becomes tedious and error-prone.
///
/// This class provides a static method, [extractFailureMessage], to dynamically parse
/// the failure response and extract the relevant error message, regardless of its structure.
///
/// **Advantages of This Approach:**
/// 1. **Dynamic Handling**: Extracts the failure message dynamically without requiring prior knowledge of the exact structure.
/// 2. **Centralized Logic**: Keeps the error-handling logic in one place for easier maintenance and updates.
/// 3. **Resilient to API Changes**: If the backend changes the error response slightly, the parsing logic can be updated in one place.
/// 4. **Ease for Developers**: Simplifies handling inconsistent structures, saving development time and reducing complexity.
class LoginErrorResponseParser {
  /// Extracts the error message from a given JSON response.
  ///
  /// - If the `message` field is present and non-null, it returns that as the error message.
  /// - If the `errors` field contains a map with error details, it returns the first error message.
  /// - If neither is available, it returns a default fallback message.
  ///
  /// **Parameters:**
  /// - `json`: The JSON response from the API, expected as a `Map<String, dynamic>`.
  ///
  /// **Returns:**
  /// - A `String` containing the extracted error message, or a default message if none is found.
  ///
  /// **Example Usage:**
  /// ```dart
  /// final response = {
  ///   "status": "error",
  ///   "code": 400,
  ///   "message": null,
  ///   "errors": {
  ///     "mobile": ["User with mobile +8801571378538 does not exist"]
  ///   }
  /// };
  ///
  /// final errorMessage = ErrorResponseParser.extractFailureMessage(response);
  /// print(errorMessage); // Output: User with mobile +8801571378538 does not exist
  /// ```
  static String extractFailureMessage(String jsonResponse) {
    try {
      final json = jsonDecode(jsonResponse) as Map<String, dynamic>;

      // Check if the `message` field exists and is not null
      if (json.containsKey('message') && json['message'] != null) {
        return json['message'] as String;
      }
      // Check if the `errors` field is a map and extract the first error message
      else if (json.containsKey('errors') &&
          json['errors'] is Map<String, dynamic>) {
        final errors = json['errors'] as Map<String, dynamic>;
        for (var key in errors.keys) {
          if (errors[key] is List && errors[key].isNotEmpty) {
            return errors[key][0] as String;
          }
        }
      }
      // Default fallback message if no specific error message is found
      return 'An unknown error occurred';
    } catch (e) {
      // Handle invalid JSON
      return 'Invalid error response format';
    }
  }
}
