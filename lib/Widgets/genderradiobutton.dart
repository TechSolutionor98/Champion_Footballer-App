import 'package:champion_footballer/Utils/appextensions.dart';

import '../Utils/packages.dart';

class GenderSelectionButton extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onSelected;

  const GenderSelectionButton({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ktextColor.withValues(alpha: .4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF57C00),
                        ),
                      ),
                    )
                  : null,
            ),
            10.0.widthbox,
            Text(
              gender,
              style: TextStyle(
                color: ktextColor, // Changed from Colors.white
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
