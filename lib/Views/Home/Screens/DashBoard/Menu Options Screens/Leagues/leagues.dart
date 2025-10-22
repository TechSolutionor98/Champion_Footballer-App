import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Leagues/leaguesmatch.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Settings/setting.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../Utils/packages.dart';
// Assuming LeaguesJoined is available, possibly from usermodel.dart or directly if userStatusLeaguesProvider provides it typed.
// import '../../../../../../Model/Api Models/usermodel.dart'; // Ensure LeaguesJoined is accessible

class LeaguesScreen extends ConsumerStatefulWidget {
  const LeaguesScreen({super.key});

  @override
  ConsumerState<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends ConsumerState<LeaguesScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch userDataProvider to get fresh data
    final userAsync = ref.watch(userDataProvider);

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Leagues",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: userAsync.when(
        data: (user) {
          final leaguesList = user.leagues ?? [];
          
          // If no leagues, show message
          if (leaguesList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No leagues found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Allow pull-to-refresh
              ref.invalidate(userDataProvider);
            },
            child: ListView.separated(
              padding: defaultPadding(vertical: 10),
              itemCount: leaguesList.length,
              separatorBuilder: (_, __) => 16.0.heightbox,
              itemBuilder: (context, index) {
                final league = leaguesList[index];

                return StyledContainer(
                  borderRadius: BorderRadius.circular(20),
                  borderColor: kPrimaryColor,
                  padding: defaultPadding(vertical: 10, horizontal: 12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D09F), Color(0xFF00A77F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              league.name ?? "League Name",
                              style: const TextStyle(
                                color: kdefwhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              ref.read(selectedLeagueProvider.notifier).state = league;
                              
                              // Navigate and wait for result
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LeagueSetting()),
                              );
                              
                              // If result is true (league was left), refresh the data
                              if (mounted && result == true) {
                                ref.invalidate(userDataProvider);
                                ref.invalidate(userStatusLeaguesProvider);
                              }
                            },
                            child: const Icon(Icons.settings, color: kdefwhiteColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${league.matches?.length ?? 0} matches available.\n"
                            "${league.members?.length ?? 0} Players\n"
                            "Created on ${league.createdAt != null ? DateFormat('EEEE, d MMMM yyyy – kk:mm').format(league.createdAt!) : 'Unknown'}",
                        style: const TextStyle(color: kdefwhiteColor, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            "Invite Players",
                            style: TextStyle(
                              color: kdefwhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: kdefwhiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  league.inviteCode ?? "Invite Code",
                                  style: const TextStyle(
                                    color: kdefblackColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: league.inviteCode ?? ""),
                                    );
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.fillColored,
                                      title: Text("Invite code copied: ${league.inviteCode ?? 'N/A'}"),
                                      autoCloseDuration: const Duration(seconds: 2),
                                    );
                                  },
                                  child: Image.asset(
                                    AppImages.copy,
                                    color: kdefblackColor,
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ref.read(selectedLeagueProvider.notifier).state = league;
                              context.route(const MatchScreen());
                            },
                            child: Row(
                              children: [
                                Image.asset("assets/icons/invite.png", width: 25, height: 25),
                                const SizedBox(width: 10),
                                Image.asset(AppImages.forwadarrow, width: 20, height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Error: $e",
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}