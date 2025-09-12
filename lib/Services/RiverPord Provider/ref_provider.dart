
import 'dart:convert';
import 'dart:io';
import 'package:champion_footballer/Model/Api%20Models/login_model.dart';
import 'package:champion_footballer/Model/Api%20Models/played_with_player_model.dart';
import 'package:champion_footballer/Model/Api%20Models/signup_model.dart';
import 'package:champion_footballer/Services/Api/apiservices.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../Model/Api Models/contact_model.dart';
import '../../Model/Api Models/createleague_model.dart';
import '../../Model/Api Models/joinleagueinvite_model.dart';
import '../../Model/Api Models/leaderboard_player.dart';
import '../../Model/Api Models/resetpass_model.dart';
import '../../Model/Api Models/usermodel.dart';
import '../../Model/Api Models/dream_team_model.dart';
import '../../Model/Api Models/league_settings_model.dart';
import '../../Utils/packages.dart';
import 'package:mime/mime.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, LoginRequest>((ref, request) async {
  final service = ref.read(authServiceProvider);
  return service.login(request);
});

final signupProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, SignupRequest>((ref, request) async {
  final service = ref.read(authServiceProvider);
  return service.signup(request);
});

final authCheckProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  return token != null && token.isNotEmpty;
});

final userDataProvider = FutureProvider<WelcomeUser>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  print("[userDataProvider] Attempting to fetch /auth/data. Token: $token");

  if (token == null || token.isEmpty) {
    print("[userDataProvider] No token found, throwing Exception.");
    throw Exception('User not logged in or token is missing');
  }

  final response = await http.get(
    Uri.parse('https://api.techmanagement.tech/auth/data'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("[userDataProvider] Response status: ${response.statusCode}");

  if (response.statusCode == 200) {
    print("[userDataProvider] Successfully fetched user data.");
    final json = jsonDecode(response.body);
    return WelcomeUser.fromJson(json['user']);
  } else {
    print(
        "[userDataProvider] Error fetching user data. Status: ${response.statusCode}, Body: ${response.body}");
    throw Exception('Failed to load user data. Status: ${response.statusCode}');
  }
});

Future<void> uploadProfilePicture({
  required WidgetRef ref,
  required File profileImageFile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    print("[uploadProfilePicture] Auth token is missing.");
    throw Exception(
        'User not logged in or token is missing for picture upload');
  }

  final uri = Uri.parse('https://api.techmanagement.tech/profile/picture');
  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';

  final mimeTypeData =
      lookupMimeType(profileImageFile.path, headerBytes: [0xFF, 0xD8])
          ?.split('/');
  final mediaType = (mimeTypeData != null && mimeTypeData.length == 2)
      ? MediaType(mimeTypeData[0], mimeTypeData[1])
      : MediaType('application', 'octet-stream');

  request.files.add(
    await http.MultipartFile.fromPath(
      'profilePicture',
      profileImageFile.path,
      contentType: mediaType,
    ),
  );

  print("[uploadProfilePicture] Attempting to upload profile picture to $uri");

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print(
        "[uploadProfilePicture] Response: ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("[uploadProfilePicture] Profile picture uploaded successfully.");
      ref.invalidate(userDataProvider);
    } else {
      print(
          "[uploadProfilePicture] Failed to upload profile picture. Body: ${response.body}");
      throw Exception("Failed to upload profile picture: ${response.body}");
    }
  } catch (e) {
    print("[uploadProfilePicture] Error sending request: $e");
    throw Exception("Error uploading profile picture: $e");
  }
}

final playedWithPlayersProvider =
    FutureProvider<List<PlayedWithPlayer>>((ref) async {
  final service = ref.read(authServiceProvider);
  return service.getPlayedWithPlayers();
});

final playerSearchQueryProvider = StateProvider<String>((ref) => '');

final dreamTeamDataProvider =
    FutureProvider.family<DreamTeamResponse, String>((ref, leagueId) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getDreamTeam(leagueId);
});

