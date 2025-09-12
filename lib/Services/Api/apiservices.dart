import 'dart:convert';
import 'package:champion_footballer/Model/Api%20Models/login_model.dart';
import 'package:champion_footballer/Model/Api%20Models/played_with_player_model.dart';
import 'package:champion_footballer/Model/Api%20Models/signup_model.dart';
import 'package:http/http.dart' as http;
import '../../Model/Api Models/dream_team_model.dart'; // Import for the new model
import '../../Utils/packages.dart';

class AuthService {
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final url =
        Uri.parse('https://api.techmanagement.tech/auth/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print("Login response: $data");

    if (response.statusCode == 200) {
      final token = data['token'] ?? data['accessToken'] ?? data['jwt'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print("Saved token: $token");
      } else {
        print("No token found in response!");
      }

      return data;
    } else {
      throw Exception(data['message'] ?? 'Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> signup(SignupRequest request) async {
    final url = Uri.parse(
        'https://api.techmanagement.tech/auth/register');

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

  Future<bool> joinLeague(String inviteCode, String token) async {
    final url =
        Uri.parse('https://api.techmanagement.tech/leagues/$inviteCode/join');

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

  Future<List<PlayedWithPlayer>> getPlayedWithPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final url = Uri.parse(
        'https://api.techmanagement.tech/players/played-with');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['players'] is List) {
        final playersList = data['players'] as List;
        return playersList
            .map((playerMap) => PlayedWithPlayer.fromMap(playerMap))
            .toList();
      } else {
        throw Exception('Failed to parse players from API response.');
      }
    } else {
      throw Exception('Failed to load players: ${response.body}');
    }
  }

  Future<DreamTeamResponse> getDreamTeam(String leagueId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print('[getDreamTeam] Authentication token not found.');
      throw Exception('Authentication token not found. Please log in again.');
    }

    final url = Uri.parse('https://api.techmanagement.tech/dream-team?leagueId=$leagueId');
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    print('[getDreamTeam] Requesting Dream Team Data...');
    print('[getDreamTeam] URL: ${url.toString()}');
    print('[getDreamTeam] Headers: $headers');

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      // Log status code regardless
      print('[getDreamTeam] Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('[getDreamTeam] Successfully fetched dream team. Raw Body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
        final data = jsonDecode(response.body);
        return DreamTeamResponse.fromJson(data);
      } else {
        // Improved error message extraction
        String errorMessage = 'Failed to load dream team for league $leagueId.';
        print('[getDreamTeam] Error Body: ${response.body}'); // Log the full error body

        try {
          final decodedBody = jsonDecode(response.body);
          if (decodedBody is Map) {
            if (decodedBody.containsKey('message') && decodedBody['message'] != null) {
              errorMessage = decodedBody['message'].toString();
            } else if (decodedBody.containsKey('error') && decodedBody['error'] != null) {
              errorMessage = decodedBody['error'].toString();
            } else if (response.body.isNotEmpty) {
              // Fallback to full body if specific keys aren't found but body exists
              errorMessage = response.body;
            }
          } else if (response.body.isNotEmpty) {
            // If body is not a map but is non-empty string
            errorMessage = response.body;
          }
        } catch (e) {
          // If JSON decoding fails or body is not a known structure
          print('[getDreamTeam] Could not parse error response body as JSON: $e');
          if (response.body.isNotEmpty) {
            errorMessage = response.body; // Use raw body if parsing fails
          }
        }
        // Add status code to the message for clarity
        errorMessage = 'Server error (${response.statusCode}): $errorMessage';
        print('[getDreamTeam] Throwing exception: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('[getDreamTeam] Exception caught: ${e.toString()}');
      // Ensure we throw an Exception object
      if (e is Exception) {
        throw e; // Re-throw if it's already an Exception
      }
      // Wrap other types of errors in an Exception
      throw Exception('Error fetching dream team: ${e.toString()}');
    }
  }
}
