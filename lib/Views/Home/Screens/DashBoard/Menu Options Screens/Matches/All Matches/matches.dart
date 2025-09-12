/*import 'package:champion_footballer/Utils/appextensions.dart';
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
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Choose League", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                                      Divider(color: Colors.grey.shade300, thickness: 1),
                                      10.0.heightbox,
                                      Expanded(
                                        child: ListView.separated(
                                          itemCount: leagues.length,
                                          separatorBuilder: (_, __) => SizedBox.shrink(), // <- no divider
                                          itemBuilder: (context, index) {
                                            final league = leagues[index];
                                            return LeagueOptionTile(
                                              leagueName: league.name ?? "League",
                                              subtitle: '${league.matches?.length ?? 0} matches, ${league.members?.length ?? 0} players',
                                              onTap: () {
                                                ref.read(selectedLeagueProvider.notifier).state = league;
                                                Navigator.pop(context);
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
                            loading: () => Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator())),
                            error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e')),
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
}*/

import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Edit%20Match/editmatch.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Team%20Preview/teamprieview.dart';
import 'package:champion_footballer/Views/Home/Screens/Stats/stats_screen.dart' hide LeagueOptionTile;
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import '../../../../../../../Model/Api Models/usermodel.dart';
import '../../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../../Utils/packages.dart';

