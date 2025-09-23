import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/imageconstants.dart';
import '../../Utils/packages.dart'; // Should import Material, ConsumerWidget, ref, etc.
import 'loginform.dart'; // Ensure these are correctly imported
import 'registerform.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: ScaffoldCustom(
        body: Container(
          color: const Color(0xFF286194),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                // Scrolling Background Image Layer
                Image.asset(
                  AppImages.authBackground,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Logo
                      SafeArea(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 20.0),
                          child: Image.asset(
                            AppImages.logo,
                            width: context.width * 0.55,
                          ),
                        ),
                      ),
                      460.0.heightbox,
                      Padding(
                        padding: defaultPadding(vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Toggle button
                            Align(
                              alignment: Alignment.centerRight,
                              child: SecondaryButton(
                                buttonText:
                                    authState.isLogin ? "Join" : "Login",
                                onPressFunction: () => authNotifier
                                    .toggleAuthMode(!authState.isLogin),
                                width: 90,
                                height: 38,
                                buttonColor: Colors.black, // Assuming button color was black
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Forms
                            AnimatedSwitcher(
                              duration:
                                  const Duration(milliseconds: 350),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                              child: authState.isLogin
                                  ? const LoginForm(key: ValueKey("login"))
                                  : const RegisterForm(
                                      key: ValueKey("register")),
                            ),
                          ],
                        ),
                      ),
                      40.0.heightbox,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
