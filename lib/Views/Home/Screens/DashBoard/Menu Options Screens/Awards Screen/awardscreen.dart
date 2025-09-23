import 'package:champion_footballer/Model/Api%20Models/usermodel.dart'; // For WelcomeUser and LeaguesJoined types
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart'; // For userDataProvider
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:flutter_svg/svg.dart';
// Assuming LeagueOptionTile is in a commonly accessible place, e.g., widgets folder
// If not, adjust the import path for LeagueOptionTile accordingly.
// import 'package:champion_footballer/Widgets/league_option_tile.dart';


class TrophyRoomScreen extends ConsumerStatefulWidget {
  const TrophyRoomScreen({super.key});

  @override
  ConsumerState<TrophyRoomScreen> createState() => _TrophyRoomScreenState();
}

class _TrophyRoomScreenState extends ConsumerState<TrophyRoomScreen> {
  LeaguesJoined? _selectedLeagueForAwards; // Changed to LeaguesJoined?

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultLeague();
    });
  }

  void _setDefaultLeague() {
    if (!mounted) return;
    final user = ref.read(userDataProvider).asData?.value;
    // user.leagues is List<LeaguesJoined>?
    if (_selectedLeagueForAwards == null && user != null && (user.leagues?.isNotEmpty ?? false)) {
      setState(() {
        _selectedLeagueForAwards = user.leagues!.first;
      });
    }
  }

  Future<void> _showChooseLeagueSheet() async {
    final selected = await showModalBottomSheet<LeaguesJoined>( // Changed to LeaguesJoined
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return Consumer(builder: (context, ref, child) {
          final userAsync = ref.watch(userDataProvider);
          return userAsync.when(
            data: (user) {
              final leagues = user.leagues ?? []; // leagues is List<LeaguesJoined>
              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(sheetContext).size.height * 0.6,
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
                      Divider(color: Colors.grey.shade300, thickness: 1),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          itemCount: leagues.length,
                          separatorBuilder: (_, __) => const SizedBox.shrink(),
                          itemBuilder: (context, index) {
                            final league = leagues[index]; // league is LeaguesJoined
                            return LeagueOptionTile(
                              leagueName: league.name ?? "League",
                              subtitle: '${league.matches?.length ?? 0} matches, ${league.members?.length ?? 0} players',
                              onTap: () {
                                Navigator.pop(sheetContext, league); // league is LeaguesJoined
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error loading leagues: $e'),
            ),
          );
        });
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedLeagueForAwards = selected; // selected is LeaguesJoined, this is now type-correct
      });
    }
  }


  @override
  Widget build(BuildContext context) {
     final user = ref.watch(userDataProvider).asData?.value;
     if (_selectedLeagueForAwards == null && user != null && (user.leagues?.isNotEmpty ?? false)) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted && _selectedLeagueForAwards == null) {
            setState(() {
              _selectedLeagueForAwards = user.leagues!.first;
            });
         }
       });
     }

    return DefaultTabController(
        length: 2,
        child: ScaffoldCustom(
          appBar: CustomAppBar(
            titleText: "Trophy Room",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(229, 106, 22, 1),
                Color.fromRGBO(207, 35, 38, 1),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kdefwhiteColor,
                child: TabBar(
                  labelPadding: const EdgeInsets.symmetric(vertical: 5),
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: kPrimaryColor,
                    boxShadow: const [
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
                  tabs: const [
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
                  children: [
                    // "All Trophies" Tab
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
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedLeagueForAwards?.name?.toUpperCase() ?? "SELECT LEAGUE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ktextColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: _showChooseLeagueSheet,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        " Change",
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: trophies.length,
                            itemBuilder: (context, index) {
                              var trophy = trophies[index];
                              return StyledContainer(
                                padding: const EdgeInsets.all(6),
                                boxShadow: const [],
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
                                            : const Color(0xFF0778A1),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
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
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Image.asset(
                                        trophy['image'],
                                        height: 50,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
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
                    // "My Achievements" Tab
                    SingleChildScrollView(
                      padding: defaultPadding(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // League selection Row and SizedBox REMOVED from here
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return StyledContainer(
                                padding: const EdgeInsets.all(6),
                                boxShadow: const [],
                                borderWidth: 3,
                                borderColor:
                                    kPrimaryColor.withValues(alpha: .5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
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
                                     Text(
                                      "Second Place Player",
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
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "View Details",
                                        style: TextStyle(
                                          fontSize: 10,
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
    'tbcColor': const Color(0xFFCA8A04),
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
    'tbcColor': kPrimaryColor, // Corrected from kPrimary_Color
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
  {
    'title': "Star Keeper",
    'description': "Goalkeeper with the most clean sheets (or fewest goals conceded)",
    'image': 'brown.svg',
    'tbcColor': kPrimaryColor,
  }
];
