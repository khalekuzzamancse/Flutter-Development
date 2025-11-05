part of api_client;

class _HttpClient implements NetworkClient {
  final _class = '_HttpClient';

  @override
  //@formatter:off
  Future<Json> getOrThrow({required String url, Headers? headers}) async {
    final tag = '$_class::get';
    Logger.off(tag, 'url:$url, header:$headers');
    final response = await http.get(Uri.parse(url), headers: headers?.toMap());
    Logger.off(tag, 'response:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return _parseJson(response.body);
  }

  @override
  //@formatter:off
  Future<Json> postOrThrow({required String url, required dynamic payload,  Headers? headers}) async {
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
    return _parseJson(response.body);
  }

  @override
  //@formatter:off
  Future<Json> putOrThrow({required String url, dynamic payload,  Headers? headers}) async {
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
    return _parseJson(response.body);
  }

  @override
  //@formatter:off
  Future<Json> patchOrThrow({required String url, required dynamic payload, Headers? headers}) async {
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
    return _parseJson(response.body);
  }

  @override
  //@formatter:off
  Future<Json> deleteOrThrow({required String url,  Headers? headers}) async {
    final tag = '$_class::delete';
    Logger.off(tag, 'url:$url');
    final response = await http.delete(Uri.parse(url), headers: headers?.toMap());
    Logger.off(tag, 'response:${response.body}');
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return _parseJson(response.body);
  }

  Json _parseJson(String data) {
    final tag = '$_class::_parseJson';
    try {
      return jsonDecode(data) as Json;
    } catch (e) {
      Logger.keyValueOn(tag, '_parseJson()','unable to parse json',null);
      Logger.errorCaught(tag, '_parseJson()','error:$e,response:$data',null);
      throw CustomException( message:'Unexpected response from server',debugMessage:'Expected a JSON object, but got: $e');
    }
  }
}