// class MatchesScreen extends StatelessWidget {
//   const MatchesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldCustom(
//       appBar: CustomAppBar(
//         titleText: "Matches",
//       ),
//       body: SingleChildScrollView(
//         padding: defaultPadding(vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset(AppImages.trophy,
//                     width: 15, height: 15, color: ktextColor),
//                 SizedBox(width: 8),
//                 Consumer(builder: (context, ref, _) {
//                   final selectedLeague = ref.watch(selectedLeagueProvider);
//                   return Text(
//                     selectedLeague?.name!.toUpperCase() ?? "SELECT LEAGUE",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: ktextColor,
//                     ),
//                   );
//                 }),
//                 // Open sheet from parent and set provider after sheet returns selected league
//                 Consumer(builder: (context, ref, _) {
//                   return GestureDetector(
//                     onTap: () async {
//                       // Open the sheet and waitm for the selected league (returned via Navigator.pop(context, league))
//                       final selected = await showModalBottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.vertical(top: Radius.circular(20))),
//                         backgroundColor: Colors.white,
//                         builder: (context) {
//                           return Consumer(builder: (context, ref, _) {
//                             final userAsync = ref.watch(userDataProvider);
//                             return userAsync.when(
//                               data: (user) {
//                                 final leagues = user.leagues ?? [];
//                                 return SafeArea(
//                                   child: Container(
//                                     padding: EdgeInsets.all(16),
//                                     constraints: BoxConstraints(
//                                         maxHeight:
//                                         MediaQuery.of(context).size.height *
//                                             0.6),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text("Choose League",
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: kPrimaryColor)),
//                                         Divider(
//                                             color: Colors.grey.shade300,
//                                             thickness: 1),
//                                         10.0.heightbox,
//                                         Expanded(
//                                           child: ListView.separated(
//                                             itemCount: leagues.length,
//                                             separatorBuilder: (_, __) =>
//                                                 SizedBox.shrink(), // <- no divider
//                                             itemBuilder: (context, index) {
//                                               final league = leagues[index];
//                                               return LeagueOptionTile(
//                                                 leagueName:
//                                                 league.name ?? "League",
//                                                 subtitle:
//                                                 '${league.matches?.length ?? 0} matches, ${league.members?.length ?? 0} players',
//                                                 onTap: () {
//                                                   // Return selected league to caller (parent)
//                                                   Navigator.pop(context, league);
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         10.0.heightbox,
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               loading: () => Padding(
//                                   padding: EdgeInsets.all(16.0),
//                                   child: Center(
//                                       child: CircularProgressIndicator())),
//                               error: (e, _) =>
//                                   Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e')),
//                             );
//                           });
//                         },
//                       );
//
//                       // Parent receives the selected league and sets the provider
//                       if (selected != null) {
//                         // Debug prints (optional)
//                         // ignore: avoid_print
//                         print(
//                             'Selected league returned: name=${selected.name} members=${selected.members?.length} matches=${selected.matches?.length}');
//                         ref.read(selectedLeagueProvider.notifier).state = selected;
//                         // ignore: avoid_print
//                         print(
//                             'selectedLeagueProvider set. members=${ref.read(selectedLeagueProvider)?.members?.length}');
//                       }
//                     },
//                     child: Row(
//                       children: [
//                         Text(
//                           " Change",
//                           style: TextStyle(
//                             color: kPrimaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_drop_down_circle,
//                           color: kPrimaryColor,
//                           size: 15,
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ],
//             ),
//             10.0.heightbox,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ButtonWithIcon(
//                   buttonText: "New Match",
//                   width: context.width / 3,
//                   buttonColor: kblueColor,
//                   fontSize: 12,
//                   onPressFunction: () {
//                     context.route(NewMatchScreen());
//                   },
//                   leadingWidget: Image.asset(
//                     AppImages.plus,
//                     width: 10,
//                     height: 10,
//                     color: kdefwhiteColor,
//                   ),
//                 )
//               ],
//             ),
//             Consumer(builder: (context, ref, _) {
//               final league = ref.watch(selectedLeagueProvider);
//
//               if (league == null ||
//                   league.matches == null ||
//                   league.matches!.isEmpty) {
//                 return SizedBox(); // No match info
//               }
//
//               final matches = league.matches!;
//
//               // Find the latest match by createdAt
//               final latestMatch = matches
//                   .where((m) => m.createdAt != null)
//                   .toList()
//                 ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
//
//               final latestMatchIndex = matches.indexOf(latestMatch.first);
//
//               return Text(
//                 "(New) Match ${latestMatchIndex + 1} Added",
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               );
//             }),
//             SizedBox(height: 8),
//             Consumer(builder: (context, ref, _) {
//               final league = ref.watch(selectedLeagueProvider);
//
//               if (league == null) {
//                 return Text("Select a league to view matches");
//               }
//               final matches = league.matches ?? [];
//               if (league.matches!.isEmpty) {
//                 return Text("No matches available for ${league.name}");
//               }
//
//               return SizedBox(
//                 height: 30,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: matches.length,
//                   itemBuilder: (context, index) {
//                     final match = matches[index];
//
//                     return GestureDetector(
//                       onTap: () {
//                         ref.read(selectedMatchProvider.notifier).state = match;
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: match == ref.watch(selectedMatchProvider)
//                               ? Colors.red.shade100 // highlight selected match
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           "Match ${index + 1}: Score ${match.homeTeamGoals ?? 0}-${match.awayTeamGoals ?? 0}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: ktextColor,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   separatorBuilder: (_, index) => Row(
//                     children: [
//                       5.0.widthbox,
//                       Container(width: 1, color: kdefblackColor, height: 20),
//                       2.0.widthbox,
//                     ],
//                   ),
//                 ),
//               );
//             }),
//             10.0.heightbox,
//             Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     color: kPrimaryColor.withValues(alpha: 0.5), width: 2.0),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   ActionButtonsRow(),
//                   PlayerStatsList(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final userAsync = ref.watch(userDataProvider);

    if (selectedLeague == null) {
      userAsync.maybeWhen(
        data: (user) {
          final leagues = user.leagues ?? [];
          if (leagues.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                final current = ref.read(selectedLeagueProvider);
                if (current == null) {
                  ref.read(selectedLeagueProvider.notifier).state = leagues.first;
                }
              } catch (_) {

              }
            });
          }
        },
        orElse: () {},
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final currentMatch = ref.read(selectedMatchProvider);
        if (currentMatch == null) {
          final leagueNow = ref.read(selectedLeagueProvider);
          final matches = leagueNow?.matches ?? [];
          if (matches.isNotEmpty) {
            final withCreated = matches.where((m) => m.createdAt != null).toList();
            dynamic latest;
            if (withCreated.isNotEmpty) {
              withCreated.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              latest = withCreated.first;
            } else {
              latest = matches.first;
            }
            ref.read(selectedMatchProvider.notifier).state = latest;
          }
        }
      } catch (_) {

      }
    });

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Matches",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1), // orange
            Color.fromRGBO(207, 35, 38, 1),  // red
          ],
        ),
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

                Consumer(builder: (context, ref, _) {
                  return GestureDetector(
                    onTap: () async {
                      final selected = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
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
                                        maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Choose League",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor)),
                                        Divider(
                                            color: Colors.grey.shade300,
                                            thickness: 1),
                                        10.0.heightbox,
                                        Expanded(
                                          child: ListView.separated(
                                            itemCount: leagues.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox.shrink(),
                                            itemBuilder: (context, index) {
                                              final league = leagues[index];
                                              return LeagueOptionTile(
                                                leagueName:
                                                league.name ?? "League",
                                                subtitle:
                                                '${league.matches?.length ?? 0} matches, ${league.members?.length ?? 0} players',
                                                onTap: () {
                                                  Navigator.pop(context, league);
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
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              error: (e, _) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text('Error: $e')),
                            );
                          });
                        },
                      );


                      if (selected != null) {
                        print(
                            'Selected league returned: name=${selected.name} members=${selected.members?.length} matches=${selected.matches?.length}');
                        ref.read(selectedLeagueProvider.notifier).state = selected;
                        print(
                            'selectedLeagueProvider set. members=${ref.read(selectedLeagueProvider)?.members?.length}');
                      }
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
                  );
                }),
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
                return SizedBox();
              }

              final matches = league.matches!;

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

                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedMatchProvider.notifier).state = match;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: match == ref.watch(selectedMatchProvider)
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
/*class PlayerStatsList extends ConsumerWidget {
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
}*/

