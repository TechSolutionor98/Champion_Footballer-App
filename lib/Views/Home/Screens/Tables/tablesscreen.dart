import 'package:champion_footballer/Utils/appextensions.dart';
import '../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../Utils/packages.dart';
import 'package:flutter/widgets.dart';

class TableScreen extends ConsumerStatefulWidget {
  const TableScreen({super.key});

  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userDataProvider);
    
    // Watch BOTH user data and selected league
    return userAsync.when(
      loading: () => ScaffoldCustom(
        appBar: CustomAppBar(
          titleText: "Table",
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(229, 106, 22, 1),
              Color.fromRGBO(207, 35, 38, 1),
            ],
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => ScaffoldCustom(
        appBar: CustomAppBar(
          titleText: "Table",
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(229, 106, 22, 1),
              Color.fromRGBO(207, 35, 38, 1),
            ],
          ),
        ),
        body: Center(child: Text("Error loading leagues: $error")),
      ),
      data: (user) {
        final userLeagues = user.leagues ?? [];

        // Handle no leagues case
        if (userLeagues.isEmpty) {
          return ScaffoldCustom(
            appBar: CustomAppBar(
              titleText: "Table",
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(229, 106, 22, 1),
                  Color.fromRGBO(207, 35, 38, 1),
                ],
              ),
            ),
            body: Center(
              child: Text("No leagues available. Please create or join a league."),
            ),
          );
        }

        // Get the currently selected league from provider
        final selectedLeagueFromProvider = ref.watch(selectedLeagueProvider);
        
        // Find the FRESH league data from user.leagues
        final leagueToDisplay = userLeagues.firstWhere(
          (l) => l.id == selectedLeagueFromProvider?.id,
          orElse: () => userLeagues.first,
        );
        
        // Update provider if it's different or null
        if (selectedLeagueFromProvider == null || selectedLeagueFromProvider.id != leagueToDisplay.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(selectedLeagueProvider.notifier).state = leagueToDisplay;
            }
          });
        }

        // Use the FRESH league data from user.leagues, not from provider
        final players = leagueToDisplay.members ?? [];
        final matches = leagueToDisplay.matches ?? [];

        // Calculate player stats
        final playerStats = <String, Map<String, int>>{};
        for (final player in players) {
          playerStats[player.id!] = {"p": 0, "w": 0, "d": 0, "l": 0, "pts": 0};
        }

        for (final match in matches) {
          if (match.homeTeamGoals == null || match.awayTeamGoals == null) continue;

          final homeWin = match.homeTeamGoals! > match.awayTeamGoals!;
          final awayWin = match.awayTeamGoals! > match.homeTeamGoals!;
          final draw = match.homeTeamGoals == match.awayTeamGoals;

          for (final p in match.homeTeamUsers ?? []) {
            if (playerStats.containsKey(p.id)) {
              final stats = playerStats[p.id]!;
              stats["p"] = stats["p"]! + 1;
              if (homeWin) {
                stats["w"] = stats["w"]! + 1;
                stats["pts"] = stats["pts"]! + 3;
              } else if (draw) {
                stats["d"] = stats["d"]! + 1;
                stats["pts"] = stats["pts"]! + 1;
              } else {
                stats["l"] = stats["l"]! + 1;
              }
            }
          }

          for (final p in match.awayTeamUsers ?? []) {
            if (playerStats.containsKey(p.id)) {
              final stats = playerStats[p.id]!;
              stats["p"] = stats["p"]! + 1;
              if (awayWin) {
                stats["w"] = stats["w"]! + 1;
                stats["pts"] = stats["pts"]! + 3;
              } else if (draw) {
                stats["d"] = stats["d"]! + 1;
                stats["pts"] = stats["pts"]! + 1;
              } else {
                stats["l"] = stats["l"]! + 1;
              }
            }
          }
        }

        // Build UI
        return ScaffoldCustom(
          appBar: CustomAppBar(
            titleText: "Table",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ...existing UI code...
                10.0.heightbox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.trophy, width: 20, height: 20, color: ktextColor),
                    8.0.widthbox,
                    Text(
                      leagueToDisplay.name ?? "Unknown League",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ktextColor),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selected = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return Consumer(builder: (context, ref, _) {
                                  final userAsync = ref.watch(userDataProvider);
                                  return userAsync.when(
                                    data: (user) {
                                      final leagues = user.leagues ?? [];
                                      return SafeArea(
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context).size.height * 0.6),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Choose League",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: kPrimaryColor)),
                                              Divider(color: Colors.grey.shade300, thickness: 1),
                                              10.0.heightbox,
                                              Expanded(
                                                child: ListView.separated(
                                                  itemCount: leagues.length,
                                                  separatorBuilder: (_, __) => SizedBox.shrink(),
                                                  itemBuilder: (context, index) {
                                                    final l = leagues[index];
                                                    return LeagueOptionTile(
                                                      leagueName: l.name ?? "League",
                                                      subtitle:
                                                          '${l.matches?.length ?? 0} matches, ${l.members?.length ?? 0} players',
                                                      onTap: () {
                                                        Navigator.pop(context, l);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              10.0.heightbox,
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    loading: () => Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(child: CircularProgressIndicator())),
                                    error: (e, _) => Padding(
                                        padding: const EdgeInsets.all(16), child: Text('Error: $e')),
                                  );
                                });
                              },
                            );

                            if (selected != null) {
                              ref.read(selectedLeagueProvider.notifier).state = selected;
                            }
                          },
                          child: Row(
                            children: [
                              Text(" Change",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Icon(Icons.arrow_drop_down_circle, color: kPrimaryColor, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                10.0.heightbox,
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade100,
                        Colors.green.shade200,
                        Colors.green.shade100
                      ],
                      stops: [0.0, 0.5, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                10.0.heightbox,
                Text("Invite Players", style: TextStyle(fontWeight: FontWeight.bold, color: ktextColor)),
                Text("By Using The Code",
                    style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      decoration: BoxDecoration(
                          color: kPrimaryColor, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(leagueToDisplay.inviteCode ?? "N/A",
                              style: TextStyle(
                                  color: kdefwhiteColor,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kdefwhiteColor,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: leagueToDisplay.inviteCode ?? ""));
                            },
                            child: Image.asset(AppImages.copy,
                                width: 15, height: 15, color: kdefwhiteColor),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (matches.isNotEmpty) {
                          final withCreated = matches.where((m) => m.createdAt != null).toList();
                          dynamic latestMatch;
                          if (withCreated.isNotEmpty) {
                            withCreated.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                            latestMatch = withCreated.first;
                          } else {
                            latestMatch = matches.first;
                          }

                          try {
                            ref.read(selectedMatchProvider.notifier).state = latestMatch;
                          } catch (_) {}
                        }

                        context.route(MatchesScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        decoration: BoxDecoration(
                            color: kPrimaryColor, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Image.asset(AppImages.matches,
                                width: 20, height: 20, color: kdefwhiteColor),
                            SizedBox(width: 5),
                            Text("Matches",
                                style: TextStyle(
                                    color: kdefwhiteColor,
                                    fontSize: 14,
                                    decorationColor: kdefwhiteColor,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                20.0.heightbox,
                Container(
                  decoration: BoxDecoration(border: Border.all(color: kPrimaryColor)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: kPrimaryColor, border: Border.all(color: kdefblackColor)),
                        child: Row(
                          children: [
                            _buildHeaderCell("Name", flex: 3),
                            _buildHeaderCell("P"),
                            _buildHeaderCell("W"),
                            _buildHeaderCell("D"),
                            _buildHeaderCell("L"),
                            _buildHeaderCell("PTS"),
                          ],
                        ),
                      ),
                      ...players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final p = entry.value;
                        final stats = playerStats[p.id] ?? {"p": 0, "w": 0, "d": 0, "l": 0, "pts": 0};
                        return _buildDataRow(
                          index + 1,
                          p.firstName ?? "Player",
                          AppImages.shirt,
                          null,
                          stats["p"]!,
                          stats["w"]!,
                          stats["d"]!,
                          stats["l"]!,
                          stats["pts"]!,
                        );
                      }),
                    ],
                  ),
                ),
                10.0.heightbox,
                Text("Statistics",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ktextColor,
                    )),
                SizedBox(height: 5),
                StatisticsWidget(
                  matchesPlayed:
                      matches.where((m) => m.homeTeamGoals != null && m.awayTeamGoals != null).length,
                  remainingMatches: matches.length -
                      matches.where((m) => m.homeTeamGoals != null && m.awayTeamGoals != null).length,
                  playersCount: players.length,
                  createdOn: leagueToDisplay.createdAt != null
                      ? DateTime.tryParse(leagueToDisplay.createdAt.toString())
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) => Expanded(
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

  Widget _buildDataRow(
    int rank,
    String name,
    String shirtIcon,
    String? badgeIcon,
    int p,
    int w,
    int d,
    int l,
    int pts, {
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: kdefwhiteColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 0.8),
        ),
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
                Image.asset(shirtIcon, width: 18, height: 18),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
                if (badgeIcon != null) ...[
                  const SizedBox(width: 4),
                  Image.asset(badgeIcon, width: 18, height: 18),
                ],
              ],
            ),
          ),
          _buildDataCell("$p"),
          _buildDataCell("$w"),
          _buildDataCell("$d"),
          _buildDataCell("$l"),
          _buildDataCell("$pts", bold: true),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, {bool bold = false}) => Expanded(
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

class StatisticsWidget extends StatelessWidget {
  final int matchesPlayed;
  final int remainingMatches;
  final int playersCount;
  final DateTime? createdOn;

  const StatisticsWidget({
    super.key,
    required this.matchesPlayed,
    required this.remainingMatches,
    required this.playersCount,
    this.createdOn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$matchesPlayed Matches Played With $remainingMatches Matches Remaining.",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ktextColor,
              fontSize: 12,
            ),
          ),
          Text(
            "$playersCount Players",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ktextColor,
              fontSize: 12,
            ),
          ),
          Text(
            "Created On ${createdOn != null ? createdOn.toString() : "N/A"}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ktextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
