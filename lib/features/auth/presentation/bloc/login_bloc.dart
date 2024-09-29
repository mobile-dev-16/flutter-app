import 'package:eco_bites/features/auth/presentation/bloc/login_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/login_state.dart';
import 'package:eco_bites/features/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the authentication state and handles login-related events.
/// Uses [AuthRepository] to perform authentication operations.
class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthRepository authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final bool isSuccess = await authRepository.authenticate(
        username: event.username,
        password: event.password,
      );

      if (isSuccess) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Invalid credentials'));
      }
    } catch (e) {
      emit(LoginFailure('An error occurred: $e'));
    }
  }
}
