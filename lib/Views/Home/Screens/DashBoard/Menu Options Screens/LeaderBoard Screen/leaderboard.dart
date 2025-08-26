import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

import '../../../../../../Model/Api Models/usermodel.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';

class LeaderBoardScreen extends ConsumerWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    return ScaffoldCustom(
      appBar: CustomAppBar(titleText: "Leader Board"),
      body: selectedLeague == null
          ? Center(child: Text("Select a league to view leaderboard"))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
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
                        final selectedLeague =
                            ref.watch(selectedLeagueProvider);
                        return Text(
                          selectedLeague?.name!.toUpperCase() ??
                              "SELECT LEAGUE",
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return Consumer(builder: (context, ref, _) {
                                final userAsync = ref.watch(userDataProvider);
                                return userAsync.when(
                                  data: (user) {
                                    final leagues = user.leagues;
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
                                                          .read(
                                                              selectedLeagueProvider
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
                                    child: Center(
                                        child: CircularProgressIndicator()),
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

                  // Stats Grid using GridView for perfect alignment
                  StyledContainer(
                    padding: defaultPadding(horizontal: 5, vertical: 5),
                    borderColor: kPrimaryColor.withValues(alpha: .5),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.8,
                      children: [
                        _statItem("assets/icons/goals.png", "Goals"),
                        _statItem("assets/icons/assist.png", "Assists"),
                        _statItem("assets/icons/defence.png", "Defence"),
                        _statItem("assets/icons/motm.png", "MOTM"),
                        _statItem("assets/icons/impact.png", "Impact"),
                        _statItem("assets/icons/cleansheet.png", "Clean Sheet"),
                      ],
                    ),
                  ),

                  20.0.heightbox,

                  // Top Goal Scorer
                  Text(
                    "Top Goal Scorer",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  10.0.heightbox,

// Player Cards with Proper Spacing Without Cutting Image
                  Builder(builder: (context) {
                    final users = selectedLeague.users ?? [];

                    // Calculate goals per player
                    final List<Map<String, dynamic>> playerStats =
                        users.map((player) {
                      final goals = player.matchStatistics
                              ?.where((s) => s.type == Type.GOALS_SCORED)
                              .fold<int>(0, (sum, s) => sum + (s.value ?? 0)) ??
                          0;
                      final points =
                          (goals * 10); // Or adjust with full formula
                      return {
                        "name":
                            player.displayName ?? player.firstName ?? "Unknown",
                        "position": player.position ?? "-",
                        "goals": goals,
                        "points": points,
                        "picture": player.pictureKey != null
                            ? "https://cdn.championfootballer.com/${pictureKeyValues.reverse[player.pictureKey]}"
                            : null,
                      };
                    }).toList();

                    // Sort by goals
                    playerStats
                        .sort((a, b) => b["goals"].compareTo(a["goals"]));
                    final topThree = playerStats.take(3).toList();
                    return Column(
                      children: List.generate(topThree.length, (index) {
                        final player = topThree[index];
                        final offsetPadding = [45, 60, 35][index];
                        final bottomOffset = [-10, 1, -8][index];

                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: offsetPadding.toDouble()),
                          child: PlayerCard(
                            name: player["name"],
                            position: player["position"],
                            goals: player["goals"],
                            points: player["points"],
                            image: player["picture"] ??
                                "assets/images/play${index + 1}.png",
                            // isNetwork: player["picture"] != null,
                            imageBottomOffset: bottomOffset.toDouble(),
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  // Individual Stat Item (Icon + Label)
  Widget _statItem(String iconPath, String label) {
    return Column(
      children: [
        Image.asset(iconPath, width: 35, height: 35),
        5.0.heightbox,
        Text(label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
