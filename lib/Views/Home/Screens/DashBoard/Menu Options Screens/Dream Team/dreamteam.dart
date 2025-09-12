import 'package:champion_footballer/Model/Api%20Models/dream_team_model.dart';
import 'package:champion_footballer/Model/Api%20Models/usermodel.dart';
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart'; // Ensures global LeagueOptionTile is available via packages.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DreamTeamScreen extends ConsumerStatefulWidget {
  const DreamTeamScreen({super.key});

  @override
  ConsumerState<DreamTeamScreen> createState() => _DreamTeamScreenState();
}

class _DreamTeamScreenState extends ConsumerState<DreamTeamScreen> {

  static const List<Map<String, dynamic>> _fieldSlots = [
    {"role": "goalkeeper", "left": 126.0, "top": 260.0},
    {"role": "defenders", "left": 60.0, "top": 200.0},
    {"role": "defenders", "left": 200.0, "top": 200.0},
    {"role": "midfielders", "left": 134.0, "top": 120.0},
    {"role": "forwards", "left": 60.0, "top": 50.0},
    {"role": "forwards", "left": 200.0, "top": 50.0}
  ];

  String _getDisplayPosition(String? fullPosition) {
    if (fullPosition == null || fullPosition.isEmpty) {
      return 'N/A';
    }
    final RegExp lastParentheses = RegExp(r'\(([^)]+)\)[^(]*$');
    RegExpMatch? match = lastParentheses.firstMatch(fullPosition);
    if (match != null && match.group(1) != null) {
      return match.group(1)!.trim();
    }
    switch (fullPosition.trim().toUpperCase()) {
      case 'GOALKEEPER':
      case 'GOAL KEEPER':
        return 'GK';
      case 'DEFENDER':
        return 'DF';
      case 'LEFT-BACK':
      case 'LEFT BACK':
        return 'LB';
      case 'RIGHT-BACK':
      case 'RIGHT BACK':
        return 'RB';
      case 'CENTRE-BACK':
      case 'CENTER BACK':
      case 'CENTRAL DEFENDER':
        return 'CB';
      case 'MIDFIELDER':
      case 'MIDFILEDER':
        return 'MF';
      case 'CENTRAL MIDFIELDER':
        return 'CM';
      case 'ATTACKING MIDFIELDER':
        return 'AM';
      case 'DEFENSIVE MIDFIELDER':
        return 'DM';
      case 'LEFT MIDFIELDER':
      case 'LEFT WING':
        return 'LM';
      case 'RIGHT MIDFIELDER':
      case 'RIGHT WING':
        return 'RM';
      case 'STRIKER':
        return 'ST';
      case 'FORWARD':
        return 'FW';
      case 'CENTRE FORWARD':
      case 'CENTER FORWARD':
        return 'CF';
      default:
        if (fullPosition.length <= 3 &&
            fullPosition == fullPosition.toUpperCase()) {
          return fullPosition;
        }
        return fullPosition;
    }
  }

