/*import 'package:champion_footballer/Utils/appextensions.dart';
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
}*/

import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:toastification/toastification.dart';

import '../../Utils/packages.dart';

final logoutProvider = Provider((ref) => LogoutController(ref));
//
// class LogoutController {
//   final Ref ref;
//
//   LogoutController(this.ref);
//
//   Future<void> logout(BuildContext context) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//
//       if (token == null) throw Exception('No token found');
//
//
//       await prefs.remove('auth_token');
//
//       toastification.show(
//         context: context,
//         type: ToastificationType.success,
//         style: ToastificationStyle.fillColored,
//         title: const Text('Logout successful'),
//       );
//
//
//       context.routeoffall(const SplashScreen());
//     } catch (e) {
//       toastification.show(
//         context: context,
//         type: ToastificationType.error,
//         style: ToastificationStyle.fillColored,
//         title: const Text('Logout failed'),
//         description: Text(e.toString()),
//       );
//     }
//   }
//
// }

class LogoutController {
  final Ref ref;

  LogoutController(this.ref);

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print("[LogoutController] Current token before removal: ${prefs.getString('auth_token')}");

      await prefs.remove('auth_token');
      print("[LogoutController] Token after removal: ${prefs.getString('auth_token')}");
      print("[LogoutController] 'auth_token' should now be null.");

      ref.invalidate(authCheckProvider);
      ref.invalidate(userDataProvider);
      print("[LogoutController] authCheckProvider and userDataProvider invalidated.");

      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text('Logout successful!'),
          autoCloseDuration: const Duration(seconds: 2),
        );
        print("[LogoutController] 'Logout successful!' toast should be shown.");
      } else {
        print("[LogoutController] Context was not mounted when trying to show logout success toast.");
      }
      await Future.delayed(const Duration(milliseconds: 100));
      print("[LogoutController] Delay finished, now navigating.");


      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
              (Route<dynamic> route) => false,
        );
        print("[LogoutController] Navigated to AuthScreen.");
      } else {
        print("[LogoutController] Context not mounted, cannot navigate.");
      }

    } catch (e) {
      print("[LogoutController] Error during logout: $e");
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: const Text('Logout failed'),
          description: Text(e.toString()),
          autoCloseDuration:
          const Duration(
              seconds: 2),
        );
      }
    }
  }
}







