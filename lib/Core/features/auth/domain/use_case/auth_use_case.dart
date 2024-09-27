import 'package:firebase_auth/firebase_auth.dart';
import '../repository/base_auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserCredential> execute(String email, String password) async {
    try {
      return await repository.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw Exception('Invalid credentials.');
      } else {
        throw Exception(e.message ?? 'An unknown error occurred.');
      }
    }
  }
}


class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserCredential> execute(String email, String password) async {
    try {
      return await repository.signUp(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already in use.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else {
        throw Exception(e.message ?? 'An unknown error occurred.');
      }
    }
  }
}

