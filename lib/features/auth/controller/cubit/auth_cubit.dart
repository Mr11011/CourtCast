import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../states/auth_states.dart';

class authCubit extends Cubit<authStates> {
  authCubit() : super(authStatesInit());

  static authCubit get(context) => BlocProvider.of(context);
  final _firebaseAuth = FirebaseAuth.instance;

// save user token
  Future<void> saveUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Get the Firebase ID Token
      String? token = await user.getIdToken();
      debugPrint("User Token: " + token.toString());
      await sharedPreferences.setString('authToken', token!);
      await sharedPreferences.setBool('isLoggedIn', true);
    }
  }

//   signUp Method
  void signUpWithFirebase(String email, String password) async {
    emit(signUpStatesLoading());
    try {
      UserCredential? userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await saveUserToken();
      emit(signUpStatesSuccess(userCredential.user!));

      // });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(signUpStatesError("Weak Password"));

        debugPrint('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        emit(signUpStatesError("Email already in use"));

        debugPrint('An account already exists with that email.');
      } else {
        emit(signUpStatesError(e.code.toString()));
      }
    }
  }

//   SignIn Method
  void signInWithFirebase(String email, String password) async {
    String message = '';
    emit(authStatesLoading());
    try {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserToken();
      emit(authStatesSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = 'Invalid login credentials.';
        emit(authStatesError(message));
      } else {
        message = e.code;
        emit(authStatesError(message));
      }
    }
  }

  // Logout Method
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('isLoggedIn');

    await _firebaseAuth.signOut();
    emit(authStatesInit());
  }

}