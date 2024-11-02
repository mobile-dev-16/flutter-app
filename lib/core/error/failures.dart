abstract class Failure {
  const Failure(this.message);
  final String message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    this.statusCode,
    this.errorType,
  });

  final int? statusCode;
  final String? errorType;
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(String? message)
      : super(message ?? 'Firebase error occurred');
}
