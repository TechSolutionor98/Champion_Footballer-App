// import 'package:champion_footballer/Utils/appextensions.dart';
// import 'package:champion_footballer/Views/Start%20Page/firstloginstartpage.dart';
// import 'package:champion_footballer/Widgets/genderradiobutton.dart';
// import 'package:toastification/toastification.dart';
// import '../../Model/Api Models/signup_model.dart';
// import '../../Services/RiverPord Provider/ref_provider.dart';
// import '../../Utils/packages.dart';
//
// class RegisterForm extends ConsumerStatefulWidget {
//   const RegisterForm({super.key});
//
//   @override
//   ConsumerState<RegisterForm> createState() => _RegisterFormState();
// }
//
// class _RegisterFormState extends ConsumerState<RegisterForm> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final ageController = TextEditingController();
//
//   bool _isLoading = false;
//
//   void _register() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//     final confirmPassword = confirmPasswordController.text.trim();
//     final firstName = firstNameController.text.trim();
//     final lastName = lastNameController.text.trim();
//     final age = int.tryParse(ageController.text.trim());
//     final gender = ref.read(authProvider).selectedGender;
//
//     // Validate inputs
//     if (email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty ||
//         firstName.isEmpty ||
//         lastName.isEmpty ||
//         age == null) {
//       toastification.show(
//         context: context,
//         type: ToastificationType.error,
//         style: ToastificationStyle.fillColored,
//         title: const Text("All fields are required"),
//       );
//       return;
//     }
//
//     if (password != confirmPassword) {
//       toastification.show(
//         context: context,
//         type: ToastificationType.error,
//         style: ToastificationStyle.fillColored,
//         title: const Text("Passwords do not match"),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     final request = SignupRequest(
//       email: email,
//       password: password,
//       age: age,
//       gender: gender ?? 'Male',
//       firstName: firstName,
//       lastName: lastName,
//     );
//
//     try {
//       await ref.read(signupProvider(request).future);
//
//       if (!mounted) return;
//       toastification.show(
//         context: context,
//         type: ToastificationType.success,
//         style: ToastificationStyle.fillColored,
//         title: const Text("Signup successful!"),
//         autoCloseDuration: const Duration(seconds: 3),
//       );
//       context.routeoffall(StartPage());
//       // Optionally, redirect to login or start screen
//     } catch (e) {
//       toastification.show(
//         context: context,
//         type: ToastificationType.error,
//         style: ToastificationStyle.fillColored,
//         title: Text(e.toString()),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final authNotifier = ref.read(authProvider.notifier);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         PrimaryTextField(
//           controller: emailController,
//           labelText: 'Email Address',
//           hintText: 'your.email@address.com',
//         ),
//         20.0.heightbox,
//         PrimaryTextField(
//           controller: passwordController,
//           labelText: 'Password',
//           hintText: 'Enter your password',
//           obsecure: true,
//         ),
//         20.0.heightbox,
//         PrimaryTextField(
//           controller: confirmPasswordController,
//           labelText: 'Confirm Password',
//           hintText: 'Re-enter your password',
//           obsecure: true,
//         ),
//         20.0.heightbox,
//         PrimaryTextField(
//           controller: firstNameController,
//           labelText: 'First Name',
//           hintText: 'Enter your first name',
//         ),
//         20.0.heightbox,
//         PrimaryTextField(
//           controller: lastNameController,
//           labelText: 'Last Name',
//           hintText: 'Enter your last name',
//         ),
//         20.0.heightbox,
//         PrimaryTextField(
//           controller: ageController,
//           keyboardType: TextInputType.number,
//           labelText: 'Age',
//           hintText: 'Enter your age',
//         ),
//         20.0.heightbox,
//         Text(
//           'Gender',
//           style: TextStyle(
//               color: ktextColor, fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         Row(
//           children: [
//             GenderSelectionButton(
//               gender: 'Male',
//               isSelected: authState.selectedGender == 'Male',
//               onSelected: () => authNotifier.selectGender('Male'),
//             ),
//             // 20.0.widthbox,
//             // GenderSelectionButton(
//             //   gender: 'Female',
//             //   isSelected: authState.selectedGender == 'Female',
//             //   onSelected: () => authNotifier.selectGender('Female'),
//             // ),
//           ],
//         ),
//         // 20.0.heightbox,
//         // GestureDetector(
//         //   onTap: () {},
//         //   child: Row(
//         //     children: [
//         // Container(
//         //     width: 16,
//         //     height: 16,
//         //     decoration: BoxDecoration(
//         //       color: kPrimaryColor,
//         //       borderRadius: BorderRadius.circular(5),
//         //     ),
//         //     child: Icon(
//         //       Icons.check,
//         //       size: 14,
//         //       color: Colors.white,
//         //     )),
//         // SizedBox(width: 10),
//         // Expanded(
//         //   child: Text(
//         //     'I have read and accept the agreement.',
//         //     style: TextStyle(
//         //       color: ktextColor,
//         //       fontWeight: FontWeight.bold,
//         //       fontSize: 12,
//         //     ),
//         //   ),
//         // ),
//         // ],
//         // ),
//
//         20.0.heightbox,
//         _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : SecondaryButton(
//                 buttonText: "Register",
//                 onPressFunction: _register,
//                 width: 120,
//               ),
//         10.0.heightbox,
//       ],
//     );
//   }
// }

import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Start%20Page/firstloginstartpage.dart';
import 'package:champion_footballer/Views/Start%20Page/mainstartpage.dart';
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
      gender: gender ?? 'Male',
      firstName: firstName,
      lastName: lastName,
    );

    try {
      await ref.read(signupProvider(request).future);

      if (!mounted) return;
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: const Text("Signup successful!"),
        autoCloseDuration: const Duration(seconds: 3),
      );
      context.routeoffall(DashboardScreen2());
      // Optionally, redirect to login or start screen
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(e.toString()),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          labelText: 'Email Address',
          hintText: 'your.email@address.com',
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
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
          labelText: 'Confirm Password',
          hintText: 'Re-enter your password',
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
          labelText: 'First Name',
          hintText: 'Enter your first name',
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: lastNameController,
          labelText: 'Last Name',
          hintText: 'Enter your last name',
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          labelText: 'Age',
          hintText: 'Enter your age',
        ),
        20.0.heightbox,
        Text(
          'Gender',
          style: TextStyle(
              color: ktextColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            GenderSelectionButton(
              gender: 'Male',
              isSelected: authState.selectedGender == 'Male',
              onSelected: () => authNotifier.selectGender('Male'),
            ),
            // 20.0.widthbox,
            // GenderSelectionButton(
            //   gender: 'Female',
            //   isSelected: authState.selectedGender == 'Female',
            //   onSelected: () => authNotifier.selectGender('Female'),
            // ),
          ],
        ),
        // 20.0.heightbox,
        // GestureDetector(
        //   onTap: () {},
        //   child: Row(
        //     children: [
        // Container(
        //     width: 16,
        //     height: 16,
        //     decoration: BoxDecoration(
        //       color: kPrimaryColor,
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Icon(
        //       Icons.check,
        //       size: 14,
        //       color: Colors.white,
        //     )),
        // SizedBox(width: 10),
        // Expanded(
        //   child: Text(
        //     'I have read and accept the agreement.',
        //     style: TextStyle(
        //       color: ktextColor,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 12,
        //     ),
        //   ),
        // ),
        // ],
        // ),

        20.0.heightbox,
        _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SecondaryButton(
          buttonText: "Register",
          onPressFunction: _register,
          width: 120,
        ),
        10.0.heightbox,
      ],
    );
  }
}

