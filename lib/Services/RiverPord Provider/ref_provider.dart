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
  print("[authCheckProvider] Evaluating auth status..."); 
  final prefs = await SharedPreferences.getInstance();
  final tokenInProvider = prefs.getString('auth_token');
  print("[authCheckProvider] Token found in SharedPreferences by provider: '$tokenInProvider'"); 
  final isLoggedIn = tokenInProvider != null && tokenInProvider.isNotEmpty;
  print("[authCheckProvider] Provider determined isLoggedIn: $isLoggedIn"); 
  return isLoggedIn;
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

  // Check file size before upload
  final fileSize = await profileImageFile.length();
  final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);
  print("[uploadProfilePicture] File size: $fileSizeKB KB");

  if (fileSize > 1024000) { // If larger than 1MB, warn but continue
    print("[uploadProfilePicture] ⚠️ Warning: File is quite large ($fileSizeKB KB), may fail");
  }

  final uri = Uri.parse('https://api.techmanagement.tech/profile/picture');
  final request = http.MultipartRequest('POST', uri); // ✅ Changed from PATCH to POST
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

  print("[uploadProfilePicture] Uploading to $uri with POST method");

  try {
    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 45), // Increased timeout for slower connections
      onTimeout: () {
        throw Exception('Upload timeout - server did not respond in 45 seconds');
      },
    );
    final response = await http.Response.fromStream(streamedResponse);

    print(
        "[uploadProfilePicture] Response: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("[uploadProfilePicture] ✅ Profile picture uploaded successfully.");
      
      // ✅ CRITICAL: Clear image cache BEFORE invalidating provider
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      
      // Wait a bit for server to process
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Now invalidate and refresh
      ref.invalidate(userDataProvider);
      await ref.refresh(userDataProvider.future);
      
      print("[uploadProfilePicture] ✅ Cache cleared and data refreshed");
    } else {
      print(
          "[uploadProfilePicture] ❌ Upload failed. Body: ${response.body}");
      throw Exception("Failed to upload: ${response.body}");
    }
  } catch (e) {
    print("[uploadProfilePicture] ❌ Error: $e");
    throw Exception("Error uploading: $e");
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
    FutureProvider.family<LeaguesJoined, CreateLeagueRequest>( // MODIFIED: Return type
  (ref, request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final uri = Uri.parse('https://api.techmanagement.tech/leagues');
    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = request.name;

    if (request.image != null && request.image!.isNotEmpty) {
      final file = File(request.image!);
      if (!file.existsSync() || file.lengthSync() == 0) {
        throw Exception('Image file invalid or empty: ${request.image}');
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      // API response includes: {"success":true,"message":"...","league":{...}}
      if (responseBody['success'] == true && responseBody['league'] != null) {
        // MODIFIED: Parse and return the league object
        return LeaguesJoined.fromJson(responseBody['league'] as Map<String, dynamic>);
      } else {
        // Handle cases where 'success' is false or 'league' is missing from a 2xx response
        throw Exception(
            responseBody['message'] ?? 'League creation succeeded but API response format is unexpected.');
      }
    } else {
      // Handle server errors (non-2xx responses)
      String errorMessage = 'Server error ${response.statusCode}';
      try {
        final decodedBody = jsonDecode(response.body);
        if (decodedBody is Map && decodedBody.containsKey('message')) {
          errorMessage = decodedBody['message'];
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      } catch (e) {
        // Fallback if error body isn't JSON or doesn't have 'message'
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }
      throw Exception(errorMessage);
    }
  },
);

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
  print("DEBUG getMatchById API URL for $matchId: $url");
  print("DEBUG getMatchById API Status for $matchId: ${response.statusCode}");
  print("DEBUG getMatchById API Body for $matchId: ${response.body}");
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception(
        "Failed to fetch match: ${response.statusCode} ${response.body}");
  }
}

final detailedMatchProvider = FutureProvider.family<Match, ({String leagueId, String matchId})>(
        (ref, ids) async {
      // Calling the existing getMatchById function from your file
      final matchDataMap = await getMatchById(ids.matchId, ids.leagueId);
      // MODIFIED LINE: Ensure we pass the nested 'match' object and cast it.
      return Match.fromJson(matchDataMap['match'] as Map<String, dynamic>);
    }
);

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

  if (administratorIds != null && administratorIds.isNotEmpty) {
    requestBody['admins'] =
        administratorIds;
  }

  if (requestBody.isEmpty &&
      !(administratorIds != null && administratorIds.isNotEmpty)) {
    if (requestBody.isEmpty) {
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
  
  // ✅ Store the current selected league BEFORE deletion
  final currentSelectedLeague = ref.read(selectedLeagueProvider);
  final wasDeletingSelectedLeague = currentSelectedLeague?.id == leagueId;

  final response = await http.delete(
    Uri.parse('https://api.techmanagement.tech/leagues/$leagueId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print(
      "[deleteLeague] DELETE response for league $leagueId: ${response.statusCode}, ${response.body}");
  if (response.statusCode == 200 ||
      response.statusCode == 202 ||
      response.statusCode == 204) {
    print("[deleteLeague] League $leagueId deleted successfully.");
    
    // ✅ Clear the selected league FIRST (only if we're deleting the currently selected one)
    if (wasDeletingSelectedLeague) {
      ref.read(selectedLeagueProvider.notifier).state = null;
    }
    
    // ✅ Invalidate providers
    ref.invalidate(userDataProvider);
    ref.invalidate(leagueSettingsProvider(leagueId));
    ref.invalidate(userStatusLeaguesProvider);
    
    // ✅ Wait for fresh data
    await Future.delayed(const Duration(milliseconds: 300));
    
    // ✅ Refresh and get fresh user data
    final freshUser = await ref.refresh(userDataProvider.future);
    await ref.refresh(userStatusLeaguesProvider.future);
    
    // ✅ Auto-select the appropriate league
    final remainingLeagues = freshUser.leagues ?? [];
    if (remainingLeagues.isNotEmpty) {
      LeaguesJoined leagueToSelect;
      
      if (wasDeletingSelectedLeague) {
        // If we deleted the selected league, find the next best option
        // Try to find the league that was selected before (by checking creation order)
        // Since we don't have that info, we'll select the first one (oldest)
        leagueToSelect = remainingLeagues.first;
        print("[deleteLeague] Deleted selected league, selecting oldest: ${leagueToSelect.name}");
      } else {
        // If we deleted a different league, keep the current selection
        // Find the current selection in the fresh data
        leagueToSelect = remainingLeagues.firstWhere(
          (l) => l.id == currentSelectedLeague?.id,
          orElse: () => remainingLeagues.first,
        );
        print("[deleteLeague] Kept current selection: ${leagueToSelect.name}");
      }
      
      ref.read(selectedLeagueProvider.notifier).state = leagueToSelect;
    } else {
      print("[deleteLeague] No leagues remaining after deletion");
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
    },
  );

  print(
      "[leaveLeague] POST response for league $leagueId: ${response.statusCode}, ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("[leaveLeague] Successfully left league $leagueId.");
    ref.invalidate(userDataProvider);
    ref.invalidate(leagueSettingsProvider(
        leagueId));

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

class Metric {
  final String key;
  final String label;
  final String iconAssetPath;

  Metric({required this.key, required this.label, required this.iconAssetPath});
}

final List<Metric> leaderboardMetrics = [
  Metric(key: 'goals', label: 'Goals', iconAssetPath: "assets/icons/goals.png"),
  Metric(key: 'assists', label: 'Assists', iconAssetPath: "assets/icons/assist.png"),
  Metric(key: 'defence', label: 'Defence', iconAssetPath: "assets/icons/defence.png"),
  Metric(key: 'motm', label: 'MOTM', iconAssetPath: "assets/icons/motm.png"),
  Metric(key: 'impact', label: 'Impact', iconAssetPath: "assets/icons/impact.png"),
  Metric(key: 'cleanSheet', label: 'Clean Sheet', iconAssetPath: "assets/icons/cleansheet.png"),
];

final selectedLeaderboardMetricProvider = StateProvider<String>((ref) {
  return leaderboardMetrics.first.key;
});

// Added userStatusLeaguesProvider
final userStatusLeaguesProvider = FutureProvider<List<LeaguesJoined>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  print("[userStatusLeaguesProvider] Attempting to fetch leagues from /auth/status. Token: $token");

  if (token == null || token.isEmpty) {
    print("[userStatusLeaguesProvider] No token found, throwing Exception.");
    throw Exception('User not logged in or token is missing for fetching leagues via /auth/status');
  }

  final response = await http.get(
    Uri.parse('https://api.techmanagement.tech/auth/status'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("[userStatusLeaguesProvider] Response status: ${response.statusCode}");

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['success'] == true && jsonResponse['user'] != null) {
      final userData = jsonResponse['user'] as Map<String, dynamic>;
      final List<LeaguesJoined> leaguesToReturn = [];

      if (userData['leagues'] != null) {
        final leaguesList = userData['leagues'] as List;
        leaguesToReturn.addAll(leaguesList.map((leagueJson) =>
            LeaguesJoined.fromJson(leagueJson as Map<String, dynamic>)));
      }
      
      // ✅ Sort leagues by creation date (oldest to newest)
      // This ensures .last always gives the most recently created/joined
      leaguesToReturn.sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;
        
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return -1;
        if (bDate == null) return 1;
        
        return aDate.compareTo(bDate);
      });

      print("[userStatusLeaguesProvider] Successfully fetched ${leaguesToReturn.length} leagues (sorted by creation date).");
      return leaguesToReturn;
    } else {
      print("[userStatusLeaguesProvider] Error: 'success' is not true or 'user' object is missing in /auth/status response. Body: ${response.body}");
      throw Exception('Failed to parse leagues from /auth/status. Response format unexpected.');
    }
  } else {
    print("[userStatusLeaguesProvider] Error fetching leagues from /auth/status. Status: ${response.statusCode}, Body: ${response.body}");
    throw Exception('Failed to load leagues from /auth/status. Status: ${response.statusCode}');
  }
});

final allMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final response = await http.get(Uri.parse('https://api.techmanagement.tech/matches'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['success'] == true && data['matches'] != null) {
      final List<dynamic> matchesJson = data['matches'];
      return matchesJson.map((json) => Match.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('API error: ${data['message'] ?? 'Failed to load matches'}');
    }
  } else {
    throw Exception('Failed to load matches: HTTP Status ${response.statusCode}');
  }
});