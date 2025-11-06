part of '../../core_network.dart';

abstract interface class  NetworkClient {
  Future<String> getOrThrow({required String url,  Headers? headers});
  Future<String> postOrThrow({required String url, required dynamic payload,  Headers? headers});
  Future<String> putOrThrow({required String url, dynamic payload,  Headers? headers});
  Future<String> patchOrThrow({required String url, required dynamic payload,  Headers? headers});
  Future<String> deleteOrThrow({required String url,  Headers? headers});

  /// The decorator use header implicitly, if required a custom header or null header then use the
  /// [createBaseClient]
  static NetworkClient createClientDecorator() {
   return NetworkClientDecorator.create( _HttpClient());
  }
  static NetworkClient createBaseClient() {
    return _HttpClient();
  }

}

class HttpHeader {
  final String key;
  final String value;

  const HttpHeader(this.key, this.value);
  @override
  String toString()=>'$key: $value';

}

class Headers {
  final List<HttpHeader> headers;

  Headers(this.headers);
  static createAuthHeader(String token)=>Headers([HttpHeader('Authorization', 'Bearer $token')]);
  Map<String, String> toMap() {
    final map = <String, String>{};
    for (var header in headers) {
      map[header.key] = header.value;
    }
    return map;
  }
  @override
  String toString()=>'$headers';
}

void _throwTokenExpireExceptionOrDoNothing(String responseJson,String tag) {
  var isTokenExpire = false;
  try { //Catching the error related to parsing because this is extra parsing and it may be fail
    //so if fail consumer/client code will broken for no reason which is hard to debug


    //TODO:For this project doing this because sure about each response common structure
    //while pasting code to other project must remove this
    //This is doing for maintain the single source of truth for token expire exception
    // final responseEntity = ServerResponse.fromJsonOrThrow(
    //     jsonDecode(responseJson));
    // if (responseEntity.isTokenExpireError) {
    //   isTokenExpire = true;
    //   throw UnauthorizedException(debugMessage: 'source:$tag'); //return it from the catch block
    // }
  }
  catch (e) {
    if (isTokenExpire) {
      throw UnauthorizedException(debugMessage: 'source:$tag');
    }
    //TODO:Need not do something
  }
}