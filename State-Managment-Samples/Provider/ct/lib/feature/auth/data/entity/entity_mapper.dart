import 'package:snowchat_ios/feature/auth/data/entity/register_request_entity.dart';
import 'package:snowchat_ios/feature/auth/data/entity/user_entity.dart';
import 'package:snowchat_ios/feature/auth/domain/model/user_model.dart';

import '../../domain/model/register_model.dart';
import 'login_response_entity.dart';

class AuthEntityMapper {
  static RegisterRequestEntity toRegisterEntity(RegisterModel model) {
    return RegisterRequestEntity(
      firstName: model.firstName,
      lastName: model.lastName,
      dob:'1990-01-01', //TODO: as per back-end right now use default value
      email: model.email,
      mobile: model.mobile,
      password: model.password,
      confirmPassword: model.confirmPassword,
      country: 20,//TODO: as per back-end right now use default value
      gender: 1, //TODO: as per back-end right now use default value
    );
  }

  static UserModel toUserModel(LoginSuccessResponseEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      mobile: entity.mobile,
      image: entity.image,
      isVerified: entity.isVerified,
      token: entity.token,
    );
  }

  static UserProfileModel toUserModel2(UserEntity entity, {String? token, bool isVerified = false}) {
    return UserProfileModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      mobile: entity.mobile,
      imageUrl: entity.imageUrl,
      bio: entity.bio,
      website: entity.website,
      address: entity.address,
      isOnline: entity.isOnline,
      isVerified: isVerified, // This could be set to true based on your logic
      token: token, // Token is optional, hence passed as a parameter
    );
  }
}
