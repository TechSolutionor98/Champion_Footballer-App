import 'package:champion_footballer/Utils/appextensions.dart';
import '../../../../Utils/packages.dart';

class AddStatsScreen extends StatefulWidget {
  const AddStatsScreen({super.key});

  @override
  State<AddStatsScreen> createState() => _AddStatsScreenState();
}

class _AddStatsScreenState extends State<AddStatsScreen> {
  int goals = 0;
  int assists = 0;
  int cleanSheets = 0;

  void _increment(String stat) {
    setState(() {
      if (stat == "Goals") goals++;
      if (stat == "Assists") assists++;
      if (stat == "Clean Sheets") cleanSheets++;
    });
  }

  void _decrement(String stat) {
    setState(() {
      if (stat == "Goals" && goals > 0) goals--;
      if (stat == "Assists" && assists > 0) assists--;
      if (stat == "Clean Sheets" && cleanSheets > 0) cleanSheets--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Add Stats",
      ),
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            10.0.heightbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    fontSize: 16,
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
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
                                      fontSize: 16,
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
            10.0.heightbox,
            DropdownButton<String>(
              value: "Match 1 (5-7)",
              items: ["Match 1 (5-7)", "Match 2 (4-3)"]
                  .map((match) => DropdownMenuItem(
                        value: match,
                        child: Text(
                          match,
                          style: TextStyle(
                            fontWeight: FontWeight.w600, // Make text bold
                            fontSize: 14, // Reduce text size
                          ),
                          textAlign: TextAlign.center, // Center text
                        ),
                      ))
                  .toList(),
              onChanged: (value) {},
              icon: Icon(
                Icons.arrow_drop_down,
                size: 30,
                color: kPrimaryColor,
              ),
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: ktextColor,
              ),
              underline: Container(
                height: 1.5,
                color: ktextColor,
                margin: EdgeInsets.only(top: 5),
              ),
            ),
            10.0.heightbox,
            StyledContainer(
              boxShadow: [],
              padding: defaultPadding(vertical: 10),
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              child: Column(
                children: [
                  Text("Add Your Stats",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  10.0.heightbox,
                  Container(
                    height: 2,
                    width: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade100,
                          Colors.green.shade400,
                          Colors.green.shade100,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  10.0.heightbox,
                  _buildStatRow("Goals", goals),
                  _buildStatRow("Assists", assists),
                  _buildStatRow("Clean Sheets", cleanSheets),
                ],
              ),
            ),
            20.0.heightbox,
            StyledContainer(
              boxShadow: [],
              width: context.width,
              padding: defaultPadding(),
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              child: Column(
                children: [
                  10.0.heightbox,
                  Text(
                    "Select Man Of The Match",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  10.0.heightbox,
                  Container(
                    height: 2,
                    width: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade100,
                          Colors.green.shade400,
                          Colors.green.shade100,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  10.0.heightbox,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: .95,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> players = [
                        {"name": "Harry Kane", "voted": false},
                        {"name": "Elen Roy", "voted": true},
                        {"name": "Joy Arther", "voted": false},
                        {"name": "Cristiano", "voted": false},
                        {"name": "Messi", "voted": false},
                        {"name": "Neymar", "voted": false},
                      ];

                      return PlayerAvatar(
                        name: players[index]["name"],
                        voted: players[index]["voted"],
                      );
                    },
                  )
                ],
              ),
            ),
            20.0.heightbox,
            StyledContainer(
              width: context.width,
              padding: defaultPadding(vertical: 10),
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              boxShadow: [],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.0.heightbox,
                  Center(
                    child: Text(
                      "Captain's Bonus Pick",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  10.0.heightbox,
                  Center(
                    child: Container(
                      height: 2,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade100,
                            Colors.green.shade400,
                            Colors.green.shade100,
                          ],
                          stops: [0.0, 0.5, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  10.0.heightbox,
                  BonusPickRow(title: "Defensive Impact"),
                  BonusPickRow(title: "Influence"),
                ],
              ),
            ),
            20.0.heightbox,
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String stat, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              stat,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Spacer(),
          Row(
            children: [
              _buildCounterButton(Icons.remove, () => _decrement(stat)),
              10.0.widthbox,
              Text(
                "$value",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              10.0.widthbox,
              _buildCounterButton(Icons.add, () => _increment(stat)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: defaultPadding(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child: Icon(icon, size: 15, color: kdefblackColor),
      ),
    );
  }
}

class PlayerAvatar extends StatelessWidget {
  final String name;
  final bool voted;

  const PlayerAvatar({super.key, required this.name, this.voted = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 25, backgroundColor: kPrimaryColor.withValues(alpha: .6)),
        5.0.heightbox,
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        10.0.heightbox,
        if (voted)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Color(0xFFC43826),
                borderRadius: BorderRadius.circular(5)),
            child: Text("Voted",
                style: TextStyle(
                  color: kdefwhiteColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                )),
          ),
      ],
    );
  }
}

class BonusPickRow extends StatelessWidget {
  final String title;

  const BonusPickRow({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            )),
        Text("Select Player >",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            )),
      ],
    );
  }
}
