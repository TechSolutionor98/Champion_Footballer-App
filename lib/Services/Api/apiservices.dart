// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// class ApiService {
//   final String baseUrl;
//   ApiService({required this.baseUrl});
//   // Login function to fetch the token
//   Future<String?> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/auth/login'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'user': {
//           'email': email,
//           'password': password,
//         }
//       }),
//     );
//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response, parse the token.
//       final responseData = json.decode(response.body);
//       final token = responseData['token']; // Assuming 'token' is returned
//       // Save token in shared preferences
//       final prefs = await SharedPreferences.getInstance();
//       prefs.setString('auth_token', token);
//       return token;
//     } else {
//       throw Exception('Failed to login');
//     }
//   }
// }

import 'dart:convert';
import 'package:champion_footballer/Model/Api%20Models/login_model.dart';
import 'package:champion_footballer/Model/Api%20Models/signup_model.dart';
import 'package:http/http.dart' as http;
import '../../Utils/packages.dart';

class AuthService {
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final url = Uri.parse('https://api.championfootballer.com/auth/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      // Save token locally
      final token = data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }

      return data;
    } else {
      throw Exception(data['message'] ?? 'Login failed: ${response.body}');
    }
  }

//signup
  Future<Map<String, dynamic>> signup(SignupRequest request) async {
    final url = Uri.parse('https://api.championfootballer.com/auth/signup');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
      return data;
    } else {
      throw Exception(data['message'] ?? 'Signup failed: ${response.body}');
    }
  }
//joinleague with invite code
  // Future<Map<String, dynamic>> joinLeague(
  //     String inviteCode, String token) async {
  //   final url = Uri.parse(
  //       'https://api.championfootballer.com/leagues/$inviteCode/join');

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to join league: ${response.body}');
  //   }
  // }
  Future<bool> joinLeague(String inviteCode, String token) async {
    final url = Uri.parse(
        'https://api.championfootballer.com/leagues/$inviteCode/join');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to join league');
    }
  }
  // Future<void> logout() async {
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
  // }
}
