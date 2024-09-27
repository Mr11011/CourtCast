// cubit/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:courtcast/Core/features/auth/domain/use_case/auth_use_case.dart';
import '../presentation/controller/auth_cubit/states/auth_states.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
  }) : super(AuthInitialState());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoadingState());

    try {
      final userCredential = await signInUseCase.execute(email, password);
      emit(AuthSuccessState(userCredential));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoadingState());

    try {
      final userCredential = await signUpUseCase.execute(email, password);
      emit(AuthSuccessState(userCredential));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
