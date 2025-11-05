part of 'logic.dart';
abstract class VerificationController{
  void updateVerificationCodeId(String userId);
  Future<dynamic> sendVerificationCode();
  Future<dynamic> confirmVerification(String code);
}
final class VerificationControllerImpl implements VerificationController{
  final VerificationRepository repository;
  late final tag=runtimeType.toString();
  VerificationControllerImpl(this.repository);
  String? _userId;

  @override
  Future confirmVerification(String code) async{
    const method='confirmVerification';
    try{
      await repository.confirmVerification(userIdOrThrow(),code);
    }
    catch(e){
      Logger.errorCaught(tag,method , e, null);
    }
  }

  @override
  Future sendVerificationCode() async{
    const method='sendVerificationCode';
    try{
      await repository.sendVerification(userIdOrThrow());
    }
    catch(e){
      Logger.errorCaught(tag,method , e, null);
    }
  }


  @override
  void updateVerificationCodeId(String userId) {
    _userId=userId;
  }
  String userIdOrThrow(){
    final snapshot=_userId;
    if(snapshot==null){
      throw CustomException(message: 'User id does not exits', debugMessage: tag);
    }
    return snapshot;
  }

}