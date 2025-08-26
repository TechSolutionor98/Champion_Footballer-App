import 'dart:convert';
import 'package:champion_footballer/Model/Api%20Models/login_model.dart';
import 'package:champion_footballer/Model/Api%20Models/signup_model.dart';
import 'package:champion_footballer/Services/Api/apiservices.dart';
import 'package:http/http.dart' as http;
import '../../Model/Api Models/contact_model.dart';
import '../../Model/Api Models/createleague_model.dart';
import '../../Model/Api Models/joinleagueinvite_model.dart';
import '../../Model/Api Models/resetpass_model.dart';
import '../../Model/Api Models/usermodel.dart';
import '../../Utils/packages.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, LoginRequest>((ref, request) async {
  final service = ref.read(authServiceProvider);
  return service.login(request);
});

//signup
final signupProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, SignupRequest>((ref, request) async {
  final service = ref.read(authServiceProvider);
  return service.signup(request);
});
//authcheck
final authCheckProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  return token != null && token.isNotEmpty;
});

//user data
final userDataProvider = FutureProvider<WelcomeUser>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token =
      prefs.getString('auth_token'); // Retrieve token from shared preferences
  final response = await http.get(
    Uri.parse('https://championfootballer-server.onrender.com/auth/data'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    print("API Response: ${response.body}");
    final json = jsonDecode(response.body);
    return WelcomeUser.fromJson(json['user']);
  } else {
    print("Error: ${response.statusCode}, ${response.body}");
    throw Exception('Failed to load user data');
  }
});

Future<bool> joinLeague(String inviteCode, String token) async {
  try {
    final response = await http.post(
      Uri.parse('https://championfootballer-server.onrender.com/leagues/join'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'inviteCode': inviteCode}),
    );

    print("Join league response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      // Successfully joined the league
      return true;
    } else {
      // Parse error message from backend
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
  required String? mainPosition,
  required String? subPosition,
  required String? preferredFoot,
  required WidgetRef ref,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  final response = await http.patch(
    Uri.parse("https://championfootballer-server.onrender.com/profile"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "mainPosition": mainPosition,
      "position": subPosition,
      "preferredFoot": preferredFoot,
    }),
  );

  print("PATCH response: ${response.statusCode}, ${response.body}"); // 👈 debug

  if (response.statusCode == 200) {
    ref.refresh(userDataProvider); // refresh user data
  } else {
    throw Exception("Failed to update profile: ${response.body}");
  }
}

// final userDataProvider = FutureProvider<WelcomeUser>((ref) async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('auth_token');
//
//   if (token == null || token.isEmpty) {
//     print("⚠️ No token found in SharedPreferences");
//     throw Exception("User not logged in");
//   }
//
//   final response = await http.get(
//     Uri.parse('https://championfootballer-server.onrender.com/auth/data'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     },
//   );
//
//   print("Status Code: ${response.statusCode}");
//   print("Response: ${response.body}");
//
//   if (response.statusCode == 200) {
//     final json = jsonDecode(response.body);
//     return json['user'] != null
//         ? WelcomeUser.fromJson(json['user'])
//         : WelcomeUser.fromJson(json);
//   } else {
//     throw Exception('Failed to load user data');
//   }
// });

//reset password

final resetPasswordProvider =
    FutureProvider.family<void, ResetPasswordRequest>((ref, request) async {
  final response = await http.post(
    Uri.parse('https://api.championfootballer.com/auth/reset-password'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(request.toJson()),
  );
  if (response.statusCode == 200) {
    // Optionally parse response
    return;
  } else {
    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Reset password failed');
  }
});

//create new league

final createLeagueProvider =
    FutureProvider.family<void, CreateLeagueRequest>((ref, request) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final response = await http.post(
    Uri.parse('https://api.championfootballer.com/leagues'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(request.toJson()),
  );

  if (response.statusCode != 200) {
    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Failed to create league');
  }
});
//joinleague with invite code

// final joinLeagueProvider = FutureProvider.family
//     .autoDispose<bool, JoinLeagueRequest>((ref, request) async {
//   final service = ref.read(authServiceProvider);
//   return service.joinLeague(request.inviteCode, request.token);
// });
//
// final selectedLeagueProvider = StateProvider<LeaguesJoined?>((ref) => null);


final joinLeagueProvider = FutureProvider.family
    .autoDispose<bool, JoinLeagueRequest>((ref, request) async {
  // Directly call the joinLeague function
  return await joinLeague(request.inviteCode, request.token);
});

final selectedLeagueProvider = StateProvider<LeaguesJoined?>((ref) => null);

//contact us

final contactUsProvider =
    FutureProvider.family<bool, ContactRequest>((ref, request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
  final response = await http.post(
    Uri.parse('https://championfootballer-server.onrender.com/'),
    headers: {'Content-Type': 'application/json' , 'Authorization': 'Bearer $token'},
    body: jsonEncode(request.toJson()),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Failed to send message");
  }
});

  // //logout
  // final logoutProvider = FutureProvider<void>((ref) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');

  //   if (token == null) throw Exception('No token found');

  //   final response = await http.get(
  //     Uri.parse('https://api.championfootballer.com/auth/logout'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     await prefs.remove('auth_token');
  //   } else {
  //     throw Exception('Logout failed');
  //   }
  // });

