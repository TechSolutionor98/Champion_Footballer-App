import 'package:champion_footballer/Utils/appextensions.dart';
// import 'package:champion_footballer/Views/Start%20Page/firstloginstartpage.dart'; // Not used in this logic path
import 'package:champion_footballer/Views/Start%20Page/mainstartpage.dart'; // For navigation
import 'package:champion_footballer/Widgets/genderradiobutton.dart';
import 'package:toastification/toastification.dart';
import '../../Model/Api Models/signup_model.dart';
import '../../Services/RiverPord Provider/ref_provider.dart';
import '../../Utils/packages.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final age = int.tryParse(ageController.text.trim());
    final gender = ref.read(authProvider).selectedGender;

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        age == null) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text("All fields are required"),
      );
      return;
    }

    if (password != confirmPassword) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text("Passwords do not match"),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = SignupRequest(
      email: email,
      password: password,
      age: age,
      gender: gender ?? 'Male', // Defaulting to 'Male' if null, ensure this is desired
      firstName: firstName,
      lastName: lastName,
    );
    
    print("[RegisterForm - _register] Attempting registration. Email: $email");

    try {
      print("[RegisterForm - _register] Calling ref.read(signupProvider(request).future)...");
      final signupDataFromProvider = await ref.read(signupProvider(request).future);
      // signupProvider internally calls AuthService.signup, which should save the new token.
      print("[RegisterForm - _register] signupProvider call successful. Signup API Response: $signupDataFromProvider");
      
      final prefs = await SharedPreferences.getInstance();
      final tokenAfterSignupProvider = prefs.getString('auth_token');
      print("[RegisterForm - _register] Token in SharedPreferences immediately after signupProvider success: $tokenAfterSignupProvider");

      if (!mounted) {
        print("[RegisterForm - _register] Not mounted after signupProvider success. Aborting.");
        return;
      }

      // CRITICAL CHANGE: Refresh userDataProvider BEFORE invalidating authCheckProvider
      print("[RegisterForm - _register] Calling ref.refresh(userDataProvider.future) BEFORE authCheckProvider invalidation...");
      await ref.refresh(userDataProvider.future); 
      print("[RegisterForm - _register] userDataProvider.future refreshed successfully.");

      // Now that user data is likely ready, invalidate authCheckProvider 
      // to trigger navigation by the parent app structure.
      print("[RegisterForm - _register] Invalidating authCheckProvider to trigger navigation...");
      ref.invalidate(authCheckProvider);
      
      // Clear any selected league from a previous session (if applicable)
      ref.read(selectedLeagueProvider.notifier).state = null;
      print("[RegisterForm - _register] Selected league provider cleared.");

      // Show success toast (only if mounted)
      if (mounted) { 
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text('Signup successful!'),
          autoCloseDuration: const Duration(seconds: 3),
        );
         print("[RegisterForm - _register] Signup success toast shown.");
      } else {
        print("[RegisterForm - _register] Not mounted when trying to show success toast, navigation likely already happened.");
      }
      
      // The actual navigation to DashboardScreen2 should now be handled by 
      // whatever widget is watching authCheckProvider (e.g., your MyApp or a similar wrapper).
      // Commenting out the local navigation.
      /*
      if (!mounted) {
        print("[RegisterForm - _register] Not mounted before final navigation attempt. Aborting local nav.");
        return;
      }
      print("[RegisterForm - _register] (Potentially redundant) Navigating to DashboardScreen2 locally...");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen2()),
            (Route<dynamic> route) => false,
      );
      print("[RegisterForm - _register] Local navigation attempt complete.");
      */

    } catch (error) {
      if (mounted) {
        print("[RegisterForm] Signup error: $error"); 
        print("[RegisterForm - _register] DETAILED ERROR during signup process: $error");

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
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
         print("[RegisterForm - _register] Not mounted in error block during signup. Error: $error");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      print("[RegisterForm - _register] Signup process try/catch block finished.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextField(
          controller: emailController,
          height: 50,
          hintText: 'Email address',
        ),
        20.0.heightbox,
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
        20.0.heightbox,
        PrimaryTextField(
          controller: confirmPasswordController,
          hintText: 'Confirm password',
          height: 50,
          obsecure: _obscureConfirmPassword,
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            child: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: firstNameController,
          hintText: 'First name',
          height: 50,
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: lastNameController,
          hintText: 'Last name',
          height: 50,
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          height: 50,
          hintText: 'Age',
        ),
        20.0.heightbox,
        Text(
          'Gender',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            GenderSelectionButton(
              gender: 'Male',
              isSelected: authState.selectedGender == 'Male',
              onSelected: () => authNotifier.selectGender('Male'),
            ),
            GenderSelectionButton(
              gender: 'Female',
              isSelected: authState.selectedGender == 'Female',
              onSelected: () => authNotifier.selectGender('Female'),
            ),
          ],
        ),
        20.0.heightbox,
        _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFF57C00),))
            : Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF57C00), // orange
                Color(0xFFD32F2F), // red
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SecondaryButton(
            buttonText: "Register",
            onPressFunction: _register,
            width: double.infinity,
            height: 50.0,
            buttonColor: Colors.transparent, 
            textColor: Colors.white, 
          ),
        ),
        10.0.heightbox,
      ],
    );
  }
}