final leagueSettingsProvider =
    FutureProvider.family<LeagueDetails?, String>((ref, leagueId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    print(
        "[leagueSettingsProvider] Auth token is missing for leagueId: $leagueId.");
    throw Exception('User not logged in or token is missing');
  }

  final response = await http.get(
    Uri.parse('https://api.techmanagement.tech/leagues/$leagueId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final leagueSettingsResponse =
        leagueSettingsResponseFromJson(response.body);
    if (leagueSettingsResponse.success == true &&
        leagueSettingsResponse.league != null) {
      return leagueSettingsResponse.league;
    } else {
      throw Exception(
          'Failed to process league settings: ${leagueSettingsResponse.success}');
    }
  } else {
    print(
        "[leagueSettingsProvider] Error fetching league settings for leagueId: $leagueId. Status: ${response.statusCode}, Body: ${response.body}");
    throw Exception(
        'Failed to load league settings. Status: ${response.statusCode}');
  }
});

Future<bool> joinLeague(String inviteCode, String token) async {
  try {
    final response = await http.post(
      Uri.parse('https://api.techmanagement.tech/leagues/join'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'inviteCode': inviteCode}),
    );
    print("Join league response: ${response.statusCode} - ${response.body}");
    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'Failed to join league';
      throw Exception(message);
    }
  } catch (e) {
    print("Error joining league: $e");
    throw Exception("Error joining league: $e");
  }
}

Future<void> updateProfile({
  required WidgetRef ref,
  String? firstName,
  String? lastName,
  String? email,
  String? ageString,
  String? gender,
  String? mainPosition,
  String? subPosition,
  String? style,
  String? preferredFoot,
  String? shirtNumberString,
  Map<String, int>? skills,
  String? password,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    print("[updateProfile] Auth token is missing.");
    throw Exception('User not logged in or token is missing');
  }

  final Map<String, dynamic> requestBody = {};

  if (firstName != null && firstName.isNotEmpty)
    requestBody['firstName'] = firstName;
  if (lastName != null && lastName.isNotEmpty)
    requestBody['lastName'] = lastName;
  if (email != null && email.isNotEmpty) requestBody['email'] = email;

  if (ageString != null && ageString.isNotEmpty) {
    final ageInt = int.tryParse(ageString);
    if (ageInt != null) {
      requestBody['age'] = ageInt;
    } else {
      print("[updateProfile] Invalid age format: $ageString");
    }
  }

  if (gender != null && gender.isNotEmpty) requestBody['gender'] = gender;
  if (mainPosition != null && mainPosition.isNotEmpty)
    requestBody['positionType'] = mainPosition;
  if (subPosition != null && subPosition.isNotEmpty)
    requestBody['position'] = subPosition;
  if (style != null && style.isNotEmpty) requestBody['style'] = style;
  if (preferredFoot != null && preferredFoot.isNotEmpty)
    requestBody['preferredFoot'] = preferredFoot;

  if (shirtNumberString != null && shirtNumberString.isNotEmpty) {
    final shirtInt = int.tryParse(shirtNumberString);
    if (shirtInt != null) {
      requestBody['shirtNumber'] = shirtInt;
    } else {
      print("[updateProfile] Invalid shirt number format: $shirtNumberString");
    }
  }

  if (skills != null && skills.isNotEmpty) requestBody['skills'] = skills;
  if (password != null && password.isNotEmpty)
    requestBody['password'] = password;

  print("[updateProfile] Request Body: ${jsonEncode(requestBody)}");

  final response = await http.patch(
    Uri.parse("https://api.techmanagement.tech/profile"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(requestBody),
  );

  print(
      "[updateProfile] PATCH response: ${response.statusCode}, ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("[updateProfile] Profile updated successfully.");
    ref.invalidate(userDataProvider);
  } else {
    print("[updateProfile] Failed to update profile. Body: ${response.body}");
    throw Exception("Failed to update profile: ${response.body}");
  }
}

final resetPasswordProvider =
    FutureProvider.family<void, ResetPasswordRequest>((ref, request) async {
  final response = await http.post(
    Uri.parse('https://api.techmanagement.tech/auth/reset-password'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(request.toJson()),
  );
  if (response.statusCode == 200) {
    return;
  } else {
    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Reset password failed');
  }
});
final matchDetailProvider =
    FutureProvider.family<List<PlayerStats>, String>((ref, matchId) async {
  final response = await http.get(
    Uri.parse("https://api.techmanagement.tech/matches/$matchId"),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final match = data['match'];
    final home = (match['homeTeamUsers'] as List? ?? [])
        .map((e) => PlayerStats.fromJson(e))
        .toList();
    final away = (match['awayTeamUsers'] as List? ?? [])
        .map((e) => PlayerStats.fromJson(e))
        .toList();
    return [...home, ...away];
  } else {
    throw Exception("Failed to load match details");
  }
});

final createLeagueProvider =
    FutureProvider.family<void, CreateLeagueRequest>((ref, request) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  final uri = Uri.parse('https://api.techmanagement.tech/leagues');
  final multipartRequest = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..fields['name'] = request.name;

  if (request.image != null && request.image!.isNotEmpty) {
    final file = File(request.image!);
    if (!file.existsSync() || file.lengthSync() == 0) {
      throw Exception('Image file invalid: ${request.image}');
    }
    final mimeType =
        lookupMimeType(request.image!) ?? 'application/octet-stream';
    final mimeParts = mimeType.split('/');
    multipartRequest.files.add(
      await http.MultipartFile.fromPath(
        'image',
        request.image!,
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ),
    );
  }
  print('Fields: ${multipartRequest.fields}');
  print(
      'Files: ${multipartRequest.files.map((f) => "${f.field}:${f.filename}")}');
  final streamedResponse = await multipartRequest.send();
  final response = await http.Response.fromStream(streamedResponse);
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Server error ${response.statusCode}: ${response.body}');
  }
});

