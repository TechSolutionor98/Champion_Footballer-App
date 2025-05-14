import 'package:champion_footballer/Utils/appextensions.dart';

import '../Utils/packages.dart';

class ButtonWithIcon extends StatelessWidget {
  const ButtonWithIcon({
    super.key,
    required this.buttonText,
    this.onPressFunction,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.leadingWidget,
    this.width,
    this.height,
    this.fontSize,
    this.radius,
    // this.iconColor,
    // this.iconSize,
  });

  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final String buttonText;
  final VoidCallback? onPressFunction;
  final Widget? leadingWidget;
  final double? width;
  final double? height;
  final double? fontSize;
  final BorderRadius? radius;

  // final Color? iconColor; // Optional icon color
  // final double? iconSize; // Optional icon size

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressFunction,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 40,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: .3),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 2),
          //   )
          // ],
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: radius ?? BorderRadius.circular(6),
          color: buttonColor ?? kPrimaryColor,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingWidget != null) ...[
                leadingWidget!,
                8.0.widthbox,
              ],
              Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? kdefwhiteColor,
                  fontSize: fontSize ?? 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
