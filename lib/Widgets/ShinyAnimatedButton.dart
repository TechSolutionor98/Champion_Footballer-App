import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShinyAnimatedButton extends StatefulWidget {
  const ShinyAnimatedButton({
    super.key,
    required this.buttonText,
    this.onPressFunction,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
    this.svgIconData,
    this.borderThickness,
  });

  final String buttonText;
  final VoidCallback? onPressFunction;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;
  final String? svgIconData;

  /// Thickness of the gradient border
  final double? borderThickness;

  static const String _defaultSvgIconData = '''
  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M8 21h8" />
    <path d="M12 17v4" />
    <path d="M7 4h10l1 5-6 2-6-2 1-5Z" />
    <path d="M4 9c.6 2.1 2.5 3 4 3" />
    <path d="M20 9c-.6 2.1-2.5 3-4 3" />
  </svg>
  ''';

  @override
  State<ShinyAnimatedButton> createState() => _ShinyAnimatedButtonState();
}

class _ShinyAnimatedButtonState extends State<ShinyAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineAnimationController;
  bool _isPressed = false;

  static const _defaultFontSize = 14.0;
  static const _defaultFontWeight = FontWeight.w700;
  static const _defaultLetterSpacing = 0.4;
  static const _iconTextGap = 10.0;
  static const _verticalPadding = 10.0;
  static const _defaultBorderRadius = 6.0;

  // Inner background gradient (same as site background)
  static const _defaultGradient = LinearGradient(
    colors: [Color(0xFF004E5F), Color(0xFF007A95)],
    begin: Alignment(-0.707, -0.707),
    end: Alignment(0.707, 0.707),
  );
  static const _pressedGradient = LinearGradient(
    colors: [Color(0xFF005D72), Color(0xFF0092B1)],
    begin: Alignment(-0.707, -0.707),
    end: Alignment(0.707, 0.707),
  );

  // Glow
  static const _defaultBoxShadow = BoxShadow(
    color: Color.fromRGBO(0, 78, 95, 0.55),
    blurRadius: 24,
    spreadRadius: -6,
    offset: Offset(0, 8),
  );
  static const _pressedBoxShadow = BoxShadow(
    color: Color.fromRGBO(0, 120, 150, 0.6),
    blurRadius: 28,
    spreadRadius: -6,
    offset: Offset(0, 10),
  );

  // Shine stripe
  static const _shineGradient = LinearGradient(
    colors: [
      Color.fromRGBO(255, 255, 255, 0),
      Color.fromRGBO(255, 255, 255, 0.5),
      Color.fromRGBO(255, 255, 255, 0)
    ],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Website-style gradient border colors (#30e8ff → #72ffa8 → #30e8ff)
  static const _borderGradient = LinearGradient(
    colors: [Color(0xFF30E8FF), Color(0xFF72FFA8), Color(0xFF30E8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _shineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
  }

  @override
  void dispose() {
    _shineAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double buttonRadius = widget.borderRadius ?? _defaultBorderRadius;
    final double borderThickness = widget.borderThickness ?? 2.0;
    final String currentSvgData =
        widget.svgIconData ?? ShinyAnimatedButton._defaultSvgIconData;

    // Outer container draws the colorful gradient border
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: _borderGradient,
        borderRadius: BorderRadius.circular(buttonRadius),
        boxShadow: [_isPressed ? _pressedBoxShadow : _defaultBoxShadow],
      ),
      padding: EdgeInsets.all(borderThickness), // actual border width
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(buttonRadius - borderThickness),
        child: InkWell(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressFunction?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          borderRadius: BorderRadius.circular(buttonRadius - borderThickness),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Ink(
            decoration: BoxDecoration(
              gradient: _isPressed ? _pressedGradient : _defaultGradient,
              borderRadius:
              BorderRadius.circular(buttonRadius - borderThickness),
            ),
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(buttonRadius - borderThickness),
              child: AnimatedBuilder(
                animation: _shineAnimationController,
                builder: (context, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (!constraints.hasBoundedWidth) {
                        return const SizedBox.shrink();
                      }

                      // moving shine stripe
                      double animationProgress = _shineAnimationController.value;
                      const double startPercent = -0.4;
                      const double endPercent = 1.4;
                      const double animationActiveDuration = 0.7;

                      double currentLeftPercent;
                      if (animationProgress < animationActiveDuration) {
                        double travelProgress =
                            animationProgress / animationActiveDuration;
                        currentLeftPercent = startPercent +
                            (endPercent - startPercent) * travelProgress;
                      } else {
                        currentLeftPercent = endPercent;
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: currentLeftPercent * constraints.maxWidth,
                            width: constraints.maxWidth * 0.4,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.skewX(-18 * math.pi / 180),
                              child: Container(
                                decoration:
                                const BoxDecoration(gradient: _shineGradient),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: _verticalPadding,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  currentSvgData,
                                  width: 22,
                                  height: 22,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                                const SizedBox(width: _iconTextGap),
                                Text(
                                  widget.buttonText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    widget.fontSize ?? _defaultFontSize,
                                    fontWeight: _defaultFontWeight,
                                    letterSpacing: _defaultLetterSpacing,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
