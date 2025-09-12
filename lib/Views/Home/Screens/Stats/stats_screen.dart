import 'dart:convert'; // For jsonDecode
import 'package:champion_footballer/Model/Api%20Models/usermodel.dart';
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import '../../../../Utils/packages.dart';

// Providers for loading/error states
final addStatsLeagueLoadingProvider = StateProvider<bool>((ref) => true);
final addStatsLeagueErrorProvider = StateProvider<String?>((ref) => null);

class AddStatsScreen extends ConsumerStatefulWidget {
  const AddStatsScreen({super.key});

  @override
  ConsumerState<AddStatsScreen> createState() => _AddStatsScreenState();
}

class _AddStatsScreenState extends ConsumerState<AddStatsScreen> {
  int goals = 0;
  int assists = 0;
  int cleanSheets = 0;

  List<LeaguesJoined> _userLeagues = [];
  LeaguesJoined? _selectedLeagueForDisplay;
  Match? _selectedMatch;
  UserElement? _selectedMotmPlayer;
  String? _loggedInUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserLeaguesAndSetInitialMatch();
    });
  }

  Future<void> _fetchUserLeaguesAndSetInitialMatch() async {
    ref.read(addStatsLeagueLoadingProvider.notifier).state = true;
    ref.read(addStatsLeagueErrorProvider.notifier).state = null;
    try {
      final loggedInUserData = await ref.read(userDataProvider.future);
      if (mounted) {
        if (loggedInUserData.id != null) {
          setState(() {
            _loggedInUserId = loggedInUserData.id!;
          });
        }

        if (loggedInUserData.leagues != null && loggedInUserData.leagues!.isNotEmpty) {
          setState(() {
            _userLeagues = loggedInUserData.leagues!;
            _selectedLeagueForDisplay = _userLeagues.first;
            _updateSelectedMatchForCurrentLeague();
          });
        } else {
          ref.read(addStatsLeagueErrorProvider.notifier).state = "No leagues joined.";
          setState(() {
            _userLeagues = [];
            _selectedLeagueForDisplay = null;
            _selectedMatch = null;
            _selectedMotmPlayer = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ref.read(addStatsLeagueErrorProvider.notifier).state = "Error initializing: ${e.toString()}";
      }
    } finally {
      if (mounted) {
        ref.read(addStatsLeagueLoadingProvider.notifier).state = false;
      }
    }
  }

  void _updateSelectedMatchForCurrentLeague() {
    if (_selectedLeagueForDisplay?.matches != null && _selectedLeagueForDisplay!.matches!.isNotEmpty) {
      List<Match> allMatchesInLeague = List.from(_selectedLeagueForDisplay!.matches!);
      List<Match> matchesWithCreated = allMatchesInLeague.where((m) => m.createdAt != null).toList();
      Match? initialMatchToSelect;
      if (matchesWithCreated.isNotEmpty) {
        matchesWithCreated.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        initialMatchToSelect = matchesWithCreated.first;
      } else if (allMatchesInLeague.isNotEmpty) {
        initialMatchToSelect = allMatchesInLeague.first;
      }
      setState(() {
        _selectedMatch = initialMatchToSelect;
        _selectedMotmPlayer = null;
      });
    } else {
      setState(() {
        _selectedMatch = null;
        _selectedMotmPlayer = null;
      });
    }
  }

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
    final isLeagueLoading = ref.watch(addStatsLeagueLoadingProvider);
    final leagueError = ref.watch(addStatsLeagueErrorProvider);

    List<Match> availableMatches = _selectedLeagueForDisplay?.matches?.where((m) => m.id != null).toList() ?? [];

    List<UserElement> allPlayersForMotm = [];
    if (_selectedMatch != null) {
      if (_selectedMatch!.homeTeamUsers != null) {
        allPlayersForMotm.addAll(_selectedMatch!.homeTeamUsers!);
      }
      if (_selectedMatch!.awayTeamUsers != null) {
        allPlayersForMotm.addAll(_selectedMatch!.awayTeamUsers!);
      }
      allPlayersForMotm = allPlayersForMotm
          .where((player) => player.id != null && player.firstName != null)
          .where((player) => player.id != _loggedInUserId)
          .toList();
    }

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Add Stats",
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
                Expanded(
                  child: Text(
                    isLeagueLoading
                        ? "Loading League..."
                        : (_selectedLeagueForDisplay?.name ?? leagueError ?? "Select League"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ktextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (isLeagueLoading || _userLeagues.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(leagueError ?? (isLeagueLoading ? "Leagues are loading..." : "No leagues available."))),
                      );
                      return;
                    }
                    showModalBottomSheet<LeaguesJoined>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      backgroundColor: Colors.white, // Modal background
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                              Divider(color: Colors.grey.shade300, thickness: 1),
                              10.0.heightbox,
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _userLeagues.length,
                                  itemBuilder: (context, index) {
                                    final leagueToList = _userLeagues[index];
                                    // final bool isCurrentlySelected = leagueToList.id == _selectedLeagueForDisplay?.id; // Logic removed
                                    return LeagueOptionTile(
                                      leagueName: leagueToList.name ?? "Unnamed League",
                                      subtitle: '${leagueToList.matches?.length ?? 0} matches, ${leagueToList.users?.length ?? 0} players',
                                      // No explicit colors passed to use defaults from LeagueOptionTile itself
                                      // textColor: isCurrentlySelected ? kPrimaryColor : ktextColor,
                                      // iconColor: isCurrentlySelected ? kPrimaryColor : Colors.grey.shade300,
                                      // backgroundColor: isCurrentlySelected ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
                                      onTap: () {
                                        Navigator.pop(context, leagueToList);
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
                    ).then((chosenLeague) {
                      if (chosenLeague != null && chosenLeague.id != _selectedLeagueForDisplay?.id) {
                        setState(() {
                          _selectedLeagueForDisplay = chosenLeague;
                          _updateSelectedMatchForCurrentLeague();
                        });
                      }
                    });
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
            10.0.heightbox,
            if (isLeagueLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              )
            else if (leagueError != null && _selectedLeagueForDisplay == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(leagueError, style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
              )
            else if (_selectedLeagueForDisplay == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(leagueError ?? "Please select a league to see matches.", style: TextStyle(color: ktextColor)),
                )
            else if (availableMatches.isEmpty)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("No matches available for ${_selectedLeagueForDisplay?.name ?? 'this league'}.", style: TextStyle(color: ktextColor)),
                )
                else
                  DropdownButton<String>(
                    value: _selectedMatch?.id,
                    hint: Text("Select Match", style: TextStyle(color: ktextColor, fontWeight: FontWeight.w600, fontSize: 14)),
                    isExpanded: true,
                    menuMaxHeight: 200.0,
                    items: availableMatches.asMap().entries.map((entry) {
                      int matchNumberInList = entry.key + 1;
                      Match match = entry.value;
                      String scoreDisplay;

                      if (match.homeTeamGoals != null && match.awayTeamGoals != null) {
                        scoreDisplay = "(${match.homeTeamGoals}-${match.awayTeamGoals})";
                      } else {
                        scoreDisplay = "(0-0)";
                      }

                      String matchDisplayName = "Match $matchNumberInList: $scoreDisplay";

                      return DropdownMenuItem<String>(
                        value: match.id!,
                        child: Center(
                          child: Text(
                            matchDisplayName,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final newSelectedMatch = availableMatches.firstWhere((m) => m.id == value, orElse: null);
                        if (_selectedMatch?.id != newSelectedMatch?.id) {
                          setState(() {
                            _selectedMatch = newSelectedMatch;
                            _selectedMotmPlayer = null;
                          });
                        } else {
                          setState(() {
                            _selectedMatch = newSelectedMatch;
                          });
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_drop_down, size: 30, color: kPrimaryColor),
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
                  if (_selectedMatch == null && !isLeagueLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Please select a match to see players.", style: TextStyle(color: ktextColor), textAlign: TextAlign.center,),
                    )
                  else if (allPlayersForMotm.isEmpty && _selectedMatch != null && !isLeagueLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No players available", style: TextStyle(color: ktextColor), textAlign: TextAlign.center,),
                    )
                  else if (allPlayersForMotm.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: allPlayersForMotm.length,
                      itemBuilder: (context, index) {
                        final UserElement player = allPlayersForMotm[index];
                        final bool isSelected = _selectedMotmPlayer?.id == player.id;
                        String playerName = (player.firstName ?? "") + (player.lastName != null ? " ${player.lastName}" : "");
                        if (playerName.trim().isEmpty) playerName = "Player";

                        final UserElement tappedPlayer = player;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedMotmPlayer = null;
                              } else {
                                _selectedMotmPlayer = tappedPlayer;
                              }
                            });
                          },
                          child: PlayerAvatar(
                            name: playerName,
                            voted: isSelected,
                            imageUrl: player.profilePicture,
                          ),
                        );
                      },
                    )
                  else if (isLeagueLoading)
                     SizedBox.shrink()
                  else if (!isLeagueLoading && _selectedMatch != null)
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Select a match to view players or no players eligible.", style: TextStyle(color: ktextColor), textAlign: TextAlign.center,),
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
  final String? imageUrl;

  const PlayerAvatar({
    super.key,
    required this.name,
    this.voted = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? networkImageProvider;
    bool imageAvailable = false;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      try {
        if (Uri.tryParse(imageUrl!)?.hasAbsolutePath ?? false) {
            networkImageProvider = NetworkImage(imageUrl!);
            imageAvailable = true;
        }
      } catch (e) {
        networkImageProvider = null;
        imageAvailable = false;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: imageAvailable ? Colors.transparent : kPrimaryColor.withAlpha(150),
          backgroundImage: imageAvailable ? networkImageProvider : null,
          child: !imageAvailable
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'P',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        5.0.heightbox,
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        5.0.heightbox,
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
          )
        else
          SizedBox(height: (4 + 4 + 8 + 5)),
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
