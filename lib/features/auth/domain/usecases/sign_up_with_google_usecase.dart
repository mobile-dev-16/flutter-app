import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithGoogleUseCase {
  const SignUpWithGoogleUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, User>> call() async {
    return repository.signUpWithGoogle();
  }
}
