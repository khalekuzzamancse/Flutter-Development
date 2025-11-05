part of 'logic.dart';
abstract interface class LoginController{
  //return success or not
  Future<bool> login(String userId,String password);
  Observable<LoginUiError> get errors;
}




final class LoginControllerImpl implements LoginController{
  final LoginRepository repository;
  late final tag=runtimeType.toString();
  static LoginController create(AuthRepository repository){
    return LoginControllerImpl(repository);
  }
  LoginControllerImpl(this.repository);
  late final _error=ObservableMutable<LoginUiError>(LoginUiError());

  @override
  late final Observable<LoginUiError>  errors =_error.asImmutable();

  @override
  Future<bool> login(String userId, String password) async{
    const method='login';
    //TODO: Should optimize, if error instance has same as previous avoid to update state
    final error=_updateError(userId, password);
    _error.updateWith(error);
    if(error.hasError()){
      return false;
    }
    try{
      await repository.loginOrThrow(userId, password);
      return true;
    }
    catch(e){
      Logger.errorCaught(tag,method , e, null);
      return false;
    }
  }

  LoginUiError _updateError(String userId, String password){
    var error=_error.value();
    return error
       .setUserIdError(userId.isEmptyOrBlank()?'Should not be empty':null)
       .setPasswordError(password.length<8?'Should consist at least 8 symbol':null);
  }

}

final class LoginUiError{
  final String? userIdError,passwordError;
  LoginUiError({ this.userIdError,this.passwordError});
  bool hasNoError(){
    return userIdError==null&&passwordError==null;
  }
  bool hasError()=>!hasNoError();

  LoginUiError setUserIdError(String? error){
    return LoginUiError(userIdError: error,passwordError:passwordError);
  }
  LoginUiError setPasswordError(String? error){
    return LoginUiError(userIdError: userIdError,passwordError:error);
  }
}