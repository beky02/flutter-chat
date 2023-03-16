import 'package:chat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthState {}

class InitialFirebaseAuthState extends FirebaseAuthState {}

class CodeSentFirebaseAuthState extends FirebaseAuthState {
  final String verificationId;

  CodeSentFirebaseAuthState(this.verificationId);
}

class FailedFirebaseAuthState extends FirebaseAuthState {}

class SuccessfulFirebaseAuthState extends FirebaseAuthState {
  final UserCredential credential;

  SuccessfulFirebaseAuthState(this.credential);
}

class SuccessfulSignInState extends FirebaseAuthState {
  final UserModel userModel;

  SuccessfulSignInState(this.userModel);
}
