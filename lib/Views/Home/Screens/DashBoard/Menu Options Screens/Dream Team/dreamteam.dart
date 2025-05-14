import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

class DreamTeamScreen extends StatelessWidget {
  DreamTeamScreen({super.key});
  final List<Map<String, String>> playersLeft = [
    {"name": "M. Waqar", "position": "GK"},
    {"name": "Bilal", "position": "DF"},
    {"name": "Naeem", "position": "DF"},
  ];

  final List<Map<String, String>> playersRight = [
    {"name": "Arsalan", "position": "MD"},
    {"name": "Hassaan", "position": "MD"},
    {"name": "Abrar", "position": "ST"},
  ];
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
        appBar: CustomAppBar(titleText: "Dream Team"),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.trophy,
                    width: 18,
                    height: 18,
                    color: ktextColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Never Give up (NGU)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ktextColor,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Choose League",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1),
                                    10.0.heightbox,
                                    LeagueOptionTile(
                                      leagueName: "Premier League",
                                    ),
                                    LeagueOptionTile(
                                      leagueName: "La Liga",
                                    ),
                                    LeagueOptionTile(
                                      leagueName: "Bundesliga",
                                    ),
                                    LeagueOptionTile(
                                      leagueName: "Serie A",
                                    ),
                                    LeagueOptionTile(
                                      leagueName: "Ligue 1",
                                    ),
                                    10.0.heightbox,
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              " Change",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: kPrimaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              15.0.heightbox,
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/dreamback.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      ..._buildPlayerPositions(), // Adding Players on Field
                    ],
                  ),
                ),
              ),
              10.0.heightbox,
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Player Stats",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      8.0.heightbox,
                      StyledContainer(
                        padding: EdgeInsets.all(12),
                        borderColor: kPrimaryColor.withValues(alpha: .5),
                        boxShadow: [],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPlayerColumn(playersLeft),
                            _buildPlayerColumn(playersRight),
                          ],
                        ),
                      ),
                    ],
                  ))
            ])));
  }

  Widget _buildPlayerColumn(List<Map<String, String>> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: players.map((player) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Image.asset(
                AppImages.shirt,
                width: 18,
                height: 18,
              ),
              10.0.widthbox,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: player["name"]!,
                      style: TextStyle(
                        color: ktextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: player["position"] == "GK"
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: kdefblackColor,
                      ),
                    ),
                    TextSpan(
                        text: " (${player["position"]})",
                        style: TextStyle(
                          color: ktextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildPlayerPositions() {
    List<Map<String, dynamic>> players = [
      {"name": "Arsalan", "left": 90.0, "top": 190.0},
      {"name": "Hassan", "left": 70.0, "top": 280.0},
      {"name": "Abrar", "left": 130.0, "top": 240.0},
      {"name": "M. Waqas", "left": 210.0, "top": 220.0},
      {"name": "Naeem", "left": 250.0, "top": 280.0},
      {"name": "Bilal", "left": 170.0, "top": 340.0},
    ];

    return players.map((player) {
      return Positioned(
        left: player["left"],
        top: player["top"],
        child: Column(
          children: [
            Text(
              player["name"],
              style: TextStyle(
                color: kdefwhiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),

            // 4.0.heightbox,
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AppImages.shirt,
                  width: 40,
                  height: 40,
                ),
                Text(
                  "09",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
