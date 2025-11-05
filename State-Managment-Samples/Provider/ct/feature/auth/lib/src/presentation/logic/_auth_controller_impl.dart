// import 'package:auth/auth_2/auth/data/repository/auth_repository.dart';
// import 'package:auth/auth_2/auth/domain/model/register_model.dart';
// import 'package:auth/domain/domain.dart' hide RegisterModel;
// import 'package:core/language/core_language.dart';
//
// import 'logic.dart';
//
// class AuthControllerImpl implements AuthController{
//   final AuthRepository repository;
//   late final tag=runtimeType.toString();
//   String? verificationCodeUserId;
//   AuthControllerImpl(this.repository);
//
//   @override
//   Future<dynamic> login(String userId, String password) async{
//     const method='login';
//     try{
//       await repository.loginOrThrow(userId, password);
//     }
//     catch(e){
//       Logger.errorCaught(tag,method , e, null);
//     }
//   }
//
//   @override
//   Future<dynamic> confirmVerification(String code) async{
//     const method='confirmVerification';
//     try{
//       await repository.confirmVerification(verificationCodeUserIdOrThrow(),code);
//     }
//     catch(e){
//       Logger.errorCaught(tag,method , e, null);
//     }
//   }
//
//
//   @override
//   Future resetPassword(String userId, String code, String password) async{
//     const method='resetPassword';
//     try{
//       await repository.resetPassword(userId, code,password);
//     }
//     catch(e){
//       Logger.errorCaught(tag,method , e, null);
//     }
//   }
//
//   @override
//   Future sendVerificationCode()async {
//     const method='sendVerificationCode';
//     try{
//       await repository.sendVerification(verificationCodeUserIdOrThrow());
//     }
//     catch(e){
//       Logger.errorCaught(tag,method , e, null);
//     }
//   }
//
//   @override
//   void updateVerificationCodeId(String userId) {
//     verificationCodeUserId=userId;
//   }
//   String verificationCodeUserIdOrThrow(){
//     final snapshot=verificationCodeUserId;
//     if(snapshot==null){
//       throw CustomException(message: 'verify able user id does not exits', debugMessage: tag);
//     }
//     return snapshot;
//   }
//
//   @override
//   Future register(RegisterModel model) {
//     // TODO: implement register
//
//     throw UnimplementedError();
//   }
//
// }