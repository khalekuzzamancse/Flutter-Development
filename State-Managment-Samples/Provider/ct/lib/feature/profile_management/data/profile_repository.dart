import 'dart:convert';

import 'package:snowchat_ios/core/custom_exception/custom_exception.dart';
import 'package:snowchat_ios/core/data/server_response.dart';
import 'package:snowchat_ios/feature/auth/data/entity/entity_mapper.dart';

import '../../../core/misc/logger.dart';
import '../../../core/network/src/network_factory.dart';
import '../../../core/network/src/to_custom_exception.dart';
import '../../auth/domain/model/user_model.dart';
import '../../auth/data/entity/profile_update_entity.dart';
import '../../auth/data/entity/user_entity.dart';


class ProfileRepository {
  final _client = NetworkFactory.createApiClient();
  final className = 'ProfileRepository';

  ///Success message on success
  Future<String> deleteAccount(int userId,String token)async{
    //
    final tag='$className::deleteAccount()';
    final url='https://backend.snowtex.org/api/v1/auth/user/$userId/';

    try {
      Logger.debug(tag, 'request={userId:$userId, token:$token');

      final response = await _client.deleteWithTokenOrThrow(url,'Token $token');
      Logger.debug(tag, 'Response=$response');
      final responseEntity=ServerResponse.fromJsonOrThrow(jsonDecode(response));
      if(responseEntity.isSuccess){
        return ' successfully';
      }
      //If failure
      throw CustomException(message: responseEntity.errorMessage??'Something is went wrong', debugMessage: tag);
    } catch (e,trace) {
      Logger.errorWithTrace(tag, trace);
      throw toCustomException(exception: e,fallBackDebugMsg: 'source=$tag');
    }
  }

  //@formatter:off
  ///Return success message or throw custom custom Exception
  Future<String> editProfile(EditProfileEntity profile,String token)async {
    final tag='$className::editProfile()';
    const url='https://backend.snowtex.org/api/v1/auth/profile/';

    try {
      Logger.debug(tag, 'requestToken=$token');
      final requestData=profile.toJson();
      Logger.debug(tag, 'requestData=$requestData');
     final response = await _client.postWithTokenOrThrow(url,'Token $token',requestData);

      Logger.debug(tag, 'Response=$response');
      final responseEntity=ServerResponse.fromJsonOrThrow(jsonDecode(response));
      if(responseEntity.isSuccess){
        return 'Update successfully';
      }
      //If failure
      throw CustomException(message: responseEntity.errorMessage??'Something is went wrong', debugMessage: tag);
    } catch (e) {
      Logger.debug(tag, "ExceptionOccurs:${e.toString()}");
      throw toCustomException(exception: e,fallBackDebugMsg: 'source=$tag');

    }
  }

  //@formatter:off
  Future<UserProfileModel> readProfile(String token)async {
    final tag='$className::readProfile()';
    const url='https://backend.snowtex.org/api/v1/auth/profile/';

    String response = '';
    try {
      Logger.debug(tag, 'requestToken=$token');
      response = await _client.readWithTokenOrThrow(url,'Token $token');

      Logger.debug(tag, 'Response=$response');
      final responseEntity=ServerResponse.fromJsonOrThrow(jsonDecode(response));

      if(responseEntity.isSuccess){
        final data=responseEntity.data;
       final entity= UserEntity.fromJsonOrThrow(data);
       Logger.debug(tag, 'userEntity=$entity');
       return AuthEntityMapper.toUserModel2(entity);
      }

      throw CustomException(message: responseEntity.errorMessage ?? 'Something went wrong', debugMessage: 'source:$tag');
    } catch (e) {
      // String failureMessage = LoginErrorResponseParser.extractFailureMessage(response); //Itself can throw Exception
      //Propagate up to consumer/client such as controller
      throw toCustomException(exception: e, fallBackDebugMsg: 'source:$tag,error=$e');

    }
  }

}
