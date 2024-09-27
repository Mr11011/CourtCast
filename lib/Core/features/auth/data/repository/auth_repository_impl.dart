// data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/base_auth_repository.dart';
import '../data_source/remote_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _firebaseAuthDataSource;

  AuthRepositoryImpl(this._firebaseAuthDataSource);

  @override
  Future<UserCredential> signUp(String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuthDataSource.signUp(email, password);
    await _saveUserToken(userCredential.user!);
    return userCredential;
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuthDataSource.signIn(email, password);
    await _saveUserToken(userCredential.user!);
    return userCredential;
  }

  @override
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('isLoggedIn');
    await _firebaseAuthDataSource.signOut();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await _firebaseAuthDataSource.isUserLoggedIn();
  }

  @override
  Future<String?> getCurrentUserToken() async {
    return await _firebaseAuthDataSource.getCurrentUserToken();
  }

  Future<void> _saveUserToken(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = await user.getIdToken();
    if (token != null) {
      await sharedPreferences.setString('authToken', token);
      await sharedPreferences.setBool('isLoggedIn', true);
    }
  }
}
