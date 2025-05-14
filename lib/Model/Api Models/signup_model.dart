class SignupRequest {
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final String gender;
  final String password;

  SignupRequest({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.gender,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "user": {
          "firstName": firstName,
          "lastName": lastName,
          "age": age,
          "email": email,
          "gender": gender,
          "password": password,
        }
      };
}