final joinLeagueProvider = FutureProvider.family
    .autoDispose<bool, JoinLeagueRequest>((ref, request) async {
  final result = await joinLeague(request.inviteCode, request.token);
  ref.invalidate(userDataProvider);
  return result;
});

final selectedLeagueProvider = StateProvider<LeaguesJoined?>((ref) => null);
final selectedLeagueForDreamTeamProvider =
    StateProvider<LeaguesJoined?>((ref) => null);
final careerStatsSelectedLeagueProvider =
    StateProvider<LeaguesJoined?>((ref) => null);

final contactUsProvider =
    FutureProvider.family<bool, ContactRequest>((ref, request) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final response = await http.post(
    Uri.parse('https://api.techmanagement.tech/api/contact'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(request.toJson()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Failed to send message");
  }
});

final matchStatsProvider =
    FutureProvider.family<Match, String>((ref, matchId) async {
  final dio = Dio();
  final response = await dio.get(
    "https://api.techmanagement.tech/matches/$matchId",
    options: Options(headers: {
      "Authorization": "Bearer YOUR_TOKEN"
    }), // Ensure token is dynamic
  );
  if (response.statusCode == 200) {
    final data = response.data["match"];
    return Match.fromJson(data);
  } else {
    throw Exception("Failed to load match stats");
  }
});

Future<void> createMatch({
  required String leagueId,
  required DateTime date,
  required DateTime start,
  required DateTime end,
  required String location,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null || token.isEmpty) {
    throw Exception("No auth token found.");
  }
  final url =
      Uri.parse("https://api.techmanagement.tech/leagues/$leagueId/matches");
  final request = http.MultipartRequest("POST", url);
  request.headers.addAll({"Authorization": "Bearer $token"});
  request.fields['date'] = date.toUtc().toIso8601String();
  request.fields['start'] = start.toUtc().toIso8601String();
  request.fields['end'] = end.toUtc().toIso8601String();
  request.fields['location'] = location;
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);
  print("Create Match Response: ${response.statusCode} -> ${response.body}");
  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Match Created Successfully");
  } else {
    throw Exception("Failed to create match: ${response.body}");
  }
}

final matchRefreshProvider = StateProvider<int>((ref) => 0);
final selectedMatchProvider = StateProvider<Match?>((ref) => null);

