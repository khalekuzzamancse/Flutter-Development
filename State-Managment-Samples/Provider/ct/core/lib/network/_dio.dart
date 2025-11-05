part of api_client;
class _DioClient implements NetworkClient {
  final _class = '_DioClient';
  final Dio _dio;

  _DioClient() : _dio = Dio() {
    _dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
  }

  @override
  Future<Json> getOrThrow({required String url, Headers? headers}) async {
    final tag = '$_class::get';
    final response = await _dio.get(url, options: _mergeHeaders(headers));
    Logger.off(tag, 'response:$response');
    return _parseJson(response.data);
  }

  @override
  Future<Json> postOrThrow({required String url, dynamic payload, Headers? headers}) async {
    final tag = '$_class::post';
    Logger.on(tag, 'request:$payload');
    final response = await _dio.post(url, data: payload, options: _mergeHeaders(headers));
    Logger.on(tag, 'response:$response');
    return _parseJson(response.data);
  }

  @override
  Future<Json> putOrThrow({required String url, dynamic payload, Headers? headers}) async {
    final tag = '$_class::put';
    final response = await _dio.put(url, data: payload, options: _mergeHeaders(headers));
    Logger.on(tag, 'response:$response');
    return _parseJson(response.data);
  }
  @override
  Future<Json> patchOrThrow({required String url, dynamic payload, Headers? headers}) async {
    final tag = '$_class::patch';
    Logger.on(tag, 'url:$url');
    Logger.on(tag, 'request:$payload');
    final response = await _dio.patch(url, data: payload, options: _mergeHeaders(headers));
    Logger.on(tag, 'response:$response');
    return _parseJson(response.data);
  }


  @override
  Future<Json> deleteOrThrow({required String url, Headers? headers}) async {
    final tag = '$_class::delete';
    final response = await _dio.delete(url, options: _mergeHeaders(headers));
    Logger.on(tag, 'response:$response');
    return _parseJson(response.data);
  }

  Options _mergeHeaders(Headers? headers) {
    final options = Options();
    if (headers != null) {
      options.headers = headers.toMap();
    }
    return options;
  }

  Json _parseJson(dynamic data) {
    if (data is Json) {
      return data;
    } else {
      throw Exception('Expected a JSON object, but got: ${data.runtimeType}');
    }
  }


}