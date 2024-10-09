import 'package:firebase_auth/firebase_auth.dart';

abstract class authStates {}

class authStatesLoading extends authStates {}

class authStatesInit extends authStates {}

class authStatesSuccess extends authStates {
  final User user;

  authStatesSuccess(this.user);
}

class authStatesError extends authStates {
  final String error;

  authStatesError(this.error);
}

class signUpStatesLoading extends authStates {}

class signUpStatesInit extends authStates {}

class signUpStatesSuccess extends authStates {
  final User user;

  signUpStatesSuccess(this.user);
}

class signUpStatesError extends authStates {
  final String error;

  signUpStatesError(this.error);
}