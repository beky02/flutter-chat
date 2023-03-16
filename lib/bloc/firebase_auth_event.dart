

import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthEvent {}

class FirbasePhoneAuth extends FirebaseAuthEvent {
  final String phoneNumber;

  FirbasePhoneAuth(this.phoneNumber);
}

class FirbaseSmsCodeAuth extends FirebaseAuthEvent {
  final String verificationId;
  final String code;

  FirbaseSmsCodeAuth(this.verificationId, this.code);
}
class VerificationCodeSentEvent extends FirebaseAuthEvent {
  final String verificationId;
  VerificationCodeSentEvent(this.verificationId, );
}

class VerificationCompletedEvent extends FirebaseAuthEvent{
  final PhoneAuthCredential credential;

  VerificationCompletedEvent(this.credential);
}

class SignInEvent extends FirebaseAuthEvent{
  final String token;

  SignInEvent(this.token);
}

class LoginWithTokenEvent extends FirebaseAuthEvent{
  LoginWithTokenEvent();
}




