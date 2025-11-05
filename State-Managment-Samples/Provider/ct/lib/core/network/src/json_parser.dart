import 'dart:convert';

import 'package:snowchat_ios/core/network/src/server_feedback_entity.dart';
import 'package:snowchat_ios/core/network/src/to_custom_exception.dart';


/// It will cause the exception and convert to custom exception and throw if required
/// - It's okay to take the second parameter, pass just a function reference
/// recall the `KotlinXSerializer` also takes a second parameter called `serializer`
///
/// Usage Guide:
/// - Try to define the from json and toJson method manually instead of using the
/// third party library such that need `build-runner` because `build-runner` has overhead,such as
/// running the command, generating the source file again and again etc, since 99.99% cases the `entity`
/// are going to  need to `serialize` and `entity` are defined in the data layer so I believe there are few
/// entities of a project and more ever you need to write these method yourself the `GPT` can do this
///
///
/// - Once the `dart-macro` is stable you can use it to generate code without overhead then you can remove the
/// manually creation of methods
///
abstract class JsonParser<T> {
  /// - Pass the function reference as `fromJson`
  ///
  /// - More Info:
  ///
  /// A client might wonder why they need to use this function when they could simply pass the `fromJson` function reference
  /// and convert the JSON directly. While this is possible, the purpose of this method is to catch exceptions and convert
  /// them into meaningful custom exceptions, reducing boilerplate code
  ///
  /// If the client needs to parse `n` times, they would have to handle and convert exceptions `n` times. However, this method
  /// centralizes both the parsing and error conversion, maintaining a single source of truth for error handling
  ///
  /// Furthermore, once `dart macros` become stable, we aim to eliminate the need for manually passing the method references
  /// and writing `toJson`, `fromJson`, and `toString` methods

  T parseOrThrow(String json, T Function(Map<String, dynamic>) fromJson);

/// Parse as List<T> or throw `custom exception`
  List<T> parseListOrThrow(
      String json, T Function(Map<String, dynamic>) fromJson);



  /// - Pass the function reference as `toJson`
  String toJsonOrThrow(T value, Map<String, dynamic> Function(T) toJson);


  /// - Check if the Json is instance of T means if the Json is parsable to T or not
  /// - `return`  a `boolean`
  /// - Not throw any exception so it is safe
  ///
  bool isJsonOfType(String json, T Function(Map<String, dynamic>) fromJson);


  /// Parse the given json and return an instance of ServerFeedback.
  /// Throws custom exception if the parsing fails.
  /// To know the user case of it see the `ServerFeedback` docs
  ServerFeedback parseAsServerFeedbackOrThrow(String json);

  static JsonParser<T> create<T>()=> JsonParserImpl<T>._internal();

}

class JsonParserImpl<T> implements JsonParser<T> {
  JsonParserImpl._internal();

  @override
  T parseOrThrow(String json, T Function(Map<String, dynamic>) fromJson) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(json);
      return fromJson(jsonData);
    } catch (e) {
      rethrow;
      //throw toCustomException(e);
    }
  }


  @override
  String toJsonOrThrow(T value, Map<String, dynamic> Function(T) toJson) {
    try {
      final json = const JsonEncoder().convert(toJson(value));
      return json;
    } catch (e) {
      rethrow;
     // throw toCustomException(e);
    }
  }


  @override
  bool isJsonOfType(String json, T Function(Map<String, dynamic>) fromJson) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(json);
      fromJson(jsonData); // Try parsing the JSON
      return true; // If successful, it's of type T
    } catch (e) {
      return false; // If any error occurs, it's not of type T
    }
  }


  @override
  List<T> parseListOrThrow(
      String json, T Function(Map<String, dynamic>) fromJson) {
    try {
      final List<dynamic> jsonDataList = jsonDecode(json) as List<dynamic>;
      return jsonDataList
          .map((jsonItem) => fromJson(jsonItem as Map<String, dynamic>))
          .toList(); // Parse each item
    } catch (e) {
      rethrow;
    //  throw toCustomException(e);
    }
  }


  @override
  ServerFeedback parseAsServerFeedbackOrThrow(String json) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(json);
      return ServerFeedback.fromJson(jsonData);
    } catch (e) {
      rethrow;
      //throw toCustomException(e);
    }
  }
}
