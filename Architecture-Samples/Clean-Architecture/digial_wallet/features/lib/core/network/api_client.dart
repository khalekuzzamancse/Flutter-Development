import 'package:http/http.dart' as http;

import 'json_parser.dart';

abstract class ApiClient<T> {
  /**
   * - `Return` the retrieved raw `json `or throws `Custom exception`
   *
   * More Info:
   * - Equivalent to `suspend fun readJsonOrThrow(...)` ,since it return `Future`
   */
  Future<String> readOrThrow(String url);

  /**
   * - `Reads and Parses` the `json` response into a model of type `T`
   * - Throws `Custom exception` if the process fails
   *
   * More Info:
   * - `T Function(Map<String, dynamic>) fromJson` is used to convert raw `json` into `T`
   */
  Future<T> readParseOrThrow<T>(
      String url, T Function(Map<String, dynamic>) fromJson);

  /**
   * Return the list of T from the given Json, if parse failed throws `CustomException`
   */
  Future<List<T>> readParseListOrThrow<T>(
      String url, T Function(Map<String, dynamic>) fromJson);

  static ApiClient<T> create<T>() => ApiClientImpl<T>._internal();
}

class ApiClientImpl<T> implements ApiClient<T> {
  ApiClientImpl._internal();

  @override
  Future<String> readOrThrow(String url) async {
    final _url = Uri.parse(url);
    var response = await http.get(_url);
    return response.body; //Raw Json
  }

  @override
  Future<T> readParseOrThrow<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    final rawJson = await readOrThrow(url);
    final parser = JsonParser.create();
    return parser.parseOrThrow(rawJson, fromJson);
  }

  @override
  Future<List<T>> readParseListOrThrow<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    final rawJson =
        await readOrThrow(url); // Fetch raw JSON string from the URL
    final parser = JsonParser.create<T>(); // Create a JsonParser instance for T
    return parser.parseListOrThrow(
        rawJson, fromJson); // Parse the JSON as a list of T
  }
}
