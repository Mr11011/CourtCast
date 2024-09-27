// cubit/auth_states.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final UserCredential user;

  AuthSuccessState(this.user);
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}
