import 'package:champion_footballer/Utils/appextensions.dart';
import '../../../../../../Utils/packages.dart';

class LeagueSettings extends StatefulWidget {
  const LeagueSettings({super.key});

  @override
  LeagueSettingsState createState() => LeagueSettingsState();
}

class LeagueSettingsState extends State<LeagueSettings> {
  String selectedAdmin = "Hassan";
  String leagueName = "Never Give Up 007";
  String selectedStatus = "Active";
  int selectedMatches = 3;
  bool isAdvanceScoringEnabled = false;

  List<Map<String, dynamic>> leaguePlayers = [
    {"name": "Bilal Shahid", "isAdmin": false},
    {"name": "Hassaan (Hassaan Tufail)", "isAdmin": true},
    {"name": "Moh Bilal (Muhammad Bilal)", "isAdmin": false},
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Setting",
      ),
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // League Title
            Center(
              child: Text("Manage League Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),

            10.0.heightbox,
            Container(
              height: 2,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppImages.trophy,
                    width: 18, height: 18, color: ktextColor),
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
            20.0.heightbox,

            // Select League Admin
            Text("Select league admin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            05.0.heightbox,
            StyledContainer(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: .5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedAdmin,
                  isExpanded: true,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedAdmin = newValue!;
                    });
                  },
                  items: ["Hassan", "Bilal", "Moh Bilal"].map((admin) {
                    return DropdownMenuItem(
                      value: admin,
                      child: Text(
                        admin,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            15.0.heightbox,

            PrimaryTextField(
              hintText: "League name",
              labelText: "League Name",
              bordercolor: kPrimaryColor.withValues(alpha: .5),
            ),
            15.0.heightbox,

            // Change League Active Status
            Text("Change league active status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            05.0.heightbox,
            StyledContainer(
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: .5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStatus = "Active";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
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
                            child: selectedStatus == "Active"
                                ? Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          10.0.widthbox,
                          Text(
                            "Active",
                            style: TextStyle(
                              color: ktextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStatus = "Inactive";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
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
                            child: selectedStatus == "Inactive"
                                ? Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          10.0.widthbox,
                          Text(
                            "Inactive",
                            style: TextStyle(
                              color: ktextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            15.0.heightbox,

            // Maximum Number of Matches
            Text("Maximum number of matches",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            05.0.heightbox,
            StyledContainer(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: .5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedMatches,
                  isExpanded: true,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMatches = newValue!;
                    });
                  },
                  items: [3, 5, 10].map((matchCount) {
                    return DropdownMenuItem(
                      value: matchCount,
                      child: Text(
                        matchCount.toString(),
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            15.0.heightbox,
// CF Advance Point Scoring Toggle
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAdvanceScoringEnabled = !isAdvanceScoringEnabled;
                    });
                  },
                  child: Container(
                    width: 45,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [Color(0xFF00D09F), Color(0xFF00785C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedAlign(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: isAdvanceScoringEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isAdvanceScoringEnabled
                                ? kdefwhiteColor
                                : Color(0xFFFFFACD),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .3),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                10.0.widthbox,
                Text(
                  "CF Advance Point Scoring",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            30.0.heightbox,
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    fontSize: 14,
                    buttonText: "Update League",
                    onPressFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                40.0.widthbox,
                Expanded(
                  child: SecondaryButton(
                    buttonColor: kredColor,
                    fontSize: 14,
                    buttonText: "Leave League",
                    onPressFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            20.0.heightbox,

            // League Players Section
            Text("League Players",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            StyledContainer(
              padding: EdgeInsets.all(10),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: .5),
              child: Column(
                children: [
                  ...leaguePlayers.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final player = entry.value;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                player["name"],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: player["isAdmin"]
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (player["isAdmin"])
                              Text(
                                "League Admin",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            if (!player["isAdmin"])
                              Image.asset(
                                "assets/icons/delete.png",
                                width: 18,
                                height: 18,
                              ),
                          ],
                        ),
                        if (index != leaguePlayers.length - 1)
                          Divider(
                            color: Colors.grey.shade200,
                            thickness: 2,
                            height: 20,
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            20.0.heightbox,
            Text(
              "Delete this league",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            10.0.heightbox,

            PrimaryButton(
              width: 130,
              height: 30,
              fontSize: 14,
              onPressFunction: () {},
              buttonText: "Delete League",
              buttonColor: kredColor,
            ),
            30.0.heightbox,
          ],
        ),
      ),
    );
  }
}
