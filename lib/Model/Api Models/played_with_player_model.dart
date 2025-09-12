import 'dart:convert';

class PlayedWithPlayer {
    final String id;
    final String name;
    final String? profilePicture;
    final int rating;
    final String? shirtNumber;

    PlayedWithPlayer({
        required this.id,
        required this.name,
        this.profilePicture,
        required this.rating,
        this.shirtNumber,
    });

    factory PlayedWithPlayer.fromMap(Map<String, dynamic> map) {
        return PlayedWithPlayer(
            id: map['id'] ?? '',
            name: map['name'] ?? 'Unknown Player',
            profilePicture: map['profilePicture'],
            rating: map['rating'] ?? 0,
            shirtNumber: map['shirtNumber'],
        );
    }

    factory PlayedWithPlayer.fromJson(String source) =>
        PlayedWithPlayer.fromMap(json.decode(source));
}
