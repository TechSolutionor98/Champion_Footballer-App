import 'package:champion_footballer/Utils/packages.dart';

const Color kPrimaryColor = Color(0xFF00A77F);
const Color kSecondaryColor = Color.fromARGB(255, 247, 247, 247);
const Color ktextColor = Color(0xFF002733);
const Color ktext2Color = Color.fromRGBO(0, 39, 51, 0.8);
const Color ktexfieldborderColor = Color.fromRGBO(0, 39, 51, 0.5);
const Color ktexthintColor = Color(0xFFA7A7A7);
const Color kdefgreyColor = Color(0xFF9E9E9E);
const Color kdefblackColor = Color(0xFF000000);
const Color kdefwhiteColor = Color(0xFFFFFFFF);
const Color kredColor = Color(0xFFDE2626);
const Color kblueColor = Color(0xFF0388E3);
const Color ksecondaryGreyColor = Color(0xFF8C8C8C);

const ColorScheme kColorScheme = ColorScheme(
  primary: kPrimaryColor,
  secondary: kSecondaryColor,
  surface: kdefwhiteColor,
  error: kredColor,
  onPrimary: kdefwhiteColor,
  onSecondary: kdefwhiteColor,
  onSurface: kdefblackColor,
  onError: kdefwhiteColor,
  brightness: Brightness.light,
);

const ColorScheme kDarkColorScheme = ColorScheme(
  primary: kPrimaryColor,
  secondary: kSecondaryColor,
  surface: kdefblackColor,
  error: kredColor,
  onPrimary: kdefwhiteColor,
  onSecondary: kdefwhiteColor,
  onSurface: kdefwhiteColor,
  onError: kdefwhiteColor,
  brightness: Brightness.dark,
);

EdgeInsets defaultPadding({double vertical = 0.0, double horizontal = 15.0}) {
  return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
}

BorderRadius defaultBorderRadious = BorderRadius.circular(6);
const Duration defaultDuration = Duration(milliseconds: 300);
List<BoxShadow> defaultBoxShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: .3),
    spreadRadius: 0,
    blurRadius: 2,
    offset: const Offset(0, 2),
  ),
];

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

// Widget defaultStyledContainer({
//   required Widget child,
//   EdgeInsetsGeometry? margin,
//   EdgeInsetsGeometry? padding,
//   Color? backgroundColor,
//   Color? borderColor,
//   double? height,
//   double? width,
//   double? borderWidth,
//   BorderRadius? borderRadius,
//   List<BoxShadow>? boxShadow,
// }) {
//   return Container(
//     height: height,
//     width: width,
//     margin: margin,
//     padding: padding,
//     decoration: BoxDecoration(
//       color: backgroundColor ?? kdefwhiteColor,
//       borderRadius: borderRadius ?? defaultBorderRadious,
//       boxShadow: boxShadow ?? defaultBoxShadow,
//       border: Border.all(
//         color: borderColor ?? kdefwhiteColor,
//         width: borderWidth ?? 1.5,
//       ),
//     ),
//     child: child,
//   );
// }
