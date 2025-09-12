import 'package:champion_footballer/Utils/appextensions.dart';

import '../../Utils/packages.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: ScaffoldCustom(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                20.0.heightbox,
                Image.asset(
                  AppImages.logo,
                  width: context.width * .5,
                ),
                50.0.heightbox,
                Container(
                  padding: defaultPadding(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 2,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => authNotifier.toggleAuthMode(true),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: authState.isLogin
                                    ? kPrimaryColor
                                    : ktextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: authState.isLogin ? 14 : 12,
                              ),
                            ),
                          ),
                          10.0.widthbox,
                          GestureDetector(
                            onTap: () => authNotifier.toggleAuthMode(false),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: !authState.isLogin
                                    ? kPrimaryColor
                                    : ktextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: authState.isLogin ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      authState.isLogin
                          ? const LoginForm()
                          : const RegisterForm(),
                    ],
                  ),
                ),
                40.0.heightbox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
