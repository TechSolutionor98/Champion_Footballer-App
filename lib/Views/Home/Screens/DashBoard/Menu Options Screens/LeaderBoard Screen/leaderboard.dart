import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
import './Widget/playercard.dart';
// Assuming LeaguesJoined model is accessible, e.g. from usermodel.dart or via userStatusLeaguesProvider type
// import '../../../../../../Model/Api Models/usermodel.dart'; 

class LeaderBoardScreen extends ConsumerWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    // final userAsync = ref.watch(userDataProvider); // Kept if used for other user data, but league list below uses userStatusLeaguesProvider

    if (selectedLeague == null) {
      // Use userStatusLeaguesProvider to get the list of leagues for initial setup
      ref.watch(userStatusLeaguesProvider).when(
        data: (leaguesList) { // leaguesList is List<LeaguesJoined>
          if (leaguesList.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check again: ensure selectedLeagueProvider is still null before setting.
              if (ref.read(selectedLeagueProvider) == null) {
                try {
                  ref.read(selectedLeagueProvider.notifier).state = leaguesList.first;
                  ref.read(selectedLeaderboardMetricProvider.notifier).state = leaderboardMetrics.first.key;
                } catch (_) {
                  // Consider logging the error or handling it appropriately
                }
              }
            });
          }
        },
        loading: () { /* UI already handles selectedLeague == null, so explicit loading here might not be needed */ },
        error: (e, s) { /* Optionally handle error, e.g. log it. UI shows general loading message */ },
      );
    }

    final currentMetricKey = ref.watch(selectedLeaderboardMetricProvider);
    final currentMetric = leaderboardMetrics.firstWhere((m) => m.key == currentMetricKey, orElse: () => leaderboardMetrics.first);

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Leader Board",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: selectedLeague == null
          ? Center(child: Text("Loading leagues or select a league...", style: TextStyle(color: ktextColor)))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppImages.trophy, width: 15, height: 15, color: ktextColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedLeague.name?.toUpperCase() ?? "SELECT LEAGUE", 
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ktextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return Consumer(builder: (context, ref, _) {
                                // Changed to userStatusLeaguesProvider for the modal
                                final userLeaguesAsyncModal = ref.watch(userStatusLeaguesProvider);
                                return userLeaguesAsyncModal.when(
                                  data: (leaguesList) { // leaguesList is List<LeaguesJoined>
                                    return Container(
                                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Choose League", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                                          Divider(color: Colors.grey.shade300, thickness: 1),
                                          10.0.heightbox,
                                          Flexible(
                                            child: leaguesList.isEmpty
                                                ? Center(child: Text("No leagues joined."))
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: leaguesList.length,
                                                    itemBuilder: (context, index) {
                                                      final league = leaguesList[index];
                                                      return LeagueOptionTile(
                                                        leagueName: league.name ?? "League",
                                                        subtitle: '${league.matches?.length ?? 0} matches, ${league.users?.length ?? 0} players',
                                                        onTap: () {
                                                          ref.read(selectedLeagueProvider.notifier).state = league;
                                                          ref.read(selectedLeaderboardMetricProvider.notifier).state = leaderboardMetrics.first.key;
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
                                  loading: () => const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator())),
                                  error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: Text('Error loading leagues: $e')),
                                );
                              });
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(" Change", style: TextStyle(color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_drop_down_circle, color: kPrimaryColor, size: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.0.heightbox,
                  StyledContainer(
                    padding: defaultPadding(horizontal: 5, vertical: 5),
                    borderColor: kPrimaryColor.withValues(alpha: .5),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.5, 
                      ),
                      itemCount: leaderboardMetrics.length,
                      itemBuilder: (context, index) {
                        final metric = leaderboardMetrics[index];
                        final bool isSelected = metric.key == currentMetricKey;
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedLeaderboardMetricProvider.notifier).state = metric.key;
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected ? Border.all(color: kPrimaryColor, width: 1.5) : null,
                            ),
                            child: _StatItemWidget(
                              iconPath: metric.iconAssetPath,
                              label: metric.label,
                              isSelected: isSelected,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  20.0.heightbox,
                  Text(
                    currentMetric.key == 'motm' ? "Most MOTM Awards" :
                    currentMetric.key == 'cleanSheet' ? "Most Clean Sheets" :
                    "Top ${currentMetric.label}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ktextColor),
                  ),
                  10.0.heightbox,
                  Consumer(
                    builder: (context, ref, child) {
                      final leagueIdForApi = selectedLeague.id ?? ""; // selectedLeague is already watched and will be non-null here if logic above worked
                      
                      if (leagueIdForApi.isEmpty) { 
                        return Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text("League ID is missing or not yet selected.", style: TextStyle(color: ktextColor)),
                        ));
                      }

                      final leaderboardDataAsync = ref.watch(leaderboardDataProvider(
                        (leagueId: leagueIdForApi, metricKey: currentMetricKey),
                      ));

                      return leaderboardDataAsync.when(
                        data: (players) {
                          if (players.isEmpty) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text("No data available for ${currentMetric.label}.", style: TextStyle(color: ktextColor)),
                            ));
                          }
                          final topPlayersToDisplay = players.take(3).toList();

                          return Column(
                            children: List.generate(topPlayersToDisplay.length, (index) {
                              final player = topPlayersToDisplay[index];
                              final offsetPadding = [45.0, 60.0, 35.0]; 
                              final bottomOffset = [-10.0, 1.0, -8.0];
                              
                              String imageToDisplay = "assets/images/play${index + 1}.png";
                              bool isNetworkImg = false; 

                              return Padding(
                                padding: EdgeInsets.only(bottom: (index < offsetPadding.length ? offsetPadding[index] : 30.0)),
                                child: PlayerCard(
                                  name: player.name,
                                  position: player.positionType ?? "-",
                                  metricLabel: currentMetric.label, 
                                  metricValue: player.valueAsInt,   
                                  image: imageToDisplay,
                                  isNetwork: isNetworkImg, 
                                  imageBottomOffset: (index < bottomOffset.length ? bottomOffset[index] : 0.0),
                                ),
                              );
                            }),
                          );
                        },
                        loading: () => Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CircularProgressIndicator(),
                        )),
                        error: (e, stack) => Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text("Error: ${e.toString()}", style: TextStyle(color: Colors.red)),
                        )),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatItemWidget extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;

  const _StatItemWidget({
    required this.iconPath,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 35, height: 35, color: isSelected ? kPrimaryColor : null),
        5.0.heightbox,
        Text(
          label,
          style: TextStyle(
            fontSize: 10, 
            fontWeight: FontWeight.w600,
            color: isSelected ? kPrimaryColor : ktextColor, 
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
