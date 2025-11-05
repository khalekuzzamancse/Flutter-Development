import 'package:get/get.dart';
import 'package:snowchat_ios/feature/auth/data/entity/profile_update_entity.dart';
import 'package:snowchat_ios/feature/profile_management/data/profile_repository.dart';

import '../../../../core/data/media_repository.dart';
import '../../../../core/misc/logger.dart';
import '../../../di/global_controller.dart';
import '../../../auth/domain/model/user_model.dart';

class ProfileController extends GetxController {
  RxBool   isLoading = false.obs;
  Rx<UserProfileModel?> userModel = Rx<UserProfileModel?>(null);
  final className = 'ProfileController';

  ///Used for edit profile
  late EditProfileEntity _entity;

  ///Use for both first and last name changed
  void onNameChanged(String value) {
    //_entity may not  initialed yet
    try {
      List<String> parts = value.split(' ');
      String firstName = parts[0];
      //TODO:without last name backend will not accept so if last name empty just use placeholder, later fix it
      String lastName = parts.length > 1 ? parts[1] : '.';
      _entity = _entity.copyWith(firstName: firstName, lastName: lastName);
    } catch (e) {}
  }

  void onWedSiteChange(String value) {
    //_entity may not  initialed yet
    try {
      _entity = _entity.copyWith(website: value);
    } catch (e) {}
  }

  void onBioChange(String value) {
    //_entity may not  initialed yet
    try {
      _entity = _entity.copyWith(bio: value);
    } catch (e) {}
  }

  void onAddressChange(String value) {
    //_entity may not  initialed yet
    try {
      _entity = _entity.copyWith(address: value);
    } catch (e) {}
  }

//@formatter:off
  Future<void> deleteProfile() async {
    final tag = '$className::deleteProfile()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final response = await ProfileRepository().deleteAccount(authInfo.currentUserId, authInfo.token);
      Logger.debug(tag, 'response:$response');
      Get.find<GlobalController>().onLoginSessionExpire();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }
//@formatter:off
  Future<void> uploadProfileImage(String path) async {
    final tag = '$className::editProfile()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      //TODO:Fix it later, should not upload the image until confirm because user might re-choose a image
      ///In that case unnecessary the other image will be uploaded
      ///But the challenge is that how to show to preview in on UI of image without uploading it??
      final response = await MediaRepository().uploadImage(path, authInfo.token);
      Logger.debug(tag, 'response:$response');
      _entity = _entity.copyWith(imageId: response.id);
      Logger.debug(tag, 'updatedProfileEntity:$_entity');
      //update the UI
      userModel.value = userModel.value?.copyWith(imageUrl: response.url);
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  ///TODO: make sure _entity is initialized
  Future<void> updateProfile() async {
    final tag = '$className::editProfile()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final response =
          await ProfileRepository().editProfile(_entity, authInfo.token);
      Logger.debug(tag, 'response:$response');
      Get.find<GlobalController>().showSnackBar(
          response); //Updating success message as error to show snackBar
      //read the updated profile
      read();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProfile(EditProfileEntity entity) async {
    final tag = '$className::editProfile()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final response =
          await ProfileRepository().editProfile(entity, authInfo.token);
      Logger.debug(tag, 'response:$response');
      Get.find<GlobalController>().showSnackBar(
          response); //Updating success message as error to show snackBar
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> read() async {
    final tag = '$className::read()';
    try {
      isLoading.value = true;
      final authInfo = Get.find<GlobalController>().authInfo;
      final response = await ProfileRepository().readProfile(authInfo.token);
      userModel.value = response;
      _entity = EditProfileEntity(
          firstName: response.firstName, lastName: response.lastName);
      Logger.debug(tag, 'response:$response');
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
