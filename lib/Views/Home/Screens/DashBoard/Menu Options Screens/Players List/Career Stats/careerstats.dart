import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

import 'careerstatschart.dart'; 

// Test Screen definition (can be removed or commented out if not used)
// class MyTestScreen extends StatelessWidget {
//   const MyTestScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Test Screen")),
//       body: const Center(
//         child: Text(
//           "This is a test screen. If you see this, navigation worked!",
//           style: TextStyle(fontSize: 20),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

class PlayerStatsScreen extends StatefulWidget {
  const PlayerStatsScreen({super.key});

  @override
  State<PlayerStatsScreen> createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen> {
  String selectedYear = "All Years";
  String selectedLeague = "League12";
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Career Stats",
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
        padding: defaultPadding(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                dropdownButton(
                    "All Years", ["All Years", "2023", "2022"], selectedYear,
                    (newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                }),
                dropdownButton("League12", ["League12", "League11", "League10"],
                    selectedLeague, (newValue) {
                  setState(() {
                    selectedLeague = newValue!;
                  });
                }),
              ],
            ),
            10.0.heightbox,

            Padding(
              padding: defaultPadding(),
              child: PrimaryTextField(
                hintText: "Search Players",
                bordercolor: kPrimaryColor.withValues(alpha: .5),
              ),
            ),
            20.0.heightbox,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Khurram",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ktextColor,
                      ),
                    ),
                    Text(
                      "86",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ktextColor,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  AppImages.user,
                  color: kPrimaryColor,
                  width: 80,
                  height: 80,
                ),
                Column(
                  children: [
                    Text(
                      "Midfielder",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ktextColor,
                      ),
                    ),
                    Image.asset(
                      "assets/icons/stat.png",
                      color: ktextColor,
                      width: 20,
                      height: 20,
                    ),
                    5.0.heightbox,
                    SecondaryButton(
                      buttonText: "View Chart",
                      width: 65,
                      height: 18,
                      fontSize: 10,
                      borderRadius: 3,
                      onPressFunction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PerformanceDashboard()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            20.0.heightbox,


            StyledContainer(
              width: context.width,
              padding: defaultPadding(vertical: 10, horizontal: 5),
              borderColor: kPrimaryColor.withValues(alpha: .5),
              boxShadow: [],
              child: Column(
                children: [
                  Text(
                    "Current League Stats",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  10.0.heightbox,
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: [
                      for (var item in [
                        ["34", "Goals"],
                        ["15", "Assist"],
                        ["2", "Clean\nSheet"],
                        ["8", "MOTM\nVotes"],
                        ["50", "Best\nWin"],
                        ["50", "xWin\n%"]
                      ])
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(AppImages.football,
                                    width: 40, height: 40),
                                Text(
                                  item[0],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: kdefwhiteColor,
                                  ),
                                ),
                              ],
                            ),
                            5.0.heightbox,
                            Text(
                              item[1],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: kdefblackColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            20.0.heightbox,

            StyledContainer(
              width: context.width,
              padding: defaultPadding(vertical: 10, horizontal: 5),
              borderColor: kPrimaryColor.withValues(alpha: .5),
              boxShadow: [],
              child: Column(
                children: [
                  Text(
                    "Accumulative Stats",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  10.0.heightbox,
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: [
                      for (var item in [
                        ["34", "Goals"],
                        ["15", "Assist"],
                        ["2", "Clean\nSheet"],
                        ["8", "MOTM\nVotes"],
                        ["50", "Best\nWin"],
                        ["50", "Total\nWins"]
                      ])
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(AppImages.football,
                                    width: 40, height: 40),
                                Text(
                                  item[0],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: kdefwhiteColor,
                                  ),
                                ),
                              ],
                            ),
                            5.0.heightbox,
                            Text(
                              item[1],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: kdefblackColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  15.0.heightbox,
                  Text(
                    "Accumulative Trophies",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  10.0.heightbox,
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.emoji_events, size: 40, color: kblueColor),
                          5.0.heightbox,
                          Text(
                            "Titles",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ktextColor,
                            ),
                          ),
                          10.0.heightbox,
                          SecondaryButton(
                            buttonText: "4",
                            width: 40,
                            height: 18,
                            fontSize: 12,
                            borderRadius: 5,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            "assets/icons/medal.png",
                            width: 40,
                            height: 40,
                          ),
                          5.0.heightbox,
                          Text(
                            "Runner Up",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ktextColor,
                            ),
                          ),
                          10.0.heightbox,
                          SecondaryButton(
                            buttonText: "2",
                            width: 40,
                            height: 18,
                            fontSize: 12,
                            borderRadius: 5,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            "assets/icons/ball.png",
                            width: 40,
                            height: 40,
                          ),
                          5.0.heightbox,
                          Text(
                            "Ballon d’Or",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ktextColor,
                            ),
                          ),
                          10.0.heightbox,
                          SecondaryButton(
                            buttonText: "1",
                            width: 40,
                            height: 18,
                            fontSize: 12,
                            borderRadius: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropdownButton(String text, List<String> items, String selectedValue,
      Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kdefwhiteColor,
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: kPrimaryColor.withValues(alpha: .5), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: selectedValue,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ktextColor,
                ),
              ),
            );
          }).toList(),
          icon: Icon(
            Icons.arrow_drop_down,
            color: kPrimaryColor,
            size: 27,
          ),
        ),
      ),
    );
  }
}
