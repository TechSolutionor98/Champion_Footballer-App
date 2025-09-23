import 'package:champion_footballer/Controllers/splashopacityprovider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import '../../Services/RiverPord Provider/ref_provider.dart';
import '../../Utils/packages.dart';
import '../Start Page/mainstartpage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  // Future<void> _checkAuth() async {
  //   final result = await ref.read(authCheckProvider.future);
  //   if (!mounted) return;
  //   setState(() {
  //     isLoggedIn = result;
  //   });
  // }

  Future<void> _checkAuth() async {
    print("[SplashScreen] _checkAuth called.");

    final prefsForDebug = await SharedPreferences.getInstance();
    print("[SplashScreen] Token directly from SharedPreferences in _checkAuth: ${prefsForDebug.getString('auth_token')}");

    final result = await ref.read(authCheckProvider.future);
    print("[SplashScreen] Result from authCheckProvider.future: $result");
    print("[SplashScreen] isLoggedIn will be set to: $result");

    if (!mounted) {
      print("[SplashScreen] Not mounted, exiting _checkAuth.");
      return;
    }
    setState(() {
      isLoggedIn = result;
    });
  }

  void _handleButtonTap() {
    if (isLoggedIn == true) {
      context.routeoffall(const DashboardScreen2());
    } else {
      context.routeoffall(const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final opacity = ref.watch(splashOpacityProvider);
    return ScaffoldCustom(
      body: SafeArea(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.logo, height: 100),
              100.0.heightbox,
              Image.asset(AppImages.splash, height: 150),
              100.0.heightbox,
              Center(
                child: const Text(
                  'Track your progress, set availability,\nand dive into matches and leagues\nall from here.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ktextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              20.0.heightbox,
              if (isLoggedIn == null)
                const CircularProgressIndicator()
              else
                SecondaryButton(
                  buttonText: isLoggedIn! ? "Continue" : "Get Started",
                  onPressFunction: _handleButtonTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
