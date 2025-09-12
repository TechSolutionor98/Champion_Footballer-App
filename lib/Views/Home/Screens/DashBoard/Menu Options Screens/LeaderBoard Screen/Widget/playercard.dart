import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../Utils/packages.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final String position;
  final String metricLabel; // New: Label for the metric (e.g., "Goals", "Assists")
  final int metricValue;  // New: Value for the metric
  final String image;
  final bool isNetwork;

  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color textColor;
  final Color gradientStart;
  final Color gradientEnd;
  final double imageWidth;
  final double imageHeight;
  final double imageRightOffset;
  final double imageBottomOffset;

  const PlayerCard({
    super.key,
    required this.name,
    required this.position,
    required this.metricLabel, // New
    required this.metricValue, // New
    required this.image,
    this.isNetwork = false,
    this.fontSize = 14,
    this.fontStyle = FontStyle.italic,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.gradientStart = const Color(0xFF00D09F),
    this.gradientEnd = const Color(0xFF00785C),
    this.imageWidth = 200,
    this.imageHeight = 220,
    this.imageRightOffset = -5,
    this.imageBottomOffset = -15,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (isNetwork) {
      if (image.isEmpty) {
        imageWidget = Icon(Icons.person_off_outlined, color: Colors.grey, size: imageWidth / 2);
      } else {
        imageWidget = Image.network(
          image,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.contain,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Icon(Icons.error_outline, color: Colors.red, size: imageWidth / 2);
          },
        );
      }
    } else {
      imageWidget = Image.asset(
        image,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Icon(Icons.broken_image_outlined, color: Colors.grey, size: imageWidth / 2);
        },
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        StyledContainer(
          width: context.width,
          padding: defaultPadding(vertical: 20),
          gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow("Name:", name),
              8.0.heightbox,
              _infoRow("Position:", position),
              8.0.heightbox,
              _infoRow("${metricLabel}:", metricValue.toString()), // Changed to use dynamic label and value
            ],
          ),
        ),
        Positioned(
          right: imageRightOffset,
          bottom: imageBottomOffset,
          child: imageWidget,
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label + "   ",
          style: TextStyle(
            fontSize: fontSize,
            fontStyle: fontStyle,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
