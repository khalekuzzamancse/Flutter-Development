import 'dart:convert';

import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/core/data/server_response.dart';
import 'package:snowchat_ios/core/data/document_entity.dart';
import 'package:snowchat_ios/core/domain/media_type.dart';
import 'package:snowchat_ios/core/network/network.dart';
import '../../../../core/misc/logger.dart';
import '../../../../core/network/src/network_factory.dart';

class MediaRepository {
  final _client = NetworkFactory.createApiClient();
  final className = 'MediaRepository';

//@formatter:off
  ///or throw custom custom Exception
  Future<DocumentEntity> uploadFileOrThrow({required String path,required String token,required MediaType type})async {
    final tag='$className::uploadImage()';
    const url='https://nowtex.org/api/v1/auth/documents/upload/';

    try {
      Logger.debug(tag, 'requestToken=$token');
      Logger.debug(tag, 'requestPath=$path');
      final response = await _client.postFileWithTokenOrThrow(url: url,token: 'Token $token',path: path,type: type);

      Logger.debug(tag, 'Response=$response');
      final responseEntity=ServerResponse.fromJsonOrThrow(jsonDecode(response));
      final data=responseEntity.data;
      Logger.debug(tag, 'data=$data');

      if(responseEntity.isSuccess){
        final entity=DocumentEntity.fromJsonOrThrow(data);
        Logger.debug(tag, 'entity=$entity');
        return entity;
      }
      //If failure
      throw CustomException(message: responseEntity.errorMessage??'Something is went wrong', debugMessage: tag);
    } catch (e) {
    throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');

    }
    }
  //@formatter:off
  ///or throw custom custom Exception
  @Deprecated('use uploadFileOrThrow')
  Future<DocumentEntity> uploadImage(String path,String token)async {
    final tag='$className::uploadImage()';
    const url='https://backend.snowtex.org/api/v1/auth/documents/upload/';

    try {
      Logger.debug(tag, 'requestToken=$token');
      Logger.debug(tag, 'requestPath=$path');
      final response = await _client.postImageWithTokenOrThrow(url,'Token $token',path);

      Logger.debug(tag, 'Response=$response');
      final responseEntity=ServerResponse.fromJsonOrThrow(jsonDecode(response));
      final data=responseEntity.data;
      Logger.debug(tag, 'data=$data');

      if(responseEntity.isSuccess){
        final entity=DocumentEntity.fromJsonOrThrow(data);
        Logger.debug(tag, 'entity=$entity');
        return entity;
      }
      //If failure
      throw CustomException(message: responseEntity.errorMessage??'Something is went wrong', debugMessage: tag);
    } catch (e) {
      throw  toCustomException(exception: e, fallBackDebugMsg: 'source:$tag');

    }
  }



}
