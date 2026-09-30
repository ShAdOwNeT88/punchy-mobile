/// An authenticated user session. Plain Dart.
final class Session {
  const Session({
    required this.token,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  final String token;
  final String userId;
  final String email;
  final String firstName;
  final String lastName;

  factory Session.fromJson(Map<String, Object?> json) {
    final user = json['user'];
    final userMap = user is Map<String, Object?>
        ? user
        : const <String, Object?>{};
    final token = json['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Session payload without token');
    }
    return Session(
      token: token,
      userId: '${userMap['id'] ?? ''}',
      email: userMap['email'] as String? ?? '',
      firstName: userMap['firstName'] as String? ?? '',
      lastName: userMap['lastName'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() => {
    'token': token,
    'user': {
      'id': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    },
  };

  @override
  bool operator ==(Object other) =>
      other is Session &&
      other.token == token &&
      other.userId == userId &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName;

  @override
  int get hashCode => Object.hash(token, userId, email, firstName, lastName);
}
