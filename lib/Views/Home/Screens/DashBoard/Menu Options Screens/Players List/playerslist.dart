import 'package:champion_footballer/Model/Api%20Models/played_with_player_model.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

import '../../../../../../Services/RiverPord Provider/ref_provider.dart';

class PlayerListScreen extends ConsumerWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playedWithPlayersData = ref.watch(playedWithPlayersProvider);
    final searchQuery = ref.watch(playerSearchQueryProvider);

    print("Current search query: '$searchQuery'");

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Players",
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
        padding: defaultPadding(vertical: 10),
        child: playedWithPlayersData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (players) {
            print("Total players from API: ${players.length}");

            final filteredPlayers = players.where((player) {
              final nameLower = player.name.toLowerCase();
              final searchLower = searchQuery.toLowerCase();
              return nameLower.contains(searchLower);
            }).toList();

            print("Filtered players count: ${filteredPlayers.length} for query '$searchQuery'");

            if (filteredPlayers.isEmpty && searchQuery.isNotEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: defaultPadding(),
                    child: PrimaryTextField(
                      hintText: "Search Players",
                      bordercolor: kPrimaryColor.withOpacity(0.5),
                      onChanged: (value) {
                        print("PrimaryTextField onChanged CALLED with value: $value");
                        ref.read(playerSearchQueryProvider.notifier).state = value;
                      },
                    ),
                  ),
                  15.0.heightbox,
                  const Center(child: Text("No players found matching your search.")),
                ],
              );
            } else if (players.isEmpty) {
               return const Center(
                  child: Text("No players found. Play some matches!"));
            }

            return Column(
              children: [
                Padding(
                  padding: defaultPadding(),
                  child: PrimaryTextField(
                    hintText: "Search Players",
                    bordercolor: kPrimaryColor.withOpacity(0.5),
                    onChanged: (value) {
                      print("PrimaryTextField onChanged CALLED with value: $value");
                      ref.read(playerSearchQueryProvider.notifier).state = value;
                    },
                  ),
                ),
                15.0.heightbox,

                // Column Titles
                Row(
                  children: const [
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 3,
                      child: Text("Name",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("Shirt No.",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kblueColor)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("XP",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kredColor,
                          )),
                    ),
                  ],
                ),
                8.0.heightbox,

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      final bool isHighlighted = index == 0 && searchQuery.isEmpty;

                      ImageProvider<Object> avatarImage;
                      if (player.profilePicture != null && player.profilePicture!.isNotEmpty) {
                        avatarImage = NetworkImage(player.profilePicture!);
                      } else {
                        avatarImage = AssetImage(AppImages.profilepic); // Fallback image
                      }

                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: avatarImage,
                            radius: 15,
                            onBackgroundImageError: (_, __) {
                              print("Error loading image for ${player.name}");
                            },
                          ),
                          5.0.widthbox,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayerStatsScreen()));
                                print("Tapped on ${player.name}");
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
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        player.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isHighlighted
                                              ? kdefwhiteColor
                                              : ktextColor,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 26.0),
                                        child: Text(
                                          player.shirtNumber ?? "N/A",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isHighlighted ? kdefwhiteColor : kblueColor,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 9.0),
                                        child: Text(
                                          "${player.rating}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: isHighlighted ? Colors.white : Colors.black,
                                          ),
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
          },
        ),
      ),
    );
  }
}
