import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../Widgets/customappbar.dart';
import '../../../../../../Utils/appcolors.dart';
import '../../../../../../Utils/imageconstants.dart';
import '../../../../../../Model/Api Models/usermodel.dart';
import '../Matches/Edit Match/editmatch.dart'; 
import '../Awards Screen/awardscreen.dart' as awards_screen_file;
import 'package:champion_footballer/Utils/appextensions.dart';
import '../../../../../../Utils/packages.dart';
import '../Settings/settings.dart';
import '../Matches/All Matches/matches.dart' as all_matches_screen;

class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  String _selectedTab = 'Matches';

  Widget _buildLeagueTableHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLeagueTableDataRow({
    required int rank,
    required String playerName,
    required String playerShirtIconPath,
    String? badgeIconPath,
    required int played,
    required int won,
    required int drawn,
    required int lost,
    required int points,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: kdefwhiteColor,
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade400, width: 0.8)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const SizedBox(width: 6),
                Text("$rank"),
                const SizedBox(width: 6),
                Image.asset(playerShirtIconPath, width: 18, height: 18),
                const SizedBox(width: 6),
                Text(
                  playerName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                if (badgeIconPath != null) ...[
                  const SizedBox(width: 4),
                  Image.asset(badgeIconPath, width: 18, height: 18),
                ],
              ],
            ),
          ),
          _buildLeagueTableDataCell("$played"),
          _buildLeagueTableDataCell("$won"),
          _buildLeagueTableDataCell("$drawn"),
          _buildLeagueTableDataCell("$lost"),
          _buildLeagueTableDataCell("$points", bold: true),
        ],
      ),
    );
  }

  Widget _buildLeagueTableDataCell(String text, {bool bold = false}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(color: Colors.grey),
        )),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic selectedLeague = ref.watch(selectedLeagueProvider);
    final String leagueName = selectedLeague?.name ?? "League Details";
    final String inviteCode = selectedLeague?.inviteCode ?? "N/A";

    return Scaffold(
      appBar: CustomAppBar(
        titleText: leagueName,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: Container( // Added Container for background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea( // Existing SafeArea
          child: Column(
            children: [
              Container(
                color: Colors.transparent, // Changed to transparent
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Invite Players ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: ktextColor),
                            ),
                            TextSpan(
                              text: "to this League using Code: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: ktextColor),
                            ),
                            TextSpan(
                              text: inviteCode,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kPrimaryColor),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (inviteCode != "N/A") {
                          Clipboard.setData(ClipboardData(text: inviteCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invite code copied!"),
                                duration: Duration(seconds: 2)),
                          );
                        }
                      },
                      child: Image.asset(AppImages.copy,
                          width: 20, height: 20, color: ktextColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade100,
                        Colors.green.shade400,
                        Colors.green.shade100
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabButton(
                        text: "Table",
                        isActive: _selectedTab == 'Table',
                        onTap: () => setState(() => _selectedTab = 'Table')),
                    _tabButton(
                        text: "Matches",
                        isActive: _selectedTab == 'Matches',
                        onTap: () => setState(() => _selectedTab = 'Matches')),
                    _tabButton(
                        text: "Awards",
                        isActive: _selectedTab == 'Awards',
                        onTap: () => setState(() => _selectedTab = 'Awards')),
                    IconButton(
                      icon: Icon(Icons.settings, color: ktextColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LeagueSettings()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _selectedTab == 'Awards'
                    ? _buildContent(selectedLeague) 
                    : SingleChildScrollView( 
                        child: _buildContent(selectedLeague),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(
      {required String text,
      required bool isActive,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? kPrimaryColor : kdefwhiteColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: isActive ? kPrimaryColor : Colors.grey.shade400),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? kdefwhiteColor : ktextColor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(dynamic leagueFromSelectedProvider) {
    switch (_selectedTab) {
      case 'Table':
        if (leagueFromSelectedProvider == null) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No league selected.",
                      style: TextStyle(color: Colors.grey))));
        }
        final List<dynamic> players = leagueFromSelectedProvider.members ?? [];
        final List<dynamic> leagueMatchesForTable =
            leagueFromSelectedProvider.matches ?? [];

        if (players.isEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No players in this league yet.",
                      style: TextStyle(color: Colors.grey))));
        }

        final playerStats = <String, Map<String, int>>{};
        for (final player in players) {
          final playerId = player?.id as String?;
          if (playerId != null) {
            playerStats[playerId] = {
              "p": 0,
              "w": 0,
              "d": 0,
              "l": 0,
              "gf": 0,
              "ga": 0,
              "pts": 0
            };
          }
        }

        for (final matchSummary in leagueMatchesForTable) {
          final homeGoals = matchSummary?.homeTeamGoals as int?;
          final awayGoals = matchSummary?.awayTeamGoals as int?;
          final List<dynamic> homeTeamPlayerInfos =
              matchSummary?.homeTeamUsers ?? [];
          final List<dynamic> awayTeamPlayerInfos =
              matchSummary?.awayTeamUsers ?? [];

          if (homeGoals == null || awayGoals == null) continue;

          final bool homeWin = homeGoals > awayGoals;
          final bool awayWin = awayGoals > homeGoals;
          final bool draw = homeGoals == awayGoals;

          for (final pInfo in homeTeamPlayerInfos) {
            final playerId = pInfo?.id as String?;
            if (playerId != null && playerStats.containsKey(playerId)) {
              playerStats[playerId]!["p"] = playerStats[playerId]!["p"]! + 1;
              playerStats[playerId]!["gf"] =
                  playerStats[playerId]!["gf"]! + homeGoals;
              playerStats[playerId]!["ga"] =
                  playerStats[playerId]!["ga"]! + awayGoals;
              if (homeWin) {
                playerStats[playerId]!["w"] = playerStats[playerId]!["w"]! + 1;
                playerStats[playerId]!["pts"] =
                    playerStats[playerId]!["pts"]! + 3;
              } else if (draw) {
                playerStats[playerId]!["d"] = playerStats[playerId]!["d"]! + 1;
                playerStats[playerId]!["pts"] =
                    playerStats[playerId]!["pts"]! + 1;
              } else {
                playerStats[playerId]!["l"] = playerStats[playerId]!["l"]! + 1;
              }
            }
          }

          for (final pInfo in awayTeamPlayerInfos) {
            final playerId = pInfo?.id as String?;
            if (playerId != null && playerStats.containsKey(playerId)) {
              playerStats[playerId]!["p"] = playerStats[playerId]!["p"]! + 1;
              playerStats[playerId]!["gf"] =
                  playerStats[playerId]!["gf"]! + awayGoals;
              playerStats[playerId]!["ga"] =
                  playerStats[playerId]!["ga"]! + homeGoals;
              if (awayWin) {
                playerStats[playerId]!["w"] = playerStats[playerId]!["w"]! + 1;
                playerStats[playerId]!["pts"] =
                    playerStats[playerId]!["pts"]! + 3;
              } else if (draw) {
                playerStats[playerId]!["d"] = playerStats[playerId]!["d"]! + 1;
                playerStats[playerId]!["pts"] =
                    playerStats[playerId]!["pts"]! + 1;
              } else {
                playerStats[playerId]!["l"] = playerStats[playerId]!["l"]! + 1;
              }
            }
          }
        }

        final standingsData = <Map<String, dynamic>>[];
        for (final player in players) {
          final playerId = player?.id as String?;
          final playerName = player?.firstName as String? ?? "Player";

          if (playerId != null && playerStats.containsKey(playerId)) {
            final stats = playerStats[playerId]!;
            standingsData.add({
              'id': playerId,
              'name': playerName,
              'p': stats['p']!,
              'w': stats['w']!,
              'd': stats['d']!,
              'l': stats['l']!,
              'gf': stats['gf']!,
              'ga': stats['ga']!,
              'gd': stats['gf']! - stats['ga']!,
              'pts': stats['pts']!,
            });
          }
        }

        standingsData.sort((a, b) {
          int ptsCompare = b['pts'].compareTo(a['pts']);
          if (ptsCompare != 0) return ptsCompare;
          int gdCompare = b['gd'].compareTo(a['gd']);
          if (gdCompare != 0) return gdCompare;
          return b['gf'].compareTo(a['gf']);
        });

        if (standingsData.isEmpty &&
            leagueMatchesForTable.isNotEmpty &&
            players.isNotEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                      "Matches found, but no player stats calculated. Check match data and player IDs.",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center)));
        }
        if (standingsData.isEmpty &&
            leagueMatchesForTable.isEmpty &&
            players.isNotEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No matches played yet in this league.",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center)));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      border: Border.all(color: kdefblackColor)),
                  child: Row(
                    children: [
                      _buildLeagueTableHeaderCell("Name", flex: 3),
                      _buildLeagueTableHeaderCell("P"),
                      _buildLeagueTableHeaderCell("W"),
                      _buildLeagueTableHeaderCell("D"),
                      _buildLeagueTableHeaderCell("L"),
                      _buildLeagueTableHeaderCell("Pts"),
                    ],
                  ),
                ),
                if (standingsData.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                        child: Text("No standings to display.",
                            style: TextStyle(color: Colors.grey))),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: standingsData.length,
                    itemBuilder: (context, index) {
                      final entry = standingsData[index];
                      return _buildLeagueTableDataRow(
                        rank: index + 1,
                        playerName: entry['name'],
                        playerShirtIconPath: AppImages.shirt,
                        badgeIconPath: null,
                        played: entry['p'],
                        won: entry['w'],
                        drawn: entry['d'],
                        lost: entry['l'],
                        points: entry['pts'],
                      );
                    },
                  ),
              ],
            ),
          ),
        );

      case 'Matches':
        if (leagueFromSelectedProvider == null ||
            leagueFromSelectedProvider.id == null) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No league selected or league ID is missing.",
                      style: TextStyle(color: Colors.grey))));
        }

        final String currentLeagueId = leagueFromSelectedProvider.id!;
        final asyncLeagueDetails =
            ref.watch(leagueSettingsProvider(currentLeagueId));

        return asyncLeagueDetails.when(
          loading: () => const Center(child: CircularProgressIndicator()), 
          error: (err, stack) => Center(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Error loading league details: ${err.toString()}",
                      style: TextStyle(color: Colors.red)))),
          data: (leagueDetailsData) {
            if (leagueDetailsData == null) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text("League details not found.",
                          style: TextStyle(color: Colors.grey))));
            }
            
            final int totalLeagueMembers = leagueDetailsData.members?.length ?? 0;

            final List<dynamic> rawMatchesFromLeagueSettings =
                leagueDetailsData.matches ?? [];

            final List<Match> leagueMatchSummaries =
                rawMatchesFromLeagueSettings
                    .map((m) {
                      if (m is Map<String, dynamic>) {
                        final matchId = m['id'] as String?;
                        if (matchId != null) {
                          return Match.fromJson(m);
                        }
                      } else if (m is Match) {
                        return m;
                      }
                      return null;
                    })
                    .whereType<Match>()
                    .toList();

            if (leagueMatchSummaries.isEmpty) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text("No matches scheduled in this league yet.",
                          style: TextStyle(color: Colors.black))));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: leagueMatchSummaries.length,
              itemBuilder: (context, index) {
                final matchSummary = leagueMatchSummaries[index];

                if (matchSummary.id == null) {
                  return Card(
                      child: ListTile(
                          title: Text(
                              "Invalid match data (no ID) in summary list.")));
                }
                final String matchId = matchSummary.id!;

                final asyncDetailedMatch = ref.watch(detailedMatchProvider(
                    (leagueId: currentLeagueId, matchId: matchId)));

                return asyncDetailedMatch.when(
                  loading: () => const SizedBox(height: 180), 
                  error: (err, stack) => Card(
                    color: Colors.red.shade100,
                    child: ListTile(
                      title: Text("Error loading details for match $matchId"),
                      subtitle: Text(err.toString()),
                    ),
                  ),
                  data: (fetchedMatch) {
                    String displayDate = "Date N/A";
                    String displayTimeOrStatus =
                        fetchedMatch.status ?? "Scheduled";

                    DateTime? primaryDateSource;
                    DateTime? primaryTimeSource;

                    if (fetchedMatch.start != null) {
                      primaryDateSource = fetchedMatch.start;
                      primaryTimeSource = fetchedMatch.start;
                    } else if (fetchedMatch.date != null) {
                      primaryDateSource = fetchedMatch.date;
                      primaryTimeSource = fetchedMatch.date; 
                    }

                    if (primaryDateSource != null) {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final yesterday =
                          DateTime(now.year, now.month, now.day - 1);
                      final matchDateComparison = primaryDateSource.isUtc ? primaryDateSource.toLocal() : primaryDateSource;
                      final matchDate = DateTime(matchDateComparison.year,
                          matchDateComparison.month, matchDateComparison.day);

                      if (matchDate.isAtSameMomentAs(today)) {
                        displayDate = "Today";
                      } else if (matchDate.isAtSameMomentAs(yesterday)) {
                        displayDate = "Yesterday";
                      } else {
                        displayDate =
                            DateFormat('dd/MM/yyyy').format(matchDateComparison);
                      }
                    }

                    bool isPastEndTime = fetchedMatch.start != null &&
                        DateTime.now().isAfter(fetchedMatch.start!);
                                        
                    bool canEditMatch = false; 
                    if (fetchedMatch.start != null) {
                      canEditMatch = DateTime.now().isBefore(fetchedMatch.start!);
                    }

                    String finalButton1Text;
                    String finalButton2Text;
                    bool useAvailabilityStyleForButton2;

                    if (canEditMatch) { 
                        finalButton1Text = "Available";
                        final int availableCount = fetchedMatch.availableUsers?.length ?? 0;
                        int pendingCount = totalLeagueMembers - availableCount;
                        if (pendingCount < 0) pendingCount = 0;
                        finalButton2Text = "Available:$availableCount|Pending:$pendingCount";
                        useAvailabilityStyleForButton2 = true;
                    } else { 
                        finalButton1Text = "Update Score Card";
                        finalButton2Text = "Add Your Stats";
                        useAvailabilityStyleForButton2 = false;
                    }
                    
                    if (fetchedMatch.status?.toLowerCase() == 'completed' ||
                        fetchedMatch.status?.toLowerCase() == 'finished' ||
                        fetchedMatch.status?.toLowerCase() == 'played') {
                      displayTimeOrStatus = "Full time";
                    } else if (fetchedMatch.status?.toLowerCase() == 'live' ||
                        fetchedMatch.status?.toLowerCase() == 'in_progress') {
                      displayTimeOrStatus = "Live";
                    } else if (isPastEndTime && (fetchedMatch.status == null || fetchedMatch.status!.toLowerCase() == 'scheduled')) {
                      displayTimeOrStatus = "Full time"; 
                    } else if (primaryTimeSource != null) {
                      displayTimeOrStatus =
                          DateFormat('hh:mm a').format(primaryTimeSource.toLocal());
                    } 

                    return _matchCard(
                      cardContext: context, // Pass BuildContext from itemBuilder
                      fetchedMatchObject: fetchedMatch, // Pass the full match object
                      ref: ref, 
                      matchId: matchId, 
                      leagueId: currentLeagueId, 
                      homeTeamName: fetchedMatch.homeTeamName ?? "Home Team",
                      homeTeamImagePath: "assets/icons/homeicon.png", 
                      homeTeamScore: fetchedMatch.homeTeamGoals ?? 0,
                      awayTeamName: fetchedMatch.awayTeamName ?? "Away Team",
                      awayTeamImagePath: "assets/icons/awayicon.png", 
                      awayTeamScore: fetchedMatch.awayTeamGoals ?? 0,
                      date: displayDate,
                      timeOrStatus: displayTimeOrStatus,
                      showEditIcon: canEditMatch, 
                      button1Text: finalButton1Text,
                      button2Text: finalButton2Text,
                      button1Color: const Color(0xFF0388E3),
                      button2Color: const Color(0xFFFA5836),
                      isAvailabilityCard: useAvailabilityStyleForButton2,
                    );
                  },
                );
              },
            );
          },
        );

      case 'Awards':
        return Builder(builder: (context) { 
          return DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: kdefwhiteColor,
                  child: TabBar(
                    labelPadding: EdgeInsets.symmetric(vertical: 5),
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
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
                    children: [
                      SingleChildScrollView(
                        padding: defaultPadding(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding( 
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                children: [
                                  Row( 
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
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        backgroundColor: Colors.white,
                                        builder: (modalContext) { 
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
                            ),
                            15.0.heightbox,
                            Padding( 
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: awards_screen_file.trophies.length,
                                itemBuilder: (context, index) {
                                  var trophy = awards_screen_file.trophies[index];
                                  return StyledContainer(
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
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        padding: defaultPadding(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding( 
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                children: [
                                  Row(
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
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        backgroundColor: Colors.white,
                                        builder: (modalContext) { 
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
                            ),
                            15.0.heightbox,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.builder(
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
                                    width: 120, 
                                    height: 155, 
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
                                            // context.route(MatchDetailScreen()); // Commented out as per previous step
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _matchCard(
      {required BuildContext cardContext,
      required Match fetchedMatchObject,
      required WidgetRef ref, 
      required String matchId, 
      required String leagueId, 
      required String homeTeamName,
      String? homeTeamImagePath, 
      int? homeTeamScore,
      required String awayTeamName,
      String? awayTeamImagePath, 
      int? awayTeamScore,
      required String date,
      required String timeOrStatus,
      required bool showEditIcon,
      required String button1Text,
      required String button2Text,
      required Color button1Color,
      required Color button2Color,
      required bool isAvailabilityCard}) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedMatchProvider.notifier).state = fetchedMatchObject;
        Navigator.push(
          cardContext, // Use the passed context for navigation
          MaterialPageRoute(builder: (context) => const all_matches_screen.MatchesScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF767676),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _teamRow(
                        teamName: homeTeamName,
                        score: homeTeamScore,
                        isHomeTeam: true,
                        teamImagePath: homeTeamImagePath, 
                      ),
                      const SizedBox(height: 12),
                      _teamRow(
                        teamName: awayTeamName,
                        score: awayTeamScore,
                        isHomeTeam: false,
                        teamImagePath: awayTeamImagePath, 
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: Colors.white.withOpacity(0.5),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (showEditIcon)
                        GestureDetector(
                          onTap: () async { 
                            final result = await Navigator.push(
                              cardContext,
                              MaterialPageRoute(
                                builder: (context) => EditMatchScreen(
                                  matchId: matchId,
                                  leagueId: leagueId,
                                ),
                              ),
                            );
                            if (result == true) {
                               ref.refresh(detailedMatchProvider((leagueId: leagueId, matchId: matchId)));
                            }
                          },
                          child: const Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        )
                      else
                        const SizedBox(height: 20),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeOrStatus,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _cardButton(
                  text: button1Text,
                  bgColor: button1Color,
                  textColor: Colors.white,
                  isOutline: false,
                ),
                isAvailabilityCard
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: button2Color,
                            ),
                            child: Text(
                              button2Text,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      )
                    : _cardButton(
                        text: button2Text,
                        bgColor: button2Color,
                        textColor: Colors.white,
                        isOutline: false,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamRow(
      {required String teamName, 
      int? score, 
      required bool isHomeTeam,
      String? teamImagePath 
      }) {
    Widget imageWidget;
    if (teamImagePath != null && teamImagePath.isNotEmpty) {
      if (teamImagePath.startsWith('http')) {
         imageWidget = Image.network(
          teamImagePath,
          width: 24,
          height: 24,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading network image: $teamImagePath, Error: $error");
            return Image.asset(AppImages.trophy, width: 24, height: 24, color: Colors.white);
          },
        );
      } else {
        imageWidget = Image.asset(
          teamImagePath,
          width: 24,
          height: 24,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading asset image: $teamImagePath, Error: $error");
            return Image.asset(AppImages.trophy, width: 24, height: 24, color: Colors.white);
          },
        );
      }
    } else {
      imageWidget = Image.asset(AppImages.trophy, width: 24, height: 24, color: Colors.white);
    }

    return Row(
      children: [
        imageWidget,
        const SizedBox(width: 8),
        Text(
          teamName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (score != null) ...[
          const Spacer(),
          Text(
            score.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _cardButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    required bool isOutline,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: () {
            print("Card Button '$text' tapped!");
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isOutline ? Colors.transparent : bgColor,
              borderRadius: BorderRadius.circular(6),
              border: isOutline ? Border.all(color: textColor) : null,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
