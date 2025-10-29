import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../core/custom_exception/src/custom_exception.dart';
import '../../../../core/misc/logger.dart';
import '../../../di/global_controller.dart';
import '../../data/repository/auth_repository.dart';


class ForgetPasswordController extends GetxController {
  String otp = '';
  String phoneNumber = '';
  String newPassword = '';
  RxBool isLoading = false.obs;

  final _repository = AuthRepository();

  void onOtpChanged(String value) {
    otp = value;
  }

  void onPhoneNoChanged(String value) {
    phoneNumber = value;
  }

  void onNewPasswordChanged(String value) {
    newPassword = value;
  }
  Future<bool> sendVerificationCode() async {
    try {
      isLoading.value = true;
      isLoading.value = true;
      final response = await _repository.sendVerification(phoneNumber);
      Logger.debug("ForgetPasswordController::resetPassword()", "phone:$phoneNumber,otp:$otp,pass:$newPassword->");
      Logger.debug("ForgetPasswordController::verifyCodeAndChangePassword::response->", response);
      Get.find<GlobalController>().showSnackBar(response);
      // await _repository.sendVerification('+8801571378537');
      return true;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> resetPassword() async {
    const tag='ForgetPasswordController::resetPassword()';

    try {
      Logger.debug(tag, "phone:$phoneNumber,otp:$otp,pass:$newPassword");
      isLoading.value = true;
      final response= await _repository.resetPassword(phoneNumber, otp, newPassword);
      Logger.debug(tag, "response:$response");
      Get.find<GlobalController>().showSnackBar(response);
      return true;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
