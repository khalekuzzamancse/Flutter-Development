part of '../../core_network.dart';
class _HttpClient implements NetworkClient {
  final _class = '_HttpClient';

  @override
  //@formatter:off
  Future<String> getOrThrow({required String url, Headers? headers}) async {
    final tag = '$_class::get';
    Logger.on(tag, 'url:$url, header:$headers');
    final response = await http.get(Uri.parse(url), headers: headers?.toMap());
    Logger.on(tag, 'response:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return response.body;
  }

  @override
  //@formatter:off
  Future<String> postOrThrow({required String url, required dynamic payload,  Headers? headers}) async {
    final tag = '$_class::post';
    Logger.off(tag, 'url:$url');
    Logger.off(tag, 'request:${jsonEncode(payload)}');
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json; charset=UTF-8', if (headers != null) ...headers.toMap(),},
    );
    Logger.off(tag, 'response:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return response.body;
  }

  @override
  //@formatter:off
  Future<String> putOrThrow({required String url, dynamic payload,  Headers? headers}) async {
    final tag = '$_class::put';
    Logger.on(tag, 'url:$url');
    Logger.off(tag, 'header:$headers');
    Logger.off(tag, 'request:${jsonEncode(payload)}');
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json; charset=UTF-8', if (headers != null) ...headers.toMap()},
    );
    Logger.off(tag, 'response:$response');
    Logger.off(tag, 'responseBody:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return response.body;
  }

  @override
  //@formatter:off
  Future<String> patchOrThrow({required String url, required dynamic payload, Headers? headers}) async {
    final tag = '$_class::patch';
    Logger.off(tag, 'url:$url');
    Logger.off(tag, 'header:$headers');
    Logger.off(tag, 'request:${jsonEncode(payload)}');
    final response= await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8', if (headers != null) ...headers.toMap()},
        body: jsonEncode(payload));
    Logger.off(tag, 'response:$response');
    Logger.off(tag, 'responseBody:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return      response.body;
  }

  @override
  //@formatter:off
  Future<String> deleteOrThrow({required String url,  Headers? headers}) async {
    final tag = '$_class::delete';
    Logger.off(tag, 'url:$url');
    final response = await http.delete(Uri.parse(url), headers: headers?.toMap());
    Logger.off(tag, 'response:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return response.body;
  }


}