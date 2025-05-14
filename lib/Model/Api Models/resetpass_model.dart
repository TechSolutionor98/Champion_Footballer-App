class ResetPasswordRequest {
  final String email;

  ResetPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {
        'user': {'email': email},
      };
}
