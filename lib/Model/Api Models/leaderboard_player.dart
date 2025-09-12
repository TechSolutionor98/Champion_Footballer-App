class ApiLeaderboardPlayer {
  final String id;
  final String name;
  final String? positionType;
  final String? profilePicture; // This is a URL from your API response
  final String? shirtNumber;
  final String value; // Value from API is a String like "5"

  ApiLeaderboardPlayer({
    required this.id,
    required this.name,
    this.positionType,
    this.profilePicture,
    this.shirtNumber,
    required this.value,
  });

  factory ApiLeaderboardPlayer.fromJson(Map<String, dynamic> json) {
    return ApiLeaderboardPlayer(
      id: json['id'] as String? ?? DateTime.now().toIso8601String(), // Fallback ID
      name: json['name'] as String? ?? 'Unknown Player',
      positionType: json['positionType'] as String?,
      profilePicture: json['profilePicture'] as String?,
      shirtNumber: json['shirtNumber'] as String?,
      value: json['value'] as String? ?? '0',
    );
  }

  int get valueAsInt {
    return int.tryParse(value) ?? 0;
  }
}