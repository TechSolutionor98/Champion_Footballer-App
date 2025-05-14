class CreateLeagueRequest {
  final String name;

  CreateLeagueRequest({required this.name});

  Map<String, dynamic> toJson() => {
        'league': {'name': name},
      };
}
