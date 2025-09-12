// class CreateLeagueRequest {
//   final String name;
//
//   CreateLeagueRequest({required this.name});
//
//   Map<String, dynamic> toJson() => {
//         'league': {'name': name},
//       };
// }

// class CreateLeagueRequest {
//   final String name;
//   final String? image; // optional, maybe a URL or base64
//
//   CreateLeagueRequest({
//     required this.name,
//     this.image,
//   });
//
//   Map<String, dynamic> toJson() {
//     final league = {'name': name};
//     if (image != null && image!.isNotEmpty) {
//       league['image'] = image!; // safe now
//     }
//     return {'league': league};
//   }
// }

class CreateLeagueRequest {
  final String name;
  final String? image;

  CreateLeagueRequest({
    required this.name,
    this.image,
  });
}
