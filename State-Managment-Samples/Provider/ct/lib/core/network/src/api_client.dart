import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/di/global_controller.dart';

import '../../custom_exception/src/custom_exception.dart';
import '../../data/server_response.dart';
import '../../domain/media_type.dart';
import 'json_parser.dart';
//@formatter:off
abstract class ApiClient<T> {
  /// - `Return` the retrieved raw `json `or throws `Custom exception`
  ///
  /// More Info:
  /// - Equivalent to `suspend fun readJsonOrThrow(...)` ,since it return `Future`
  Future<String> readOrThrow(String url);
  Future<String> readWithTokenOrThrow(String url, String token);
  Future<String> deleteWithTokenOrThrow(String url, String token);
  /// - `Reads and Parses` the `json` response into a actions.dart of type `T`
  /// - Throws `Custom exception` if the process fails
  ///
  /// More Info:
  /// - `T Function(Map<String, dynamic>) fromJson` is used to convert raw `json` into `T`
  Future<T> readParseOrThrow<T>(String url, T Function(Map<String, dynamic>) fromJson);

  /// Return the list of T from the given Json, if parse failed throws `CustomException`
  Future<List<T>> readParseListOrThrow<T>(String url, T Function(Map<String, dynamic>) fromJson);
  /// Sends a POST request with the given body and returns the raw JSON response.
  /// Throws `CustomException` if the process fails.
  Future<String> postOrThrow(String url, Map<String, dynamic> body);
  Future<String> postWithTokenOrThrow(String url, String token, Map<String, dynamic> data);
  Future<String> postImageWithTokenOrThrow(String url, String token, String imagePath);

  Future<String> postFileWithTokenOrThrow({required String url, required String token, required String path, required MediaType type});

  static ApiClient<T> create<T>() => ApiClientImpl<T>._internal();
}
class LoggingClient extends http.BaseClient {
  final http.Client _client;
  final String tag = 'LoggingClient';

  LoggingClient(this._client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    print('[$tag] Request: ${request.method} ${request.url}');
    print('[$tag] Headers: ${request.headers}');
    if (request is http.Request) {
      print('[$tag] Body: ${request.body}');
    }

    final response = await _client.send(request);

    response.stream.transform(utf8.decoder).listen((data) {
      print('[$tag] Response: ${response.statusCode}');
      print('[$tag] Body: $data');
    });

    return response;
  }
}



class ApiClientImpl<T> implements ApiClient<T> {
  ApiClientImpl._internal();
  final className='ApiClientImpl';


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

  //@formatter:off
  @override
  Future<String> readWithTokenOrThrow(String url, String token) async {
    final http.Client client = LoggingClient(http.Client());

    //TODO: Need not to check the success code here because it may causes side effect
    final tag='$className::readWithTokenOrThrow';
    final uri = Uri.parse(url);
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json', // optional, depending on API requirements

    };
    Logger.debug(tag, 'request={url:$url,token:$token}');
    // var response = await client.get(uri, headers: headers);
    var response =  await http.get(uri, headers: headers);
    final jsonResponse=response.body;
    Logger.debug(tag, 'response:$jsonResponse');
   _throwTokenExpireExceptionOrDoNothing(jsonResponse,tag);
    return jsonResponse;
  }


//@formatter:off
  @override
  Future<String> postWithTokenOrThrow(String url, String token, Map<String, dynamic> data) async {
    final tag='$className::readWithTokenOrThrow';
    final uri = Uri.parse(url);
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    final body = json.encode(data);

    var response = await http.post(uri, headers: headers, body: body);
    _throwTokenExpireExceptionOrDoNothing(response.body,tag);
    return response.body;
  }
  @override
  Future<String> deleteWithTokenOrThrow(String url, String token) async {
    final tag = '$className::deleteWithTokenOrThrow';
    final uri = Uri.parse(url);
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    var response = await http.delete(uri, headers: headers);
    _throwTokenExpireExceptionOrDoNothing(response.body, tag);
    return response.body;
  }

  @override
  Future<List<T>> readParseListOrThrow<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    final rawJson = await readOrThrow(url); // Fetch raw JSON string from the URL
    final parser = JsonParser.create<T>(); // Create a JsonParser instance for T
    return parser.parseListOrThrow(
        rawJson, fromJson); // Parse the JSON as a list of T
  }

  //@formatter:off
  @override
  Future<String> postOrThrow(String url, Map<String, dynamic> body) async {
    final uri = Uri.parse(url);
    var response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body.isNotEmpty ? jsonEncode(body) : null);

    //Don't to check like this   if (response.statusCode == 200 || response.statusCode == 201) to avoid side effect
    //Because we have to propagate the message to user
      return response.body; // Raw JSON

  }
  //@formatter:off
  @override
  @Deprecated('use postFileWithTokenOrThrow')
  Future<String> postImageWithTokenOrThrow(String url, String token, String imagePath) async {
   return postFileWithTokenOrThrow(url: url,token: token,path: imagePath,type: MediaType.image);
  }
  //@formatter:off
  ///Type 0=image, 1=video, 2=file
  @override
  Future<String> postFileWithTokenOrThrow({required String url, required String token, required String path, required MediaType type}) async {
    final tag='$className::readWithTokenOrThrow';

    final uri = Uri.parse(url);
    final headers = {'Authorization': token};

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['doc_type'] =(type  == MediaType.image ? 0 : type == MediaType.video ? 1 : 2).toString() //2 is file(not image,not video)
      ..files.add(await http.MultipartFile.fromPath('document', path));

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    _throwTokenExpireExceptionOrDoNothing(responseBody,tag);
    return responseBody;
  }

  void _throwTokenExpireExceptionOrDoNothing(String responseJson,String tag){
    var isTokenExpire=false;
    try{//Catching the error related to parsing because this is extra parsing and it may be fail
      //so if fail consumer/client code will broken for no reason which is hard to debug


      //TODO:For this project doing this because sure about each response common structure
      //while pasting code to other project must remove this
      //This is doing for maintain the single source of truth for token expire exception
      final responseEntity = ServerResponse.fromJsonOrThrow(jsonDecode(responseJson));
      if(responseEntity.isTokenExpireError){
        isTokenExpire=true;
        //TODO:Fix it later accessing controller is violating the arch principle
       Get.find<GlobalController>().onError( AuthTokenExpireException(debugMessage:'source:$tag' ));
        throw AuthTokenExpireException(debugMessage:'source:$tag' ); //return it from the catch block
      }
    }
    catch(e){
      if(isTokenExpire){
        Logger.temp(tag, 'token expire');
        //TODO:Fix it later accessing controller is violating the arch principle
        Get.find<GlobalController>().onError( AuthTokenExpireException(debugMessage:'source:$tag' ));
        throw AuthTokenExpireException(debugMessage:'source:$tag' ); //return it from the catch block
      }
      //TODO:Need not do something
    }

  }


}
