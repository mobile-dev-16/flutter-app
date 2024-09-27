class User {

  User({
    required this.id,
    required this.username,
    required this.email,
  });
  final String id;
  final String username;
  final String email;

  List<Object?> get props => <Object?>[id, username, email];
}
