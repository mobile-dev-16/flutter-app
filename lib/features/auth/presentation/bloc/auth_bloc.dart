// auth_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_up_with_google_usecase.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with ResettableMixin<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignUpWithGoogleUseCase signUpWithGoogleUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signUpWithGoogleUseCase = signUpWithGoogleUseCase,
        _signOutUseCase = signOutUseCase,
        super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignUpWithGoogleRequested>(_onSignUpWithGoogleRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignUpWithGoogleUseCase _signUpWithGoogleUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final Either<Failure, User> result = await _signInUseCase(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    emit(
      result.fold(
        (Failure failure) => AuthError(failure.message),
        (User user) => AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final Either<Failure, User> result = await _signUpUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
        surname: event.surname,
        citizenId: event.citizenId,
        phone: event.phone,
        birthDate: event.birthDate,
        favoriteCuisine: event.favoriteCuisine,
      ),
    );

    emit(
      result.fold(
        (Failure failure) => AuthError(failure.message),
        (User user) => AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onSignUpWithGoogleRequested(
    SignUpWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final Either<Failure, User> result = await _signUpWithGoogleUseCase();

    emit(
      result.fold(
        (Failure failure) => AuthError(failure.message),
        (User user) => AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final Either<Failure, User> result = await _signInWithGoogleUseCase();

    emit(
      result.fold(
        (Failure failure) => AuthError(failure.message),
        (User user) => AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final Either<Failure, void> result = await _signOutUseCase();

    emit(
      result.fold(
        (Failure failure) => AuthError(failure.message),
        (_) => AuthUnauthenticated(),
      ),
    );
  }

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(AuthInitial());
  }
}
