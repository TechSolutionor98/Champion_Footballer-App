import 'package:champion_footballer/Utils/appcolors.dart';
import 'package:flutter/material.dart';

class LeagueOptionTile extends StatelessWidget {
  final String leagueName;
  //subtitle
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double? borderRadius;

  const LeagueOptionTile({
    super.key,
    required this.leagueName,
    this.subtitle,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: backgroundColor ?? kPrimaryColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 6),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  leagueName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor ?? kdefwhiteColor,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? kdefwhiteColor,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.check_circle_outline,
              color: iconColor ?? Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