// class PlayerStatsList extends ConsumerWidget {
//   const PlayerStatsList({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.watch(matchRefreshProvider);
//
//     final league = ref.watch(selectedLeagueProvider);
//     if (league == null || league.matches == null || league.matches!.isEmpty) {
//       return const Text("No matches available");
//     }
//
//     // Get selected match or fallback to first/latest match
//     final selectedMatch = ref.watch(selectedMatchProvider)
//         ?? (league.matches!..sort((a, b) => b.createdAt!.compareTo(a.createdAt!))).first;
//
//     final matchStatsAsync = ref.watch(matchDetailProvider(selectedMatch.id!));
//
//     return matchStatsAsync.when(
//       data: (players) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeaderRow(),
//             Divider(
//               color: kPrimaryColor.withValues(alpha: .5),
//               thickness: 1.2,
//               height: 0,
//             ),
//             ...players.map((player) {
//               return Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 5.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildDataCell(player.firstName),
//                         _buildDataCell(player.goals.toString()),
//                         _buildDataCell(player.assists.toString()),
//                         _buildDataCell(player.cleanSheets.toString()),
//                         _buildDataCell(player.votes.toString()),
//                         _buildDataCell("0"), // total points (you can calculate later)
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     color: kPrimaryColor.withValues(alpha: .5),
//                     thickness: 1.2,
//                     height: 0,
//                   ),
//                 ],
//               );
//             }).toList(),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, _) => Text("Error: $err"),
//     );
//   }
//
//   // keep your helper UI methods
//   Widget _buildHeaderRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildHeaderCell("Player"),
//           _buildHeaderCell("Goals"),
//           _buildHeaderCell("Assist"),
//           _buildHeaderCell("Clean Sheet"),
//           _buildHeaderCell("MOTM Votes"),
//           _buildHeaderCell("Total Points"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeaderCell(String text) {
//     return Expanded(
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//           color: kPrimaryColor,
//           decoration: TextDecoration.underline,
//           decorationColor: kPrimaryColor,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDataCell(String text) {
//     return Expanded(
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

class PlayerStatsList extends ConsumerWidget {
  const PlayerStatsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(matchRefreshProvider);

    final league = ref.watch(selectedLeagueProvider);
    if (league == null || league.matches == null || league.matches!.isEmpty) {
      return const Text("No matches available");
    }

    final selectedMatch = ref.watch(selectedMatchProvider) ??
        (league.matches!..sort((a, b) => b.createdAt!.compareTo(a.createdAt!))).first;

    final matchStatsAsync = ref.watch(matchDetailProvider(selectedMatch.id!));

    return matchStatsAsync.when(
      data: (players) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),
            Divider(
              color: kPrimaryColor.withValues(alpha: .5),
              thickness: 1.2,
              height: 0,
            ),
            ...players.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              final match = selectedMatch as Match;

              // home/away membership
              final String? pid = _getPlayerId(player);
              final bool isHome = _isPlayerInListById(pid, match.homeTeamUsers) ||
                  _isPlayerInListByName(player, match.homeTeamUsers);
              final bool isAway = _isPlayerInListById(pid, match.awayTeamUsers) ||
                  _isPlayerInListByName(player, match.awayTeamUsers);

