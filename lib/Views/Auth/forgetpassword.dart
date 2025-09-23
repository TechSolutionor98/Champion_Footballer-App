// import 'package:champion_footballer/Utils/appextensions.dart';
// import 'package:champion_footballer/Utils/packages.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldCustom(
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               Image.asset(AppImages.logo, width: context.width * .5),
//               50.0.heightbox,

//               // Form Card
//               Container(
//                 padding: defaultPadding(vertical: 10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: kPrimaryColor,
//                       width: 2,
//                     )),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Forgot Password',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     10.0.heightbox,
//                     const Text(
//                       "Provide your account’s email for which you want to reset your password",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: ktextColor, fontSize: 12),
//                     ),
//                     15.0.heightbox,
//                     PrimaryTextField(
//                       hintText: "youremail@gmail.com",
//                       labelText: "Email",
//                     ),
//                     20.0.heightbox,
//                     PrimaryButton(
//                         buttonText: "Send Reset Link", onPressFunction: () {}),
//                     20.0.heightbox,
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         'Back to Login',
//                         style: TextStyle(
//                           color: kPrimaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart';

import 'package:toastification/toastification.dart';


import '../../Model/Api Models/resetpass_model.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  ResetPasswordRequest? _lastRequest;

  void _submit() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: const Text("Email is required"),
      );
      return;
    }

    final request = ResetPasswordRequest(email: email);
    setState(() => _lastRequest = request);

    try {
      await ref.read(resetPasswordProvider(request).future);
      if (!mounted) return;

      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: const Text("Reset email sent successfully"),
      );

      context.routeoffall(const AuthScreen());
    } catch (error) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(error.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _lastRequest != null
        ? ref.watch(resetPasswordProvider(_lastRequest!)).isLoading
        : false;

    return ScaffoldCustom(
      backgroundImageAsset: AppImages.authBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image.asset(AppImages.logo, width: context.width * .5),
              50.0.heightbox,
              Container(
                padding: defaultPadding(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Forgot Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    10.0.heightbox,
                    const Text(
                      "Provide your account’s email for which you want to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ktextColor, fontSize: 12),
                    ),
                    15.0.heightbox,
                    PrimaryTextField(
                      hintText: "Email address",
                      height: 50,
                      controller: emailController,
                    ),
                    20.0.heightbox,
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            buttonText: "Send Reset Link",
                            height: 50,
                            onPressFunction: _submit,
                          ),
                    20.0.heightbox,
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
