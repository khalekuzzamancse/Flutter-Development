import 'package:get/get.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/feature/auth/data/repository/auth_repository.dart';
import '../../../di/global_controller.dart';
import '../../domain/model/register_model.dart';

///TODO: Make the verification as separate controller
class RegisterController extends GetxController {
  final _class='RegisterController';
  // Instance of RegisterModel to hold form data
  final model = RegisterModel(
    firstName: '',
    lastName: '',
    //TODO: not designed to UI to take Date of birth
    email: '',
    mobile: '',
    password: '',
    confirmPassword: '',
  ).obs;
  bool? _checkedTermAndCondition;

  void onCheckChanged(bool? value) {
    _checkedTermAndCondition = value;
  }

  // Loading state
  RxBool isLoading = false.obs;
  String _mobileNumber = ''; //TODO: used for verification
  final _repository = AuthRepository();

  // Methods to handle form field changes and update registerModel
  void onFirstNameChanged(String value) {
    model.value = model.value.copyWith(firstName: value);
  }

  void onLastNameChanged(String value) {
    model.value = model.value.copyWith(lastName: value);
  }

  void onEmailChanged(String value) {
    model.value = model.value.copyWith(email: value);
  }

  void onPasswordChanged(String value) {
    model.value = model.value.copyWith(password: value);
  }

  void onConfirmPasswordChanged(String value) {
    model.value = model.value.copyWith(confirmPassword: value);
  }

  void onMobileChanged(String value) {
    var number = value;
    model.value = model.value.copyWith(mobile: number);
  }

  void onCountryChanged(String value) {}

  void onGenderChanged(int value) {}

  // Register method to handle the registration process
  Future<bool> register() async {
    final tag='$_class::register';
    final validationMsg = validateRegistration();
    if (validationMsg != null) {
      Get.find<GlobalController>().showSnackBar(validationMsg);
      return false;
    }
    try {
      isLoading.value = true;
      String mobileWithoutLeadingZero = model.value.mobile.startsWith('0')
          ? model.value.mobile.substring(1)
          : model.value.mobile;
      _mobileNumber = '+880$mobileWithoutLeadingZero'; //TODO: as per backend right now just deal with BD
      Logger.debug(tag, 'mobile:$_mobileNumber');
      final requestModel=model.value.copyWith(mobile: _mobileNumber);
      Logger.debug(tag, 'requestModel:$requestModel');
     final response = await _repository.register(requestModel);

      sendVerificationCode();
      return true;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendVerificationCode() async {
    try {
      isLoading.value = true;
      await _repository.sendVerification(_mobileNumber);
      // await _repository.sendVerification('+8801571378537');
      return true;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendVerificationWithMobileNo(String number) async {
    try {
      isLoading.value = true;
      _mobileNumber = number;
      await _repository.sendVerification(number);
      // await _repository.sendVerification('+8801571378537');
      return true;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> confirmVerification(String code) async {
    try {
      isLoading.value = true;
      final phoneNo = _mobileNumber;
      // final phoneNo ='+8801571378537';
      await _repository.confirmVerification(phoneNo, code);
      Get.find<GlobalController>().showSnackBar("Verified successfully");
      return true;
    } catch (e) {
      Get.find<GlobalController>().onError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String? validateRegistration() {
    final model = this.model.value;
    if (model.firstName.isEmpty) {
      return 'First name is required';
    }
    if (model.lastName.isEmpty) {
      return 'Last name is required';
    }
    // TODO: Add validation for Date of Birth if designed in the UI
    if (model.email.isEmpty) {
      return 'Email is required';
    }
    // if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    //     .hasMatch(model.email)) {
    //   return 'Please enter a valid email address';
    // }
    if (model.mobile.isEmpty) {
      return 'Mobile number is required';
    }

    if (model.password.isEmpty) {
      return 'Password is required';
    }
    if (model.password.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    if (model.confirmPassword.isEmpty) {
      return 'Confirm Password is required';
    }
    if (model.password != model.confirmPassword) {
      return 'Passwords do not match';
    }
    if (_checkedTermAndCondition == null || _checkedTermAndCondition == false) {
      return 'Should accept terms and condition';
    }

    return null;
  }
}
