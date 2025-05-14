import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../../Utils/packages.dart';

class TeamPreviewScreen extends StatefulWidget {
  const TeamPreviewScreen({super.key});

  @override
  TeamPreviewScreenState createState() => TeamPreviewScreenState();
}

class TeamPreviewScreenState extends State<TeamPreviewScreen> {
  bool isHomeTeam = true; // Toggle between Home and Away teams
  final String shirtImage = AppImages.shirt; // Shirt asset path

  // Home Team Data (4-3-3 Formation)
  final List<Map<String, dynamic>> homePlayers = [
    {"name": "Xavi", "number": "01", "position": "GK"},
    {"name": "John", "number": "03", "position": "DF"},
    {"name": "Didi", "number": "02", "position": "DF"},
    {"name": "Vava", "number": "05", "position": "MD"},
    {"name": "Pele", "number": "04", "position": "MD", "isCaptain": true},
    {"name": "Kaka", "number": "06", "position": "MD"},
    {"name": "Gerd", "number": "09", "position": "FW"},
    {"name": "Eric", "number": "07", "position": "FW"},
    {"name": "Dean", "number": "08", "position": "FW"},
    {"name": "Sad", "number": "10", "position": "FW"},
    {"name": "Viv", "number": "12", "position": "FW"},
    {"name": "Mia", "number": "11", "position": "FW"},
  ];

  // Away Team Data
  final List<Map<String, dynamic>> awayPlayers = [
    {"name": "Casillas", "number": "01", "position": "GK"},
    {"name": "Ramos", "number": "03", "position": "DF"},
    {"name": "Puyol", "number": "02", "position": "DF"},
    {"name": "Modric", "number": "05", "position": "MD"},
    {"name": "Zidane", "number": "04", "position": "MD", "isCaptain": true},
    {"name": "Ronaldinho", "number": "06", "position": "MD"},
    {"name": "Henry", "number": "09", "position": "FW"},
    {"name": "Rooney", "number": "07", "position": "FW"},
    {"name": "Ronaldo", "number": "08", "position": "FW"},
    {"name": "Beckham", "number": "10", "position": "FW"},
    {"name": "Messi", "number": "12", "position": "FW"},
    {"name": "Neymar", "number": "11", "position": "FW"},
  ];

  void _shareTeam() {
    Share.share('Check out the team lineup for today’s match!');
  }

  @override
  Widget build(BuildContext context) {
    final teamTitle = isHomeTeam ? "Home" : "Away";
    final teamPlayers = isHomeTeam ? homePlayers : awayPlayers;

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: '$teamTitle Team',
        action: IconButton(
          icon: Icon(Icons.share),
          onPressed: _shareTeam,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.0.heightbox,

            // **Formation View**
            StyledContainer(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(15),
              borderColor: kPrimaryColor.withValues(alpha: .5),
              boxShadow: [],
              child: Column(
                children: [
                  Text(
                    "$teamTitle Team Formation",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  10.0.heightbox,

                  // **Formation UI**
                  SizedBox(
                    height: 500,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.previewback),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFormationRow([teamPlayers[0]], "GK"),
                          _buildFormationRow(
                              [teamPlayers[1], teamPlayers[2]], "DF"),
                          _buildFormationRow(
                              [teamPlayers[3], teamPlayers[4], teamPlayers[5]],
                              "MD"),
                          _buildFormationRow(
                              [teamPlayers[6], teamPlayers[7], teamPlayers[8]],
                              "FW"),
                          _buildFormationRow([
                            teamPlayers[9],
                            teamPlayers[10],
                            teamPlayers[11]
                          ], "FW"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // **Navigation Bar with Arrows and Text**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left Arrow (Disable if already on Home)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: ktextColor,
                  ),
                  onPressed: isHomeTeam
                      ? null
                      : () {
                          setState(() {
                            isHomeTeam = true;
                          });
                        },
                ),

                // **Home / Away Text in the Center**
                Text(
                  isHomeTeam ? "Home" : "Away",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ktextColor,
                  ),
                ),

                // Right Arrow (Disable if already on Away)
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: ktextColor,
                  ),
                  onPressed: isHomeTeam
                      ? () {
                          setState(() {
                            isHomeTeam = false;
                          });
                        }
                      : null,
                ),
              ],
            ),
            10.0.heightbox,
            Text(
              "Match Predictions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            10.0.heightbox,
            // **Match Predictions**
            Padding(
              padding: defaultPadding(),
              child: StyledContainer(
                width: context.width,
                padding: defaultPadding(vertical: 10),
                borderColor: kPrimaryColor.withValues(alpha: .5),
                boxShadow: [],
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(
                        text: "Match 1\n",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      TextSpan(
                        text: "Team matchup is ",
                        style: TextStyle(color: ktextColor),
                      ),
                      TextSpan(
                        text: "100%\n",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      TextSpan(
                        text: "Al Hilal SFC ",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      TextSpan(
                        text: "is predicted to win.\n",
                        style: TextStyle(color: ktextColor),
                      ),
                      TextSpan(
                        text: "Predicted score is ",
                        style: TextStyle(color: ktextColor),
                      ),
                      TextSpan(
                        text: "1-2",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            40.0.heightbox
          ],
        ),
      ),
    );
  }

  Widget _buildFormationRow(List<Map<String, dynamic>> players, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: players.map((player) {
        return _buildPlayerShirt(
            player["name"], player["number"], player["isCaptain"] == true);
      }).toList(),
    );
  }

  Widget _buildPlayerShirt(String name, String number, bool isCaptain) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              shirtImage,
              width: 40, // Adjust size as needed
              height: 40,
              fit: BoxFit.contain,
              color: kPrimaryColor.withValues(alpha: .8),
            ),
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        if (isCaptain)
          Text(
            "C",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
      ],
    );
  }
}
