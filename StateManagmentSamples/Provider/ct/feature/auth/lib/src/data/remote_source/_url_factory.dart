part of 'remote_data_source.dart';

///The abstract factory
abstract class UrlFactory {
  String get login;
  String get register;
  String get verificationRequest;
  String get confirmVerification;
  String get isVerified;
  //using such as name so the client code become more readable such as
  // UrlFactory.urls.login
  static final UrlFactory urls =_ProductionUrlBuilder();

}

class _ProductionUrlBuilder implements UrlFactory {
  late final tag=runtimeType.toString();
  final String baseUrl = 'https://epos.sandbox.payinpos.com';
  @override
  String get login => '$baseUrl/api/v1/auth/merchant-stuff/login';
  @override
  String get register=>throw NotImplementedException(debugMessage: 'src:$tag');
  @override
  String get confirmVerification => throw NotImplementedException(debugMessage: 'src:$tag');
  @override
  String get isVerified => throw NotImplementedException(debugMessage: 'src:$tag');
  @override
  String get verificationRequest =>throw NotImplementedException(debugMessage: 'src:$tag');


}
