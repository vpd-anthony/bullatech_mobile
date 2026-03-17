class PasswordOnlyLoginRequestDto {
  final String password;

  PasswordOnlyLoginRequestDto({
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': password,
    };
  }
}
