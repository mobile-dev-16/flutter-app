import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, void>> call() async {
    return repository.signOut();
  }
}
