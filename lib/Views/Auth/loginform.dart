import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Start%20Page/mainstartpage.dart';
import 'package:toastification/toastification.dart';
import '../../Model/Api Models/login_model.dart';
import '../../Model/Api Models/resetpass_model.dart'; // Added for ResetPasswordRequest
import '../../Services/RiverPord Provider/ref_provider.dart';
import '../../Utils/packages.dart';
import 'authmain.dart'; // Added for AuthScreen

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginRequest? _lastLoginRequest; // Renamed for clarity
  ResetPasswordRequest? _lastResetRequest; // Added
  bool _obscurePassword = true;
  bool _isSendingResetEmail = false; // Added

void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text("Email and Password Required"),
        autoCloseDuration:
        const Duration(
            seconds: 2),
      );
      return;
    }

    final request = LoginRequest(email: email, password: password);

    setState(() {
      _lastLoginRequest = request; 
    });

    print("[LoginForm - _login] Attempting login. Email: $email");

    try {
      print("[LoginForm - _login] Calling ref.read(loginProvider(request).future)...");
      final loginDataFromProvider = await ref.read(loginProvider(request).future);
      print("[LoginForm - _login] loginProvider call successful. Login API Response: $loginDataFromProvider");
      
      final prefs = await SharedPreferences.getInstance();
      final tokenAfterLoginProvider = prefs.getString('auth_token');
      print("[LoginForm - _login] Token in SharedPreferences immediately after loginProvider success: $tokenAfterLoginProvider");

      // CRITICAL CHANGE: Refresh userDataProvider BEFORE invalidating authCheckProvider
      // that might trigger immediate navigation.
      print("[LoginForm - _login] Calling ref.refresh(userDataProvider.future) BEFORE authCheckProvider invalidation...");
      await ref.refresh(userDataProvider.future); 
      print("[LoginForm - _login] userDataProvider.future refreshed successfully.");

      // Now that user data is likely ready (or an error from it would have been caught),
      // invalidate authCheckProvider to trigger navigation by the parent.
      print("[LoginForm - _login] Invalidating authCheckProvider to trigger navigation...");
      ref.invalidate(authCheckProvider);
      
      // Show success toast (only if mounted, though by this point, navigation might be imminent)
      if (mounted) { 
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text('Login Successful!'),
          autoCloseDuration: const Duration(seconds: 2),
        );
         print("[LoginForm - _login] Login success toast shown.");
      } else {
        print("[LoginForm - _login] Not mounted when trying to show success toast, navigation likely already happened.");
      }
      
      // The actual navigation to DashboardScreen2 should now be handled by 
      // whatever widget is watching authCheckProvider (e.g., your MyApp or a wrapper).
      // So, we might not need the explicit Navigator.of(context).pushAndRemoveUntil here anymore
      // if authCheckProvider reliably handles it. 
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const DashboardScreen2()),
      //       (Route<dynamic> route) => false,
      // );

    } catch (error) {
      // Important: Check mounted BEFORE trying to use context for toast
      if (mounted) {
        print("[LoginForm] Login error: $error"); 
        print("[LoginForm - _login] DETAILED ERROR during login process: $error");

        String errorMessage = error.toString();
        if (error is Exception) {
            final msg = error.toString();
            if (msg.startsWith("Exception: ")) {
              errorMessage = msg.substring("Exception: ".length);
            }
        }
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: Text(errorMessage),
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
         print("[LoginForm - _login] Not mounted in error block. Error: $error");
      }
    } finally {
        print("[LoginForm - _login] Login process try/catch block finished.");
    }
}

  Future<void> _handleForgotPassword() async { // Made async
    if (_isSendingResetEmail) return; // Prevent multiple submissions

    final email = emailController.text.trim();
    if (email.isEmpty) {
      toastification.show(
        context: context,
        title: const Text("Please enter your email above first."),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }

    final request = ResetPasswordRequest(email: email);
    setState(() {
      _lastResetRequest = request;
      _isSendingResetEmail = true;
    });

    try {
      // It's important that resetPasswordProvider is correctly defined
      // to handle the request and not expect UI-driven loading from 'watch' here,
      // as we are using 'read' for a one-time operation.
      await ref.read(resetPasswordProvider(request).future);
      if (!mounted) return;

      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: const Text("Reset email sent successfully"),
        autoCloseDuration: const Duration(seconds: 2),
      );

      // Navigate to AuthScreen
      // context.routeoffall is a custom extension, ensure it works as expected.
      // Standard Flutter way:
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (Route<dynamic> route) => false);

    } catch (error) {
      if (!mounted) return;
      String errorMessage = error.toString();
       if (error is Exception) {
          final msg = error.toString();
          if (msg.startsWith("Exception: ")) {
            errorMessage = msg.substring("Exception: ".length);
          }
      }
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(errorMessage),
         autoCloseDuration: const Duration(seconds: 2),
      );
    } finally {
      if(mounted){
        setState(() => _isSendingResetEmail = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final loginRequest = _lastLoginRequest; // Use renamed variable
    final isLoginLoading = loginRequest != null ? ref.watch(loginProvider(loginRequest)).isLoading : false;

    // We could potentially watch resetPasswordProvider loading state if we want UI changes
    // final resetRequest = _lastResetRequest;
    // final isResetLoading = resetRequest != null ? ref.watch(resetPasswordProvider(resetRequest)).isLoading : _isSendingResetEmail;
    // For now, _isSendingResetEmail handles the basic non-reentrant logic.

    return Column(
      children: [
        /// Email
        PrimaryTextField(
          controller: emailController,
          hintText: 'Email address',
          height: 50,
        ),
        20.0.heightbox,

        /// Password
        PrimaryTextField(
          controller: passwordController,
          height: 50,
          hintText: 'Password',
          obsecure: _obscurePassword,
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        40.0.heightbox,

        /// Sign In Button with Gradient
        isLoginLoading // Use login loading state
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFF57C00),))
            : Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF57C00),
                Color(0xFFD32F2F),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SecondaryButton(
            width: double.infinity,
            height: 50.0,
            buttonText: 'Sign In',
            onPressFunction: _login,
            buttonColor: Colors.transparent,
            textColor: Colors.white,
          ),
        ),
        10.0.heightbox,

        /// Forgot Password
        GestureDetector(
          onTap: _isSendingResetEmail ? null : _handleForgotPassword,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _isSendingResetEmail
                ? SizedBox(
                    height: 16, width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  )
                : const Text(
              'Forgot your password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
