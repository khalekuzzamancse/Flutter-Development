import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/auth/domain/model/user_model.dart';

import '../../../di/global_controller.dart';
import '../../data/repository/auth_repository.dart';

class LoginController extends GetxController {
  String mobile = '';
  String password = '';
  RxBool isLoading = false.obs;

  final _repository = AuthRepository();

  void onPhoneNoChanged(String value) {
    mobile = value;
  }

  void onPasswordChanged(String value) {
    password = value;
  }

  ///If login not success return null otherwise pass the actions.dart to check user is verified or not
  Future<UserModel?> login() async {
    const tag = 'LoginController::login()';
    try {
      isLoading.value = true;
      String mobileWithoutLeadingZero = mobile.startsWith('0') ? mobile.substring(1) : mobile;
      Logger.debug(tag, "mobile->$mobileWithoutLeadingZero");
      final response = await _repository.login("+880$mobileWithoutLeadingZero", password);
      Logger.debug(tag, "response->$response");
      return response;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
