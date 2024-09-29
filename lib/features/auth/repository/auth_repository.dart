class AuthRepository {
  Future<bool> authenticate({required String username, required String password}) async {
    // Simulate an API call to authenticate the user, do not hardcode this in production
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == 'admin';
  }
}
