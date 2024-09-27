class AuthRepository {
  Future<bool> authenticate({required String username, required String password}) async {
    // API call to authenticate the user, do not hardcode this parameters
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == 'admin';
  }
}
