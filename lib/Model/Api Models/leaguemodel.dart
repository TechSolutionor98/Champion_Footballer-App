

class League {
  final String id;
  final String name;
  final String inviteCode;
  final DateTime createdAt;
  final List matches;
  final List users;

  League({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.createdAt,
    required this.matches,
    required this.users,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      inviteCode: json['inviteCode'],
      createdAt: DateTime.parse(json['createdAt']),
      matches: json['matches'] ?? [],
      users: json['users'] ?? [],
    );
  }
}
