import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUpUseCase {
  const SignUpUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, User>> call(SignUpParams params) async {
    return repository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
