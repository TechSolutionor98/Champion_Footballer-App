import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Edit%20Match/editmatch.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Team%20Preview/teamprieview.dart';
import 'package:champion_footballer/Views/Home/Screens/Stats/stats_screen.dart';
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import '../../../../../../../Model/Api Models/usermodel.dart';
import '../../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../../Utils/packages.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Matches",
      ),
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AppImages.trophy,
                    width: 15, height: 15, color: ktextColor),
                SizedBox(width: 8),
                Consumer(builder: (context, ref, _) {
                  final selectedLeague = ref.watch(selectedLeagueProvider);
                  return Text(
                    selectedLeague?.name!.toUpperCase() ?? "SELECT LEAGUE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ktextColor,
                    ),
                  );
                }),
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
                        return Consumer(builder: (context, ref, _) {
                          final userAsync = ref.watch(userDataProvider);
                          return userAsync.when(
                            data: (user) {
                              final leagues = user.leaguesJoined;
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1),
                                    10.0.heightbox,
                                    ...leagues!
                                        .map((league) => LeagueOptionTile(
                                              leagueName:
                                                  league.name ?? "League",
                                              subtitle:
                                                  '${league.matches!.length} matches, ${league.users!.length} players',
                                              onTap: () {
                                                ref
                                                    .read(selectedLeagueProvider
                                                        .notifier)
                                                    .state = league;
                                                Navigator.pop(context);
                                              },
                                            )),
                                    10.0.heightbox,
                                  ],
                                ),
                              );
                            },
                            loading: () => const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (e, _) => Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text('Error: $e'),
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        " Change",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_circle,
                        color: kPrimaryColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            10.0.heightbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonWithIcon(
                  buttonText: "New Match",
                  width: context.width / 3,
                  buttonColor: kblueColor,
                  fontSize: 12,
                  onPressFunction: () {
                    context.route(NewMatchScreen());
                  },
                  leadingWidget: Image.asset(
                    AppImages.plus,
                    width: 10,
                    height: 10,
                    color: kdefwhiteColor,
                  ),
                )
              ],
            ),
            Consumer(builder: (context, ref, _) {
              final league = ref.watch(selectedLeagueProvider);

              if (league == null ||
                  league.matches == null ||
                  league.matches!.isEmpty) {
                return SizedBox(); // No match info
              }

              final matches = league.matches!;

              // Find the latest match by createdAt
              final latestMatch = matches
                  .where((m) => m.createdAt != null)
                  .toList()
                ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

              final latestMatchIndex = matches.indexOf(latestMatch.first);

              return Text(
                "(New) Match ${latestMatchIndex + 1} Added",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }),
            SizedBox(height: 8),
            Consumer(builder: (context, ref, _) {
              final league = ref.watch(selectedLeagueProvider);

              if (league == null) {
                return Text("Select a league to view matches");
              }
              final matches = league.matches ?? [];
              if (league.matches!.isEmpty) {
                return Text("No matches available for ${league.name}");
              }

              return SizedBox(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Colors.red.shade100
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Match ${index + 1}: Score ${match.homeTeamGoals ?? 0}-${match.awayTeamGoals ?? 0}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ktextColor,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) => Row(
                    children: [
                      5.0.widthbox,
                      Container(width: 1, color: kdefblackColor, height: 20),
                      2.0.widthbox,
                    ],
                  ),
                ),
              );
            }),
            10.0.heightbox,
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                    color: kPrimaryColor.withValues(alpha: 0.5), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ActionButtonsRow(),
                  PlayerStatsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerStatsList extends ConsumerWidget {
  const PlayerStatsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final league = ref.watch(selectedLeagueProvider);
    final List<Match> matches = league?.matches ?? [];

    // Flatten all players from home and away teams across all matches
    final List allPlayers = matches.expand((match) {
      return [...(match.homeTeamUsers ?? []), ...(match.awayTeamUsers ?? [])];
    }).toList();

    // Group stats by userId
    final Map<String, List<Statistic>> allStats = {};
    for (final match in matches) {
      for (final stat in match.statistics ?? []) {
        allStats.putIfAbsent(stat.userId ?? '', () => []).add(stat);
      }
    }

    // Count MOTM votes per player
    final Map<String, int> motmVotes = {};
    for (final match in matches) {
      for (final vote in match.votes ?? []) {
        if (vote.forUserId != null) {
          motmVotes.update(vote.forUserId!, (val) => val + 1,
              ifAbsent: () => 1);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderRow(),
        Divider(
            color: kPrimaryColor.withValues(alpha: .5),
            thickness: 1.2,
            height: 0),
        SizedBox(height: 8),
        ...allPlayers.map((player) {
          final stats = allStats[player.id] ?? [];

          int goals = stats
              .where((s) => s.type == Type.GOALS_SCORED)
              .fold(0, (sum, s) => sum + (s.value ?? 0));
          int assists = stats
              .where((s) => s.type == Type.GOALS_ASSISTED)
              .fold(0, (sum, s) => sum + (s.value ?? 0));
          int cleanSheets = stats
              .where((s) => s.type == Type.CLEAN_SHEETS)
              .fold(0, (sum, s) => sum + (s.value ?? 0));
          int votes = motmVotes[player.id] ?? 0;

          int totalPoints =
              (goals * 10) + (assists * 6) + (cleanSheets * 5) + (votes * 3);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDataCell(player.displayName ?? "Player"),
                    _buildDataCell(goals.toString()),
                    _buildDataCell(assists.toString()),
                    _buildDataCell(cleanSheets.toString()),
                    _buildDataCell(votes.toString()),
                    _buildDataCell(totalPoints.toString()),
                  ],
                ),
              ),
              Divider(
                color: kPrimaryColor.withValues(alpha: .5),
                thickness: 1.2,
                height: 0,
              ),
            ],
          );
        }),
        SizedBox(height: 8),
      ],
    );
  }

  // Function to build the header row
  Widget _buildHeaderRow() {   
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderCell("Player"),
          _buildHeaderCell("Goals"),
          _buildHeaderCell("Assist"),
          _buildHeaderCell("Clean Sheet"),
          _buildHeaderCell("MOTM Votes"),
          _buildHeaderCell("Total Points"),
        ],
      ),
    );
  }

  // Helper function to create a header cell
  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: kPrimaryColor,
          decoration: TextDecoration.underline,
          decorationColor: kPrimaryColor,
        ),
      ),
    );
  }

  // Helper function to create a data cell
  Widget _buildDataCell(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(AppImages.editfill, "Edit Match", () {
          context.route(EditMatchScreen());
        }),
        _buildActionButton(AppImages.teamicon, "View Teams", () {
          context.route(TeamPreviewScreen());
        }),
        _buildActionButton(AppImages.statsicon, "Add your Stats", () {
          context.route(AddStatsScreen());
        }),
      ],
    );
  }

  Widget _buildActionButton(
      String imagePath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: kblueColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 15,
              height: 15,
              color: kdefwhiteColor,
            ),
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kdefwhiteColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
