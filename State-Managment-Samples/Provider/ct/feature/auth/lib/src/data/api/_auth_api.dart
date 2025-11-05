part of 'api.dart';

// This template project, based on requirement may required to different feature or may remove some of them
//that is why using smaller unit of Apis as abstraction so that by combining them easily can break the
// complex feature with support different combination
// the repository will pick one or multiple apis based on the provided feature, such as if a app support with
// login can use the login api , but if support login+signup but not forget password and verify then login and register api only
// so basically ISP principal=pel so the client will not depends on thing that is not required
// right now the return type is dynamic based on client required create the entry and change the return type


abstract interface class LoginApi{
  Future<Pair<String,String>> loginOrThrow(String username, String password);
  Future<String> readTokenOrThrow(String refreshToken);
}


