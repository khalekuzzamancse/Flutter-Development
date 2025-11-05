part of 'logic.dart';
abstract interface class RegisterController{
  //return success or not so  that can navigate such as send verification code
  Future<bool> register(RegisterModel model);
  Observable<RegisterUiError> get errors;
}


class RegisterControllerImpl implements RegisterController{
  final RegisterRepository repository;
  late final tag=runtimeType.toString();
  String? verificationCodeUserId;
  RegisterControllerImpl(this.repository);
  late final _error=ObservableMutable<RegisterUiError>(RegisterUiError());

  @override
  late final Observable<RegisterUiError>  errors =_error.asImmutable();
  @override
  Future<bool> register(RegisterModel model)async {
    const method='register';
    Logger.keyValueOff(tag, method, 'model', model);
    final error=_updateError(model);

    _error.updateWith(error);
    if(error.hasError()){
      return false;
    }
    try{
      await repository.registerOrThrow(model);
      return true;
    }
    catch(e){
      Logger.errorCaught(tag,method , e, null);
      return false;
    }
  }
  RegisterUiError _updateError(RegisterModel model){
    return RegisterUiError()
        .setFirstNameError(model.firstName.isEmptyOrBlank()?'Should not be empty':null)
        .setEmailError(model.email.isEmptyOrBlank()?'Should not be empty':null)
        .setPhoneError(phoneError(model.mobile))
        .setPasswordError(model.password.length<8?'Should consist at least 8 symbol':null)
        .setConfirmPasswordError(confirmPasswordError(model));
  }
  String? phoneError(String phone){
    if(phone.isEmptyOrBlank()){
      return 'Should not be empty';
    }
    if(phone.length!=11){
      return 'Should 11 Digit';
    }
    return null;
  }
  String? confirmPasswordError(RegisterModel model){
    if(model.confirmPassword.length<8){
      return 'Should consist at least 8 symbol';
    }
    if(model.confirmPassword!=model.password){
      return 'Does not match';
    }
    return null;
  }


}


final class RegisterUiError {
  final String? firstNameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  RegisterUiError({
    this.firstNameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
  });

  bool hasNoError() {
    return firstNameError == null &&
        emailError == null &&
        phoneError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  bool hasError() => !hasNoError();

  RegisterUiError copyWith({
    String? firstNameError,
    String? emailError,
    String? phoneError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return RegisterUiError(
      firstNameError: firstNameError ?? this.firstNameError,
      emailError: emailError ?? this.emailError,
      phoneError: phoneError ?? this.phoneError,
      passwordError: passwordError ?? this.passwordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
    );
  }

  RegisterUiError setFirstNameError(String? error) => copyWith(firstNameError: error);
  RegisterUiError setEmailError(String? error) => copyWith(emailError: error);
  RegisterUiError setPhoneError(String? error) => copyWith(phoneError: error);
  RegisterUiError setPasswordError(String? error) => copyWith(passwordError: error);
  RegisterUiError setConfirmPasswordError(String? error) => copyWith(confirmPasswordError: error);
}

