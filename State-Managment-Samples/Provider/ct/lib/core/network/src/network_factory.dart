import 'api_client.dart';
import 'json_parser.dart';

class NetworkFactory {
  //todo:User <T> with the return type other wise it may failed to propagate `T` as a result
  //client will get <dynamic> instead of <T>

  static ApiClient<T> createApiClient<T>() => ApiClient.create<T>();

  static JsonParser<T> createJsonParser<T>() => JsonParser.create<T>();
}
  //Note:Do not use single expression function, because 