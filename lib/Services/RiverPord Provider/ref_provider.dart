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
    Uri.parse('https://api.championfootballer.com/auth/data'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return WelcomeUser.fromJson(json['user']);
  } else {
    throw Exception('Failed to load user data');
  }
});
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

final joinLeagueProvider = FutureProvider.family
    .autoDispose<bool, JoinLeagueRequest>((ref, request) async {
  final service = ref.read(authServiceProvider);
  return service.joinLeague(request.inviteCode, request.token);
});

final selectedLeagueProvider = StateProvider<LeaguesJoined?>((ref) => null);

//contact us

final contactUsProvider =
    FutureProvider.family<bool, ContactRequest>((ref, request) async {
  final response = await http.post(
    Uri.parse('https://api.championfootballer.com/contact'),
    headers: {'Content-Type': 'application/json'},
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

