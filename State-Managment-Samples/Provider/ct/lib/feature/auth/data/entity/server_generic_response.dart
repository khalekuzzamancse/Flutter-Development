import 'dart:convert';

import 'package:snowchat_ios/feature/auth/data/entity/register_response_entities.dart';

import '../../../../core/custom_exception/src/custom_exception.dart';

class ServerGenericResponseParser {
  static ServerGenericResponse parseOrThrow(String jsonResponse) {
    try {
      final response= ServerGenericResponse.fromJson(jsonDecode(jsonResponse));   ///Throw Custom exception if not a SuccessResponse
      if(response.code!=200){
        String failureMessage = RegisterFailureEntity.extractAllErrorsAsString(jsonResponse);
        throw CustomException(message: failureMessage, debugMessage:'ServerGenericResponseParser::parseOrThrow::->$response');
      }
      return response;
    } catch (e) {
      //    print("RegisterResponseParser:$e");
      String failureMessage = RegisterFailureEntity.extractAllErrorsAsString(jsonResponse);
      throw CustomException(message: failureMessage, debugMessage: e.toString());
    }
  }
}

class ServerGenericResponse {
  final String? status;
  final int? code;
  final String? message;

  ServerGenericResponse({
    this.status,
    this.code,
    this.message,
  });

  bool get isSuccess {
    return  code == 200;
  }

  // Factory constructor to create an instance from JSON
  factory ServerGenericResponse.fromJson(Map<String, dynamic> json) {
    return ServerGenericResponse(
      status: json['status'] as String?,
      code: json['code'] as int?,
      message: json['message'] as String?,
    );
  }

  // Method to print the response
  @override
  String toString() {
    return 'ServerGenericResponse(status: $status, code: $code, message: $message)';
  }
}
