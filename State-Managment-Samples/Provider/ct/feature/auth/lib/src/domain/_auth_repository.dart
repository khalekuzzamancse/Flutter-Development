part of 'domain.dart';

//Inherit as many as required as per the client requirement such as if only Login required just inherit the LoginRepository

abstract interface class AuthRepository
    implements
        LoginRepository,
        RegisterRepository,
        VerificationRepository,
        ResetPasswordRepository {}
