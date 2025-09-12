import 'package:champion_footballer/Utils/appextensions.dart';

import '../Utils/packages.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.buttonText,
    this.onPressFunction,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
  });

  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final String buttonText;
  final VoidCallback? onPressFunction;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressFunction ?? () => Navigator.pop(context),
      child: Container(
        width: width ?? context.width / 2,
        height: height ?? 35,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius:
              BorderRadius.circular(borderRadius ?? 6),
          color: buttonColor ?? kPrimaryColor,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? kdefwhiteColor,
              fontSize: fontSize ?? 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
