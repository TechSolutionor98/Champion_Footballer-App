class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        "user": {
          "email": email,
          "password": password,
        }
      };
}
