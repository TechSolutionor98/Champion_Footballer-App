// import '../Utils/packages.dart';

// class PrimaryButton extends StatelessWidget {
//   const PrimaryButton({
//     super.key,
//     required this.buttonText,
//     this.onPressFunction,
//     this.buttonColor,
//     this.textColor,
//     this.borderColor,
//   });

//   final Color? buttonColor;
//   final Color? borderColor;
//   final Color? textColor;
//   final String buttonText;
//   final VoidCallback? onPressFunction;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: defaultPadding(),
//       child: GestureDetector(
//         onTap: onPressFunction,
//         child: Container(
//           width: double.infinity,
//           height: 60,
//           decoration: BoxDecoration(
//             // boxShadow: [
//             //   BoxShadow(
//             //     color: Colors.black.withValues(alpha: .3),
//             //     spreadRadius: 1,
//             //     blurRadius: 3,
//             //     offset: const Offset(0, 2),
//             //   )
//             // ],
//             border: Border.all(color: borderColor ?? Colors.transparent),
//             borderRadius: defaultBorderRadious,
//             color: buttonColor ?? kPrimaryColor,
//           ),
//           child: Center(
//             child: Text(
//               buttonText,
//               style: TextStyle(
//                   color: textColor ?? kdefwhiteColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:champion_footballer/Utils/appextensions.dart';

import '../Utils/packages.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.buttonText,
    this.onPressFunction,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.width,
    this.fontSize,
    this.radius,
  });

  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final String buttonText;
  final VoidCallback? onPressFunction;
  final double? height;
  final double? width;
  final double? fontSize;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressFunction,
      child: Container(
        width: width ?? context.width,
        height: height ?? 40,
        decoration: BoxDecoration(
          // boxShadow: defaultBoxShadow,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: radius ?? defaultBorderRadious,
          color: buttonColor ?? kPrimaryColor,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? kdefwhiteColor,
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
