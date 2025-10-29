
import 'dart:convert';

import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/auth/data/entity/register_response_entities.dart';

import '../../../../core/custom_exception/src/custom_exception.dart';

class VerifyResponseParser {
  static VerificationSuccessEntity parseResponse(String jsonResponse) {
    try {
      return VerificationSuccessEntity.fromJson(jsonDecode(jsonResponse));   ///Throw Custom exception if not a SuccessResponse
    } catch (e) {
     // Logger.log('RegisterResponseParser', '$e');
      String failureMessage = RegisterFailureEntity.extractAllErrorsAsString(jsonResponse);
      throw CustomException(message: failureMessage, debugMessage: e.toString());
    }
  }
}



class VerificationSuccessEntity {
  final String status;
  final int code;
  final String message;

  VerificationSuccessEntity({
    required this.status,
    required this.code,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory VerificationSuccessEntity.fromJson(Map<String, dynamic> json) {
    return VerificationSuccessEntity(
      status: json['status'] as String,
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }

  @override
  String toString() {
    return 'VerificationSuccessEntity(status: $status, code: $code, message: $message)';
  }
}
