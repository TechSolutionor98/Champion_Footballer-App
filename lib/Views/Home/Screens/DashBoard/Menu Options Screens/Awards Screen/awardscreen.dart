import 'package:champion_footballer/Utils/appextensions.dart';
import '../../../../../../Utils/packages.dart';

class TrophyRoomScreen extends StatelessWidget {
  const TrophyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: ScaffoldCustom(
          appBar: CustomAppBar(
            titleText: "Trophy Room",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(229, 106, 22, 1), // orange
                Color.fromRGBO(207, 35, 38, 1),  // red
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kdefwhiteColor,
                child: TabBar(
                  labelPadding: EdgeInsets.symmetric(vertical: 5),
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  labelColor: kdefwhiteColor,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter"),
                  unselectedLabelColor: kPrimaryColor,
                  tabs: [
                    Center(
                      child: Tab(
                        text: 'All Trophies',
                      ),
                    ),
                    Center(
                      child: Tab(
                        text: 'My Achievements',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  // controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      padding: defaultPadding(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.trophy,
                                  width: 20, height: 20, color: ktextColor),
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
                                              borderRadius:
                                                  BorderRadius.vertical(
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


                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: trophies.length,
                            itemBuilder: (context, index) {
                              var trophy = trophies[index];

                              return StyledContainer(
                                // width: 120, // Static width
                                // height: 155, // Static height
                                padding: EdgeInsets.all(6),
                                boxShadow: [],
                                borderWidth: 3,
                                borderColor:
                                    kPrimaryColor.withValues(alpha: .5),
                                child: Column(
                                  children: [
                                    Text(
                                      trophy['title'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: trophy['title'] ==
                                                "Champion Footballer"
                                            ? trophy['tbcColor']
                                            : Color(0xFF0778A1),
                                      ),
                                    ),
                                    SizedBox(height: 3),


                                    Text(
                                      trophy['description'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    5.0.heightbox,

                                    Expanded(
                                      child: Image.asset(
                                        trophy['image'],
                                        height: 50,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    5.0.heightbox,

                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: trophy['tbcColor'],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "TBC",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: kdefwhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      padding: defaultPadding(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.trophy,
                                  width: 20, height: 20, color: ktextColor),
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
                                              borderRadius:
                                                  BorderRadius.vertical(
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


                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return StyledContainer(
                                width: 120, // Static width
                                height: 155, // Static height
                                padding: EdgeInsets.all(6),
                                boxShadow: [],
                                borderWidth: 3,
                                borderColor:
                                    kPrimaryColor.withValues(alpha: .5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Runner-Up",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0778A1),
                                      ),
                                    ),
                                    SizedBox(height: 3),


                                    Text(
                                      "Second Place Player In The League Table",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),


                                    Expanded(
                                      child: Image.asset(
                                        "assets/icons/trophy2.png",
                                        height: 60,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    5.0.heightbox,

                                    GestureDetector(
                                      onTap: () {
                                        context.route(MatchDetailScreen());
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 6),
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Match Detail",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}


List<Map<String, dynamic>> trophies = [
  {
    'title': "Champion Footballer",
    'description': "First Place Player In The League Table",
    'image': 'assets/icons/trophy1.png',
    'tbcColor': Color(0xFFCA8A04),
  },
  {
    'title': "Runner-Up",
    'description': "Second Place Player In The League Table",
    'image': 'assets/icons/trophy2.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Ballon d’Or",
    'description': "Player With The Most MOTM Awards",
    'image': 'assets/icons/trophy3.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "GOAT",
    'description': "Player With The Highest Win Ratio & Total MOTM Votes",
    'image': 'assets/icons/trophy4.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Golden Boot",
    'description': "Player With The Highest Number Of Goals Scored",
    'image': 'assets/icons/trophy5.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "King Playmaker",
    'description': "Player With The Highest Number Of Assists",
    'image': 'assets/icons/trophy6.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Legendary Shield",
    'description':
        "Defender Or Goalkeeper With The Lowest Average Goal Against",
    'image': 'assets/icons/trophy7.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "The Dark Horse",
    'description':
        "Player Outside Of The Top 3 League Positions With The Highest MOTM Votes",
    'image': 'assets/icons/trophy8.png',
    'tbcColor': kPrimaryColor,
  },
];
