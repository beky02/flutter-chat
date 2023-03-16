import 'dart:convert';

import 'package:chat/bloc/firebase_auth_event.dart';
import 'package:chat/bloc/firebase_auth_state.dart';
import 'package:chat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  FirebaseAuthBloc() : super(InitialFirebaseAuthState());

  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences sp;

  @override
  Stream<FirebaseAuthState> mapEventToState(FirebaseAuthEvent event) async* {
    print(event);
    if (event is FirbasePhoneAuth) {
      auth.verifyPhoneNumber(
          phoneNumber: '+251' + event.phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) {
            print("check");
            // print(credential);
            // add(VerificationCompletedEvent(credential));
          },
          verificationFailed: (exception) {
            print(exception);
          },
          codeSent: (verificationId, forceResendingToken) {
            print(verificationId);
            add(VerificationCodeSentEvent(verificationId));
          },
          codeAutoRetrievalTimeout: (timeout) {});
    }

    if (event is FirbaseSmsCodeAuth) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.code);
      add(VerificationCompletedEvent(credential));
    }

    if (event is VerificationCodeSentEvent) {
      yield CodeSentFirebaseAuthState(event.verificationId);
    }
    if (event is VerificationCompletedEvent) {
      try {
        UserCredential userCredential =
            await auth.signInWithCredential(event.credential);
        yield SuccessfulFirebaseAuthState(userCredential);
      } catch (e) {}
    }

    if (event is SignInEvent) {
      Response res;
      print(event.token);
      try {
        res = await UserModel.signInWithFirebaseToken(event.token);
        print("here");
        print(res.statusCode);
        print(res.body);
        if (res.statusCode == 200) {
          UserModel um = UserModel.fromJson(jsonDecode(res.body));
          sp = await SharedPreferences.getInstance()
            ..setString('token', um.token);
          yield SuccessfulSignInState(um);
        }
      } catch (e) {
        print(e);
      }
    }

    if (event is LoginWithTokenEvent) {
      Response res;
      sp = await SharedPreferences.getInstance();
      String token = sp.getString('token');
      print(token);
      print("here");

      try {
        res = await UserModel.signInWithToken(token);
        print(res.statusCode);
        print(res.body);
        if (res.statusCode == 200) {
          UserModel um = UserModel.fromJson(jsonDecode(res.body)['user']);
          um.token = token;
          yield SuccessfulSignInState(um);
        }
      } catch (e) {
        print(e);
        yield InitialFirebaseAuthState();
      }
    }

     if (event is SignInEvent) {
      Response res;
      print(event.token);
      try {
        res = await UserModel.signInWithFirebaseToken(event.token);
        print("here");
        print(res.statusCode);
        print(res.body);
        if (res.statusCode == 200) {
          UserModel um = UserModel.fromJson(jsonDecode(res.body));
          sp = await SharedPreferences.getInstance()
            ..setString('token', um.token);
          yield SuccessfulSignInState(um);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
