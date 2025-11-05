import 'dart:convert';
import 'dart:math';

import 'package:snowchat_ios/core/network/network.dart';

import '../../../core/custom_exception/src/custom_exception.dart';
import '../../../core/data/server_response.dart';
import '../../../core/misc/logger.dart';
import '../../../core/network/src/network_factory.dart';
import 'misc_entity.dart';

class MiscInfoRepository {
  final _client = NetworkFactory.createApiClient();
  final className = 'MiscInfoRepository';

  Future<MiscInfoEntity> readPrivacyPolicy() {
    final tag = '$className::readPrivacyPolicy()';
    return _read(1, tag);
  }

  Future<MiscInfoEntity> readTerms() {
    final tag = '$className::readTerms()';
    return _read(2, tag);
  }

  Future<MiscInfoEntity> readAboutUs() {
    final tag = '$className::readAboutUs()';
    return _read(3, tag);
  }

  Future<MiscInfoEntity> readContactUs() {
    final tag = '$className::readContactUs()';
    return _read(4, tag);
  }

  Future<MiscInfoEntity> readHelpCenter() {
    final tag = '$className::readHelpCenter()';
    return _read(5, tag);
  }

  ///@formatter:off
  Future<MiscInfoEntity> _read(int type, String tag) async {
    final url = 'https://backend.snowtex.org/api/v1/utility/mobile/page/$type/';

    try {
      String response = await _client.readOrThrow(url);
      Logger.debug(tag, 'Response=$response');
      final responseEntity = ServerResponse.fromJsonOrThrow(jsonDecode(response));

      if (responseEntity.isSuccess) {
        final data = responseEntity.data;
        Logger.debug(tag, 'data=$data');
        final entity = MiscInfoEntity.fromJsonOrThrow(data);
        Logger.debug(tag, 'entities=$entity');
        return entity;
      }
      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: 'source:$tag');
    } catch (e) {
      //Propagate up to consumer/client such as controller
      throw toCustomException(exception: e, fallBackDebugMsg: 'source:$tag,error=$e');
    }
  }
}
