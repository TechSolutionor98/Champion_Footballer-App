import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Auth/forgetpassword.dart';
import 'package:champion_footballer/Views/Start%20Page/mainstartpage.dart';
import 'package:toastification/toastification.dart';
import '../../Model/Api Models/login_model.dart';
import '../../Services/RiverPord Provider/ref_provider.dart';
import '../../Utils/packages.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginRequest? _lastRequest;
  // ignore: unused_field
  bool _isLoggingIn = false;

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text("Email and Password Required"),
      );
      return;
    }

    final request = LoginRequest(email: email, password: password);

    setState(() {
      _lastRequest = request;
      _isLoggingIn = true;
    });
    // Step 3: Call API
    try {
      final response = await ref.read(loginProvider(request).future);

      print(response.toString());
      // Step 4: Check and use response (you can store token here too)
      if (!mounted) return;
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: const Text('Login Successful!'),
        autoCloseDuration: const Duration(seconds: 3),
      );

      context.routeoffall(DashboardScreen2());
    } catch (error) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(error.toString()),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = _lastRequest;
    final isLoading =
        request != null ? ref.watch(loginProvider(request)).isLoading : false;

    return Column(
      children: [
        PrimaryTextField(
          controller: emailController,
          labelText: 'Email Address',
          hintText: 'your.email@address.com',
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: passwordController,
          labelText: 'Password',
          hintText: '********',
          obsecure: true,
        ),
        40.0.heightbox,
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SecondaryButton(
                width: 140,
                buttonText: 'Login',
                onPressFunction: _login,
              ),
        10.0.heightbox,
        GestureDetector(
          onTap: () {
            context.route(const ForgotPasswordScreen());
          },
          child: const Text(
            'Reset Password',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
