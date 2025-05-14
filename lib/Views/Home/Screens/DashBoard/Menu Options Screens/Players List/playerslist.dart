import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

import '../../../../../../Services/RiverPord Provider/ref_provider.dart';

class PlayerListScreen extends ConsumerWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);
    return ScaffoldCustom(
      appBar: CustomAppBar(titleText: "Players"),
      body: Padding(
        padding: defaultPadding(vertical: 10),
        child: userAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (user) {
              final selectedLeague = ref.watch(selectedLeagueProvider);
              final players = selectedLeague?.users ?? [];

              if (players.isEmpty) {
                return const Center(
                    child: Text("No players found in this league."));
              }
              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: defaultPadding(),
                    child: PrimaryTextField(
                      hintText: "Search Players",
                      bordercolor: kPrimaryColor.withValues(alpha: .5),
                    ),
                  ),
                  15.0.heightbox,

                  // Column Titles
                  Row(
                    children: const [
                      // Expanded(
                      //   flex: 1,
                      //   child: Text("",
                      //       style:
                      //           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      // ),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 3,
                        child: Text("Name",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Stats",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kblueColor)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Rating",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kredColor,
                            )),
                      ),
                    ],
                  ),
                  8.0.heightbox,

                  // Player List
                  Expanded(
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];

                        // Calculate average CRX
                        final attributes = player.attributes;
                        final attrList = [
                          attributes?.pace,
                          attributes?.shooting,
                          attributes?.passing,
                          attributes?.defending,
                          attributes?.dribbling,
                          attributes?.physical,
                        ].whereType<int>().toList();

                        final avgCRX = attrList.isNotEmpty
                            ? (attrList.reduce((a, b) => a + b) /
                                    attrList.length)
                                .round()
                            : 0;

                        final bool isHighlighted = index == 0;
                        return Row(
                          children: [
                            // Player Avatar
                            CircleAvatar(
                              backgroundImage: AssetImage(AppImages.profilepic),
                              radius: 15,
                            ),
                            5.0.widthbox,
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.route(PlayerStatsScreen());
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isHighlighted ? null : Colors.white,
                                    gradient: isHighlighted
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF666565),
                                              Color(0xFF010101)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Player Name
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          player.firstName ?? "Unknown",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isHighlighted
                                                ? kdefwhiteColor
                                                : ktextColor,
                                          ),
                                        ),
                                      ),

                                      // Stats Icon
                                      Expanded(
                                        flex: 4,
                                        child: Image.asset(
                                          "assets/icons/stat.png",
                                          color: isHighlighted
                                              ? kdefwhiteColor
                                              : kPrimaryColor,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),

                                      20.0.widthbox,

                                      // Rating Number
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "$avgCRX",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: isHighlighted
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