Future<void> updateMatch({
  required String matchId,
  required String leagueId,
  required DateTime date,
  required DateTime start,
  required DateTime end,
  required String location,
  String? homeTeamName,
  String? awayTeamName,
  String? notes,
  String? homeTeamGoals,
  String? awayTeamGoals,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null || token.isEmpty) {
    throw Exception("No auth token found.");
  }
  final url = Uri.parse(
      "https://api.techmanagement.tech/leagues/$leagueId/matches/$matchId");
  final request = http.MultipartRequest("PATCH", url);
  request.headers
      .addAll({"Authorization": "Bearer $token", "Accept": "application/json"});
  request.fields['date'] = date.toUtc().toIso8601String();
  request.fields['start'] = start.toUtc().toIso8601String();
  request.fields['end'] = end.toUtc().toIso8601String();
  request.fields['location'] = location;
  if (homeTeamName != null && homeTeamName.trim().isNotEmpty)
    request.fields['homeTeamName'] = homeTeamName.trim();
  if (awayTeamName != null && awayTeamName.trim().isNotEmpty)
    request.fields['awayTeamName'] = awayTeamName.trim();
  if (notes != null && notes.trim().isNotEmpty)
    request.fields['notes'] = notes.trim();
  if (homeTeamGoals != null && homeTeamGoals.trim().isNotEmpty)
    request.fields['homeTeamGoals'] = homeTeamGoals.trim();
  if (awayTeamGoals != null && awayTeamGoals.trim().isNotEmpty)
    request.fields['awayTeamGoals'] = awayTeamGoals.trim();
  print(">>> PATCH $url");
  print(">>> Headers: ${request.headers}");
  print(">>> Fields:");
  request.fields.forEach((k, v) => print("   $k: '$v'"));
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);
  print("Update Match Response: ${response.statusCode} -> ${response.body}");
  if (response.statusCode >= 200 && response.statusCode < 300) {
    print("Match Updated Successfully");
  } else {
    throw Exception(
        "Failed to update match (${response.statusCode}): ${response.body}");
  }
}

Future<void> updateMatchGoals({
  required String matchId,
  required String homeGoals,
  required String awayGoals,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null || token.isEmpty) {
    throw Exception("No auth token found.");
  }
  final url =
      Uri.parse("https://api.techmanagement.tech/matches/$matchId/goals");
  final body = jsonEncode({"homeGoals": homeGoals, "awayGoals": awayGoals});
  try {
    final response = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
        body: body);
    print(">>> PATCH $url");
    print(">>> Headers: ${response.request?.headers}");
    print(">>> Body: $body");
    if (response.statusCode == 200) {
      print("Goals updated: ${response.body}");
    } else {
      print(
          "Failed to update goals: ${response.statusCode} -> ${response.body}");
    }
  } catch (e) {
    print("Error updating goals: $e");
  }
}

Future<Map<String, dynamic>> getMatchById(
    String matchId, String leagueId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null || token.isEmpty) {
    throw Exception("No auth token found.");
  }
  final url = Uri.parse(
      "https://api.techmanagement.tech/leagues/$leagueId/matches/$matchId");
  final response = await http.get(url, headers: {
    "Authorization": "Bearer $token",
    "Accept": "application/json"
  });
  print("GET $url");
  print("Response: ${response.statusCode} -> ${response.body}");
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception(
        "Failed to fetch match: ${response.statusCode} ${response.body}");
  }
}

Future<void> updateMatchNote({
  required String matchId,
  required String note,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null || token.isEmpty) {
    throw Exception("No auth token found.");
  }
  final url =
      Uri.parse("https://api.techmanagement.tech/matches/$matchId/note");
  final body = jsonEncode({"note": note});
  try {
    final response = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
        body: body);
    print(">>> PATCH $url");
    print(">>> Headers: ${response.request?.headers}");
    print(">>> Body: $body");
    if (response.statusCode == 200) {
      print("Note updated: ${response.body}");
    } else {
      print(
          "Failed to update note: ${response.statusCode} -> ${response.body}");
    }
  } catch (e) {
    print("Error updating note: $e");
  }
}

