import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      // appBar: CustomAppBar(titleText: "Match Detail"),
      appBar: CustomAppBar(
        titleText: "Match Detail",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledContainer(
              padding: defaultPadding(vertical: 10),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: .5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "7",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      10.0.widthbox,
                      Text(
                        "Al-Nassr FC",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Goals Scored: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "Moh Bilal (2)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.0.heightbox,
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Assists: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0778A1),
                              ),
                            ),
                            TextSpan(
                              text: "Moh Bilal (1)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.0.heightbox,
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Clean Sheets: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "Moh Bilal (1)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.0.heightbox,
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Penalties: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "Moh Bilal (2)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.0.heightbox,
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Free Kicks: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "Moh Bilal (1)",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  10.0.heightbox,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "8",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      10.0.widthbox,
                      Text(
                        "Al-Hilal SFC",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  Divider(color: Colors.grey.shade300),
                  5.0.heightbox,
                  // Match Timing & Location
                  Text(
                    "21:30 to 23:10\nThursday, 12 December 2024\nProstar Football Club & Academy",
                    style: TextStyle(
                      fontSize: 12,
                      color: ktextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.0.heightbox,

                  // Match Notes
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Match Notes:\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kredColor),
                        ),
                        TextSpan(
                          text:
                              "Controlled the midfield, providing\ncrucial passes and defensive support.",
                          style: TextStyle(
                            fontSize: 12,
                            color: ktextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.0.heightbox,


            Text(
              "Match Predictions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            10.0.heightbox,

            StyledContainer(
              width: context.width,
              padding: defaultPadding(vertical: 10),
              borderColor: kPrimaryColor.withValues(alpha: .5),
              boxShadow: [],
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: ktextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "Team matchup is ",
                    ),
                    TextSpan(
                      text: "100%.",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                    TextSpan(
                      text: "\nAl Hilal SFC ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                    TextSpan(
                      text: "is predicted to win.\n",
                    ),
                    TextSpan(
                      text: "Predicted score is ",
                    ),
                    TextSpan(
                      text: "1-2.",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
