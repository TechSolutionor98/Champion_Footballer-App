import '../Utils/packages.dart';

class SecondaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obsecure;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final Color? backgroundColor;
  final Color? bordercolor;
  final BorderRadius? radius;
  final double? hintfontSize;
  final bool enabledfield;

  const SecondaryTextField({
    super.key,
    this.controller,
    this.obsecure = false,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.focusNode,
    this.onChanged,
    this.backgroundColor,
    this.bordercolor,
    this.radius,
    this.hintfontSize,
    this.enabledfield = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withValues(alpha: 0.15),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
          border: Border.all(color: bordercolor ?? Colors.transparent),
          color: backgroundColor ?? kdefwhiteColor,
          borderRadius: radius ?? defaultBorderRadious),
      child: TextFormField(
        enabled: enabledfield,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w500, color: ktextColor),
        // textAlign: TextAlign.center,
        focusNode: focusNode,
        onChanged: onChanged,
        obscureText: obsecure,
        cursorColor: kdefgreyColor,
        cursorHeight: 20,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffix: suffix,
          hintText: hintText,
          hintStyle: TextStyle(
              color: ksecondaryGreyColor,
              fontSize: hintfontSize ?? 22,
              fontWeight: FontWeight.w500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        validator: validator,
      ),
    );
  }
}

// class EmailValidatorProvider with ChangeNotifier {
//   bool _isEmailValid = false;

//   bool get isEmailValid => _isEmailValid;

//   void validateEmail(String value) {
//     final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
//     if (isValid != _isEmailValid) {
//       _isEmailValid = isValid;
//       notifyListeners();
//     }
//   }
// }