Future<void> updateLeagueSettings({
  required WidgetRef ref,
  required String leagueId,
  String? name,
  bool? active,
  int? maxGames,
  bool? showPoints,
  List<String>? administratorIds,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    print(
        "[updateLeagueSettings] Auth token is missing for leagueId: $leagueId.");
    throw Exception('User not logged in or token is missing');
  }

  final Map<String, dynamic> requestBody = {};

  if (name != null && name.isNotEmpty) requestBody['name'] = name;
  if (active != null) requestBody['active'] = active;
  if (maxGames != null) requestBody['maxGames'] = maxGames;
  if (showPoints != null) requestBody['showPoints'] = showPoints;

  // CORRECTED PART for "admins"
  if (administratorIds != null && administratorIds.isNotEmpty) {
    requestBody['admins'] =
        administratorIds; // Key is 'admins', value is List<String>
  }
  // END OF CORRECTED PART

  if (requestBody.isEmpty &&
      !(administratorIds != null && administratorIds.isNotEmpty)) {
    // Added check for administratorIds to ensure we don't return if only admins are being changed
    // If only admins were changed, requestBody might be empty but we still want to proceed if administratorIds were provided.
    // However, the current logic sends the request if requestBody is not empty OR if adminIds were present.
    // The check for requestBody.isEmpty should be sufficient if we ensure 'admins' is part of it.
    // Let's refine the condition for returning early:
    // if all potential fields including 'admins' would result in an empty body, then return.
    // For now, if administratorIds were provided, we assume a change is intended.
    // A more robust check might be: if (requestBody.keys.length == 1 && requestBody.containsKey('admins') && requestBody['admins'].isEmpty) return; // or similar
    // But given the logic, if administratorIds is not null and not empty, 'admins' key WILL be added.
    // So if requestBody is empty here, it means no other fields were changed.
    // If 'admins' was the *only* change, requestBody would contain only 'admins'.
    // Let's adjust the early return logic slightly:
    if (requestBody.isEmpty) {
      // This means name, active, maxGames, showPoints were all null or empty.
      // If administratorIds was also null or empty, then truly nothing to send.
      // If administratorIds HAD values, 'admins' would be in requestBody, so it wouldn't be empty.
      print(
          "[updateLeagueSettings] Request body is empty, nothing to update for leagueId: $leagueId.");
      return;
    }
  }

  print(
      "[updateLeagueSettings] Request Body for league $leagueId: ${jsonEncode(requestBody)}");

  final response = await http.patch(
    Uri.parse('https://api.techmanagement.tech/leagues/$leagueId'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(requestBody),
  );

  print(
      "[updateLeagueSettings] PATCH response for league $leagueId: ${response.statusCode}, ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(
        "[updateLeagueSettings] League settings updated successfully for leagueId: $leagueId.");
    ref.invalidate(leagueSettingsProvider(leagueId));
    ref.invalidate(userDataProvider);
  } else {
    print(
        "[updateLeagueSettings] Failed to update league settings for leagueId: $leagueId. Body: ${response.body}");
    String errorMessage = "Failed to update league settings";
    try {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is Map && decodedBody.containsKey('message')) {
        errorMessage = decodedBody['message'];
      } else {
        errorMessage = response.body.isNotEmpty
            ? response.body
            : "Status: ${response.statusCode}";
      }
    } catch (_) {
      errorMessage = response.body.isNotEmpty
          ? response.body
          : "Status: ${response.statusCode}";
    }
    throw Exception(errorMessage);
  }
}

Future<void> deleteLeague({
  required WidgetRef ref,
  required String leagueId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    print("[deleteLeague] Auth token is missing for leagueId: $leagueId.");
    throw Exception('User not logged in or token is missing');
  }

  print("[deleteLeague] Attempting to delete league $leagueId. Token: $token");

  final response = await http.delete(
    Uri.parse('https://api.techmanagement.tech/leagues/$leagueId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print(
      "[deleteLeague] DELETE response for league $leagueId: ${response.statusCode}, ${response.body}");

  // Typical success codes for DELETE are 200 (OK with content), 202 (Accepted), or 204 (No Content).
  if (response.statusCode == 200 ||
      response.statusCode == 202 ||
      response.statusCode == 204) {
    print("[deleteLeague] League $leagueId deleted successfully.");
    ref.invalidate(userDataProvider);
    ref.invalidate(leagueSettingsProvider(leagueId));
    // Also, clear the selected league if it was the one deleted
    if (ref.read(selectedLeagueProvider)?.id == leagueId) {
      ref.read(selectedLeagueProvider.notifier).state = null;
    }
  } else {
    String errorMessage = "Failed to delete league";
    try {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is Map && decodedBody.containsKey('message')) {
        errorMessage = decodedBody['message'];
      } else if (response.body.isNotEmpty) {
        errorMessage = response.body;
      } else {
        errorMessage = "Status: ${response.statusCode}";
      }
    } catch (_) {
      errorMessage = response.body.isNotEmpty
          ? response.body
          : "Status: ${response.statusCode}";
    }
    print(
        "[deleteLeague] Failed to delete league $leagueId. Error: $errorMessage");
    throw Exception(errorMessage);
  }
}


