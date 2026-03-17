class LoginRequestDto {
  final String employeeCode;
  final String username;
  final String email;
  final String password;

  LoginRequestDto({
    required this.employeeCode,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'employee_code': employeeCode,
      'userName': username,
      'email': email,
      'password': password,
    };
  }
}
