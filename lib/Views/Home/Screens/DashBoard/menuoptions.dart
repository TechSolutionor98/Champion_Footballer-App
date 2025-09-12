import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Dream%20Team/dreamteam.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        'image': AppImages.opt1,
        'text': 'Profile',
        'screen': PlayerProfileScreen()
      },
      {
        'image': AppImages.opt4,
        'text': 'Players',
        'screen': PlayerListScreen()
      },
      {'image': AppImages.opt2, 'text': 'Leagues', 'screen': LeaguesScreen()},
      {'image': AppImages.opt3, 'text': 'Matches', 'screen': MatchesScreen()},
      {'image': AppImages.opt5, 'text': 'Awards', 'screen': TrophyRoomScreen()},
      {
        'image': AppImages.opt6,
        'text': 'Leaderboard',
        'screen': LeaderBoardScreen()
      },
      {
        'image': AppImages.opt7,
        'text': 'Dream Team',
        'screen': DreamTeamScreen()
      },
      {'image': AppImages.opt8, 'text': 'Settings', 'screen': LeagueSettings()},
    ];

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Dashboard",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: Padding(
        padding: defaultPadding(vertical: 15),
        child: Column(
          children: [
            for (int i = 0; i < data.length; i += 2)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => data[i]['screen'],
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(0, 208, 159, 0.502),
                                width: 3,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: defaultBoxShadow),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                data[i]['image']!,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              12.0.heightbox,
                              Text(
                                data[i]['text']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: ktextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => data[i + 1]['screen'],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(0, 208, 159, 0.502),
                                  width: 3),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: defaultBoxShadow),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                data[i + 1]['image']!,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              12.0.heightbox,
                              Text(
                                data[i + 1]['text']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: ktextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
