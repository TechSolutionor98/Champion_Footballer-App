import 'package:champion_footballer/Utils/appextensions.dart';

import '../../../../../../../Utils/packages.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final String position;
  final int goals;
  final int points;
  final String image;

  // Optional Styling Properties with Defaults
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
    required this.goals,
    required this.points,
    required this.image,
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Player Info Container
        StyledContainer(
          width: context.width,
          padding: defaultPadding(vertical: 20),
          gradient: LinearGradient(
              colors: [Color(0xFF00D09F), Color(0xFF00785C)],
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
              _infoRow("Goals Scored:", goals.toString()),
              8.0.heightbox,
              _infoRow("League Points:", points.toString()),
            ],
          ),
        ),

        // Player Image Overflowing
        Positioned(
          right: imageRightOffset,
          bottom: imageBottomOffset,
          child: Image.asset(
            image,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  // Helper function to create info rows
  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label   ",
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