Future<void> leaveLeague({
  required WidgetRef ref,
  required String leagueId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    print("[leaveLeague] Auth token is missing for leagueId: $leagueId.");
    throw Exception('User not logged in or token is missing');
  }

  print("[leaveLeague] Attempting to leave league $leagueId. Token: $token");

  final response = await http.post(
    Uri.parse('https://api.techmanagement.tech/leagues/$leagueId/leave'),
    headers: {
      'Authorization': 'Bearer $token',
      // 'Content-Type': 'application/json', // POST usually has a body, but this endpoint might not require one.
      // If the API expects an empty JSON body, uncomment and add 'body: jsonEncode({})'
    },
    // body: jsonEncode({}), // If your API expects an empty JSON body for this POST request
  );

  print(
      "[leaveLeague] POST response for league $leagueId: ${response.statusCode}, ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("[leaveLeague] Successfully left league $leagueId.");
    ref.invalidate(userDataProvider); // Refresh user's league list
    ref.invalidate(leagueSettingsProvider(
        leagueId)); // Invalidate settings for the league left

    // Clear the selected league if it was the one left
    if (ref.read(selectedLeagueProvider)?.id == leagueId) {
      ref.read(selectedLeagueProvider.notifier).state = null;
    }
  } else {
    String errorMessage = "Failed to leave league";
    try {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is Map && decodedBody.containsKey('message')) {
        errorMessage = decodedBody['message'];
      } else if (response.body.isNotEmpty) {
        errorMessage = response.body;
      } else {
        errorMessage = "Status: ${response.statusCode}";
      }
    } catch (_) {
      // If response body is not JSON or empty
      errorMessage = response.body.isNotEmpty
          ? response.body
          : "Status: ${response.statusCode}";
    }
    print(
        "[leaveLeague] Failed to leave league $leagueId. Error: $errorMessage");
    throw Exception(errorMessage);
  }
}

final leaderboardDataProvider = FutureProvider.autoDispose.family<List<ApiLeaderboardPlayer>, ({String leagueId, String metricKey})>(
      (ref, params) async {
    if (params.leagueId.isEmpty) {
      return [];
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    final uri = Uri.parse('https://api.techmanagement.tech/leaderboard?metric=${params.metricKey}&leagueId=${params.leagueId}');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic>? playersList = responseBody['players'] as List<dynamic>?;

      if (playersList != null) {
        return playersList.map((playerJson) => ApiLeaderboardPlayer.fromJson(playerJson as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load leaderboard (Status: ${response.statusCode}): ${response.body}');
    }
  },
);

// --- START: Added for Leaderboard Metrics ---
// Metric Data Structure
class Metric {
  final String key;
  final String label;
  final String iconAssetPath;

  Metric({required this.key, required this.label, required this.iconAssetPath});
}

// Metric list
final List<Metric> leaderboardMetrics = [
  Metric(key: 'goals', label: 'Goals', iconAssetPath: "assets/icons/goals.png"),
  Metric(key: 'assists', label: 'Assists', iconAssetPath: "assets/icons/assist.png"),
  Metric(key: 'defence', label: 'Defence', iconAssetPath: "assets/icons/defence.png"),
  Metric(key: 'motm', label: 'MOTM', iconAssetPath: "assets/icons/motm.png"),
  Metric(key: 'impact', label: 'Impact', iconAssetPath: "assets/icons/impact.png"),
  Metric(key: 'cleanSheet', label: 'Clean Sheet', iconAssetPath: "assets/icons/cleansheet.png"),
];

// Selected Metric Provider
final selectedLeaderboardMetricProvider = StateProvider<String>((ref) {
  return leaderboardMetrics.first.key;
});
// --- END: Added for Leaderboard Metrics ---
