

import '../../data/repository/auth_repository_impl.dart';
import 'logic.dart';

class DiContainer{
  static LoginController createLoginController()=>
  LoginControllerImpl.create(_repository());
  static RegisterController createRegisterController()=>
      RegisterControllerImpl(_repository());
  static VerificationController createVerificationController()=>
      VerificationControllerImpl(_repository());

  static AuthRepositoryImpl  _repository(){
    return AuthRepositoryImpl();
  }
}