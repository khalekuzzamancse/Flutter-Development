import 'dart:convert';

import 'package:features/core/network/server_feedback_entity.dart';


import '../core_language.dart';


/**
 * It will cause the exception and convert to custom exception and throw if required
   * - It's okay to take the second parameter, pass just a function reference
   * recall the `KotlinXSerializer` also takes a second parameter called `serializer`
   * 
   * Usage Guide:
   * - Try to define the from json and toJson method manually instead of using the 
   * third party library such that need `build-runner` because `build-runner` has overhead,such as
   * running the command, generating the source file again and again etc, since 99.99% cases the `entity`
   * are going to  need to `serialize` and `entity` are defined in the source layer so I believe there are few
   * entities of a project and more ever you need to write these method yourself the `GPT` can do this
   * 
   * 
   * - Once the `dart-macro` is stable you can use it to generate code without overhead then you can remove the
   * manually creation of methods
   * 
 */
abstract class JsonParser<T> {
  /**
   * - Pass the function reference as `fromJson`
   * 
   * - More Info:
   * 
   * A client might wonder why they need to use this function when they could simply pass the `fromJson` function reference 
   * and convert the JSON directly. While this is possible, the purpose of this method is to catch exceptions and convert 
   * them into meaningful custom exceptions, reducing boilerplate code
   * 
   * If the client needs to parse `n` times, they would have to handle and convert exceptions `n` times. However, this method 
   * centralizes both the parsing and error conversion, maintaining a single source of truth for error handling
   * 
   * Furthermore, once `dart macros` become stable, we aim to eliminate the need for manually passing the method references 
   * and writing `toJson`, `fromJson`, and `toString` methods
   */

  T parseOrThrow(String json, T Function(Map<String, dynamic>) fromJson);

/**
 * Parse as List<T> or throw `custom exception`
 */
  List<T> parseListOrThrow(
      String json, T Function(Map<String, dynamic>) fromJson);



  /** - Pass the function reference as `toJson` */
  String toJsonOrThrow(T value, Map<String, dynamic> Function(T) toJson);


  /**
   * - Check if the Json is instance of T means if the Json is parsable to T or not
   * - `return`  a `boolean`
   * - Not throw any exception so it is safe
   * 
   */
  bool isJsonOfType(String json, T Function(Map<String, dynamic>) fromJson);
  bool isJsonListOf(String json, T Function(Map<String, dynamic>) fromJson);

  /**
 * Parse the given json and return an instance of ServerFeedback.
 * Throws custom exception if the parsing fails.
 * To know the user case of it see the `ServerFeedback` docs
 */
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
      throw toCustomException(e);
    }
  }


  @override
  String toJsonOrThrow(T value, Map<String, dynamic> Function(T) toJson) {
    try {
      final json = JsonEncoder().convert(toJson(value));
      return json;
    } catch (e) {
      throw toCustomException(e);
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
  bool isJsonListOf(String json, T Function(Map<String, dynamic>) fromJson) {
    try {
      final List<dynamic> jsonDataList = jsonDecode(json) as List<dynamic>;
      jsonDataList.forEach((jsonItem) => fromJson(jsonItem as Map<String, dynamic>)); // Attempt to parse each item
      return true; // If all items are parsed successfully, it's a list of T
    } catch (e) {
      return false; // If any error occurs, it's not a list of T
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
      throw toCustomException(e);
    }
  }


  /**
   * - Right now Using it with  Github data_source, the Github data_source send a feedback as:
   * ```dart
   * message": "API rate limit exceeded for 103.158.132.105. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)",
      "documentation_url": "https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting"
   * ```
   * This message is large enough showing it directly to end-user is not a good approach this why if the feedback is this message
   * then returning a short version of that.
   *
   * **Note**: Based on your project edit this source to align with your requirement
   */
  @override
  ServerFeedback parseAsServerFeedbackOrThrow(String json) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(json);
      final feedback=ServerFeedback.fromJson(jsonData);
      //This API is using for github issue tracker so
      if(feedback.message.contains("rate limit exceeded"))
      return ServerFeedback(message:"API rate limit exceeded, try again later");
      else return feedback;
    } catch (e) {
      throw toCustomException(e);
    }
  }
}