  Widget _createPlayerWidgetOnField(DreamPlayer player,
      Map<String, dynamic> slot, LeaguesJoined? selectedLeague) {
    String shirtNumberToDisplay = '...';

    // Get the shirt number from the league member data
    if (selectedLeague != null && selectedLeague.members != null) {
      final leagueMember = selectedLeague.members!.firstWhere(
            (member) => member.id == player.id,
        orElse: () => UserElement(),
      );
      if (leagueMember.id != null &&
          leagueMember.shirtNumber != null &&
          leagueMember.shirtNumber!.isNotEmpty) {
        shirtNumberToDisplay = leagueMember.shirtNumber!;
      }
    }

    return Positioned(
      left: slot["left"],
      top: slot["top"],
      child: Column(
        children: [
          Text(
            player.displayName,
            style: TextStyle(
              color: kdefwhiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppImages.shirt,
                width: 40,
                height: 40,
              ),
              Text(
                shirtNumberToDisplay,
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
  }

  List<Widget> _buildPlayerPositionsOnField(
      DreamTeamData? dreamTeamData, LeaguesJoined? selectedLeague) {
    if (dreamTeamData == null) return [];

    List<Widget> playerWidgets = [];


    if (dreamTeamData.goalkeeper?.isNotEmpty ?? false) {
      playerWidgets.add(_createPlayerWidgetOnField(
          dreamTeamData.goalkeeper!.first, _fieldSlots[0], selectedLeague));
    }
    if (dreamTeamData.defenders?.isNotEmpty ?? false) {
      playerWidgets.add(_createPlayerWidgetOnField(
          dreamTeamData.defenders!.first, _fieldSlots[1], selectedLeague));
      if (dreamTeamData.defenders!.length > 1) {
        playerWidgets.add(_createPlayerWidgetOnField(
            dreamTeamData.defenders![1], _fieldSlots[2], selectedLeague));
      }
    }
    if (dreamTeamData.midfielders?.isNotEmpty ?? false) {
      playerWidgets.add(_createPlayerWidgetOnField(
          dreamTeamData.midfielders!.first, _fieldSlots[3], selectedLeague));
    }
    if (dreamTeamData.forwards?.isNotEmpty ?? false) {
      playerWidgets.add(_createPlayerWidgetOnField(
          dreamTeamData.forwards!.first, _fieldSlots[4], selectedLeague));
      if (dreamTeamData.forwards!.length > 1) {
        playerWidgets.add(_createPlayerWidgetOnField(
            dreamTeamData.forwards![1], _fieldSlots[5], selectedLeague));
      }
    }
    return playerWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(userDataProvider);
    final selectedLeague = ref.watch(selectedLeagueForDreamTeamProvider);
    final leagues = userDataAsync.when(
      data: (user) => user.leagues ?? [],
      loading: () => [],
      error: (e, s) => [],
    );

    if (selectedLeague == null && leagues.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedLeagueForDreamTeamProvider.notifier).state =
              leagues.first;
        }
      });
    }

    final dreamTeamAsync = selectedLeague != null && selectedLeague.id != null
        ? ref.watch(dreamTeamDataProvider(selectedLeague.id!))
        : null;

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Dream Team",
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Expanded(
                  child: Text(
                    selectedLeague?.name ??
                        (leagues.isNotEmpty ? "Select League" : "No Leagues Joined"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ktextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                if (leagues.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.all(16),
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
                                10.0.heightbox,
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: leagues.length,
                                    itemBuilder: (context, index) {
                                      final leagueToList = leagues[index];
                                      // Using global LeagueOptionTile, removed isSelected
                                      return LeagueOptionTile( 
                                        leagueName:
                                        leagueToList.name ?? "Unnamed League",
                                        subtitle: '${leagueToList.matches?.length ?? 0} matches, ${leagueToList.users?.length ?? 0} players', // Added subtitle
                                        onTap: () {
                                          ref
                                              .read(
                                              selectedLeagueForDreamTeamProvider
                                                  .notifier)
                                              .state = leagueToList;
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
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
            15.0.heightbox,
            Expanded(
              flex: 2,
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
                    if (dreamTeamAsync != null)
                      dreamTeamAsync.when(
                        data: (dreamTeamResponse) {
                          if (dreamTeamResponse.success == true &&
                              dreamTeamResponse.dreamTeam != null) {
                            return Stack(
                                children: _buildPlayerPositionsOnField(
                                    dreamTeamResponse.dreamTeam!, selectedLeague));
                          } else {
                            return Center(
                                child: Text("No dream team data available.",
                                    style: TextStyle(color: kdefwhiteColor)));
                          }
                        },
                        loading: () => Center(
                            child: CircularProgressIndicator(color: kPrimaryColor)),
                        error: (err, stack) => Center(
                            child: Text('Error: ${err.toString()}',
                                style: TextStyle(color: Colors.red))),
                      )
                    else if (selectedLeague != null)
                      Center(child: CircularProgressIndicator(color: kPrimaryColor))
                    else
                      Center(
                          child: Text("Select a league to see the Dream Team",
                              style: TextStyle(color: kdefwhiteColor))),
                  ],
                ),
              ),
            ),
            10.0.heightbox,
            Expanded(
              flex: 1,
              child: Padding(
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
                    Expanded(
                      child: StyledContainer(
                        padding: EdgeInsets.all(12),
                        borderColor: kPrimaryColor.withOpacity(.5),
                        boxShadow: [],
                        child: dreamTeamAsync != null
                            ? dreamTeamAsync.when(
                          data: (dreamTeamResponse) {
                            if (dreamTeamResponse.success == true &&
                                dreamTeamResponse.dreamTeam != null) {
                              return _buildPlayerStatsGrid(
                                  dreamTeamResponse.dreamTeam!);
                            } else {
                              return Center(
                                  child: Text("No player stats available."));
                            }
                          },
                          loading: () => Center(
                              child: CircularProgressIndicator(color: kPrimaryColor)),
                          error: (err, stack) => Center(
                              child: Text('Error: ${err.toString()}',
                                  style: TextStyle(color: Colors.red))),
                        )
                            : Center(child: Text("Select a league.")),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerStatsGrid(DreamTeamData dreamTeamData) {
    List<DreamPlayer> allPlayers = [
      ...(dreamTeamData.goalkeeper ?? []),
      ...(dreamTeamData.defenders ?? []),
      ...(dreamTeamData.midfielders ?? []),
      ...(dreamTeamData.forwards ?? []),
    ];

    if (allPlayers.isEmpty) {
      return Center(
          child:
          Text("No players in the dream team.", style: TextStyle(color: ktextColor)));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        childAspectRatio: 4.5, // Adjusted for better text visibility
        mainAxisSpacing: 8,
      ),
      itemCount: allPlayers.length,
      itemBuilder: (context, index) {
        final player = allPlayers[index];
        final displayPos = _getDisplayPosition(player.position);
        return Row( // Using Row for each item
          children: [
            Image.asset(
              AppImages.shirt, // Assuming AppImages.shirt is defined
              width: 18,
              height: 18,
            ),
            10.0.widthbox,
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: player.firstName,
                      style: TextStyle(
                        color: ktextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: (displayPos.toUpperCase() == "GK")
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: kdefblackColor,
                      ),
                    ),
                    TextSpan(
                      text: " ($displayPos)",
                      style: TextStyle(
                        color: ktextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Removed local LeagueOptionTile class definition

