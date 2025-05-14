import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

import '../../Utils/packages.dart';

final logoutProvider = Provider((ref) => LogoutController(ref));

class LogoutController {
  final Ref ref;

  LogoutController(this.ref);

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('https://api.championfootballer.com/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('auth_token');

        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text('Logout successful'),
        );

        context.routeoffall(const SplashScreen()); // force splash recheck
      } else {
        throw Exception('Logout failed');
      }
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text('Logout failed'),
        description: Text(e.toString()),
      );
    }
  }
}