              final bool isLast = index == players.length - 1;

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        _buildNameCell(_getFirstName(player), isHome, isAway, flex: 2),
                        _buildDataCell(_getStatValue(player, 'goals'), flex: 1),
                        _buildDataCell(_getStatValue(player, 'assists'), flex: 1, padding: const EdgeInsets.only(left: 14)),
                        _buildDataCell(_getStatValue(player, 'cleanSheets'), flex: 1, padding: const EdgeInsets.only(left: 35)),
                        _buildDataCell(_getStatValue(player, 'votes'), flex: 1, padding: const EdgeInsets.only(left: 42)),
                        _buildDataCell("0", flex: 2, padding: const EdgeInsets.only(left: 29)),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      color: kPrimaryColor.withValues(alpha: .5),
                      thickness: 1.0,
                      height: 0,
                    ),
                ],
              );
            }).toList(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text("Error: $err"),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          _buildHeaderCell("Player", flex: 3, align: TextAlign.left, leftPadding: 6),
          _buildHeaderCell("Goals", flex: 2),
          _buildHeaderCell("Assist", flex: 2),
          _buildHeaderCell("Clean Sheet", flex: 2),
          _buildHeaderCell("MOTM Votes", flex: 2),
          _buildHeaderCell("Total Points", flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
      String text, {
        int flex = 1,
        TextAlign align = TextAlign.center,
        double leftPadding = 0,
      }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding),
        child: Text(
          text,
          textAlign: align,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: kPrimaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }


  Widget _buildNameCell(String name, bool isHome, bool isAway, {int flex = 1}) {
    final Color squareColor =
    isHome ? Colors.green : (isAway ? Colors.blue : Colors.transparent);

    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              name,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          if (squareColor != Colors.transparent)
            Container(
              width: 12,
              height: 12,
              color: squareColor,
            ),
        ],
      ),
    );
  }

  Widget _buildDataCell(
      String text, {
        int flex = 2,
        EdgeInsets padding = const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
      }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  String? _getPlayerId(dynamic p) {
    try {
      if (p == null) return null;
      if (p is PlayerStats) return p.id;
      if (p is UserElement) return p.id;
      final dyn = p as dynamic;
      return dyn.id?.toString() ?? dyn.userId?.toString() ?? dyn.playerId?.toString();
    } catch (_) {
      return null;
    }
  }

  bool _isPlayerInListById(String? pid, List<UserElement>? list) {
    if (pid == null || list == null) return false;
    return list.any((u) => u.id != null && u.id.toString() == pid);
  }

  bool _isPlayerInListByName(dynamic player, List<UserElement>? list) {
    if (list == null || list.isEmpty) return false;
    final String pname = _getFirstName(player).trim().toLowerCase();
    if (pname.isEmpty) return false;
    return list.any((u) => (u.firstName ?? '').trim().toLowerCase() == pname);
  }

  String _getFirstName(dynamic p) {
    try {
      if (p is PlayerStats) return p.firstName;
      if (p is UserElement) return p.firstName ?? '';
      final dyn = p as dynamic;
      return dyn.firstName ?? dyn.name ?? dyn.displayName ?? '';
    } catch (_) {
      return '';
    }
  }

  String _getStatValue(dynamic p, String field) {
    try {
      if (p is PlayerStats) {
        switch (field) {
          case 'goals':
            return p.goals.toString();
          case 'assists':
            return p.assists.toString();
          case 'cleanSheets':
            return p.cleanSheets.toString();
          case 'votes':
            return p.votes.toString();
        }
      }
      final dyn = p as dynamic;
      final val = (field == 'goals')
          ? (dyn.goals ?? dyn.goalsScored ?? dyn.goals_scored)
          : (field == 'assists')
          ? (dyn.assists ?? dyn.goalsAssisted ?? dyn.goals_assisted)
          : (field == 'cleanSheets')
          ? (dyn.cleanSheets ?? dyn.clean_sheets)
          : (dyn.votes ?? dyn.votesCount ?? dyn.voteCount);
      return (val ?? 0).toString();
    } catch (_) {
      return '0';
    }
  }
}






class ActionButtonsRow extends ConsumerWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final selectedMatch = ref.watch(selectedMatchProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(AppImages.editfill, "Edit Match", () async {
          if (selectedLeague == null || selectedMatch == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a league and a match first")),
            );
            return;
          }

          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditMatchScreen(
                matchId: selectedMatch.id!,
                leagueId: selectedLeague.id!,
              ),
            ),
          );

          if (updated == true) {
            // invalidate user data
            final user = await ref.refresh(userDataProvider.future);

            // find updated league
            final updatedLeague = user.leagues?.firstWhere(
                  (l) => l.id == selectedLeague.id,
              orElse: () => selectedLeague,
            );

            if (updatedLeague != null) {
              ref.read(selectedLeagueProvider.notifier).state = updatedLeague;

              final updatedMatch = updatedLeague.matches?.firstWhere(
                    (m) => m.id == selectedMatch.id,
                orElse: () => selectedMatch,
              );

              if (updatedMatch != null) {
                ref.read(selectedMatchProvider.notifier).state = updatedMatch;
              }
            }


            // refresh match detail
            ref.invalidate(matchDetailProvider(selectedMatch.id!));
          }

          // context.route(
          //   EditMatchScreen(
          //     matchId: selectedMatch.id!,
          //     leagueId: selectedLeague.id!,
          //   ),
          // );
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
        padding: const EdgeInsets.symmetric(vertical: 5),
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
            const SizedBox(height: 5),
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

