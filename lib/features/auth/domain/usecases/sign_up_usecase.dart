// sign_up_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:equatable/equatable.dart';

class SignUpUseCase {
  const SignUpUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, User>> call(SignUpParams params) async {
    return repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
      surname: params.surname,
      citizenId: params.citizenId,
      phone: params.phone,
      birthDate: params.birthDate,
      favoriteCuisine: params.favoriteCuisine,
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
    required this.citizenId,
    required this.phone,
    required this.birthDate,
    required this.favoriteCuisine,
  });

  final String email;
  final String password;
  final String name;
  final String surname;
  final String citizenId;
  final String phone;
  final DateTime birthDate;
  final CuisineType favoriteCuisine;


  @override
  List<Object?> get props => <Object?>[email, password, name, surname, citizenId, phone, birthDate];
}
