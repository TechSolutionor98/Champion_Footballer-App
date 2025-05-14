import 'package:champion_footballer/Utils/packages.dart';

class StyledContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const StyledContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.height,
    this.width,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? kdefwhiteColor,
          borderRadius: borderRadius ?? defaultBorderRadious,
          boxShadow: boxShadow ?? defaultBoxShadow,
          gradient: gradient,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 2,
          ),
        ),
        child: child,
      ),
    );
  }
}
