// import 'package:champion_footballer/Utils/appextensions.dart';
// import '../../../../../../Utils/packages.dart';
// class LeaguesScreen extends StatelessWidget {
//   const LeaguesScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldCustom(
//       appBar: CustomAppBar(titleText: "Leagues"),
//       body: SingleChildScrollView(
//         padding: defaultPadding(vertical: 10),
//         child: Column(
//           children: [
//             StyledContainer(
//               onTap: () {
//                 context.route(MatchesScreen());
//               },
//               borderWidth: 3,
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(colors: [
//                 Color(0xFF00D09F),
//                 Color(0xFF00A77F),
//               ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
//               borderColor: kPrimaryColor,
//               padding: defaultPadding(vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "National Football League",
//                     style: TextStyle(
//                       color: kdefwhiteColor,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   4.0.heightbox,
//                   Text(
//                     "2 matches available.\n3 Players\nCreated on Saturday, 9 November 2024 at 15:05",
//                     style: TextStyle(
//                         color: kdefwhiteColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   12.0.heightbox,
//                   Row(
//                     children: [
//                       Text("Invite Players",
//                           style: TextStyle(
//                             color: kdefwhiteColor,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                           )),
//                       10.0.widthbox,
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: kdefwhiteColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             Text("2WR5KZ",
//                                 style: TextStyle(
//                                     color: kdefblackColor,
//                                     fontSize: 12,
//                                     decoration: TextDecoration.underline,
//                                     fontWeight: FontWeight.w600)),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                                 onTap: () {
//                                   Clipboard.setData(
//                                       ClipboardData(text: "2WR5KZ"));
//                                 },
//                                 child: Image.asset(
//                                   AppImages.copy,
//                                   width: 15,
//                                   height: 15,
//                                   color: kdefblackColor,
//                                 )),
//                           ],
//                         ),
//                       ),
//                       Spacer(),
//                       GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               "assets/icons/invite.png",
//                               width: 25,
//                               height: 25,
//                             ),
//                             10.0.widthbox,
//                             Image.asset(
//                               AppImages.forwadarrow,
//                               width: 15,
//                               height: 15,
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             16.0.heightbox,
//             StyledContainer(
//               borderRadius: BorderRadius.circular(16),
//               borderColor: kPrimaryColor.withValues(alpha: .5),
//               child: ListTile(
//                 title: Text(
//                   "Hangin With My Mahomies",
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
//                 ),
//                 subtitle: Text(
//                   "2 matches available.\n3 Players\nCreated on Saturday, 9 November 2024 at 15:05",
//                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
//                 ),
//                 trailing: Image.asset(
//                   AppImages.forwadarrow,
//                   width: 15,
//                   height: 15,
//                   color: kPrimaryColor,
//                 ),
//               ),
//             ),
//             20.0.heightbox,
//             StyledContainer(
//               borderRadius: BorderRadius.circular(16),
//               borderColor: kPrimaryColor.withValues(alpha: .5),
//               child: ListTile(
//                   title: Text(
//                     "Any Given Sunday",
//                     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
//                   ),
//                   subtitle: Text(
//                     "2 matches available.\n3 Players\nCreated on Saturday, 9 November 2024 at 15:05",
//                     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
//                   ),
//                   trailing: Image.asset(
//                     AppImages.forwadarrow,
//                     width: 15,
//                     height: 15,
//                     color: kPrimaryColor,
//                   )),
//             ),
//             20.0.heightbox,
//             StyledContainer(
//               borderRadius: BorderRadius.circular(16),
//               borderColor: kPrimaryColor.withValues(alpha: .5),
//               child: ListTile(
//                 title: Text(
//                   "Victorious Secret",
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
//                 ),
//                 subtitle: Text(
//                   "2 matches available.\n3 Players\nCreated on Saturday, 9 November 2024 at 15:05",
//                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
//                 ),
//                 trailing: Image.asset(
//                   AppImages.forwadarrow,
//                   width: 15,
//                   height: 15,
//                   color: kPrimaryColor,
//                 ),
//               ),
//             ),
//             20.0.heightbox,
//             StyledContainer(
//               borderRadius: BorderRadius.circular(16),
//               borderColor: kPrimaryColor.withValues(alpha: .5),
//               child: ListTile(
//                 title: Text(
//                   "Justice League",
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
//                 ),
//                 subtitle: Text(
//                   "2 matches available.\n3 Players\nCreated on Saturday, 9 November 2024 at 15:05",
//                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
//                 ),
//                 trailing: Image.asset(
//                   "assets/icons/check.png",
//                   width: 20,
//                   height: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/*import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../Utils/packages.dart';

class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaguesAsync = ref.watch(userDataProvider);

    return ScaffoldCustom(
      appBar: CustomAppBar(titleText: "Leagues"),
      body: leaguesAsync.when(
        data: (user) {
          final leagues = user.leagues ?? [];

          for (var league in leagues) {
            league.members ??= [];
          }

          if (leagues.isEmpty) {
            return Center(child: Text("No leagues found"));
          }
          return ListView.separated(
            padding: defaultPadding(vertical: 10),
            itemCount: leagues.length,
            separatorBuilder: (_, __) => 16.0.heightbox,
            itemBuilder: (context, index) {
              final league = leagues[index];
              return StyledContainer(
                borderRadius: BorderRadius.circular(20),
                borderColor: kPrimaryColor,
                padding: defaultPadding(vertical: 10),
                gradient: LinearGradient(
                  colors: [Color(0xFF00D09F), Color(0xFF00A77F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(league.name ?? "League Name",
                        style: TextStyle(
                          color: kdefwhiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        )),
                    SizedBox(height: 4),
                    Text(
                      "${league.matches?.length ?? 0} matches available.\n"
                      "${league.members?.length ?? 0} Players\n"
                      "Created on ${league.createdAt != null ? DateFormat('EEEE, d MMMM yyyy – kk:mm').format(league.createdAt!) : 'Unknown'}",
                      style: TextStyle(),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text("Invite Players",
                            style: TextStyle(
                              color: kdefwhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(width: 10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: kdefwhiteColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(league.inviteCode ?? "Invite Code",
                                  style: TextStyle(
                                    color: kdefblackColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: league.inviteCode ?? ""));
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.fillColored,
                                    title: Text(
                                        "Invite code copied: ${league.inviteCode ?? 'N/A'}"),
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
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            ref.read(selectedLeagueProvider.notifier).state =
                                league;
                            context.route(const MatchesScreen());
                          },
                          child: Row(
                            children: [
                              Image.asset("assets/icons/invite.png",
                                  width: 25, height: 25),
                              SizedBox(width: 10),
                              Image.asset(AppImages.forwadarrow,
                                  width: 20, height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}*/

import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Settings/setting.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../Utils/packages.dart';

class LeaguesScreen extends ConsumerStatefulWidget {
  const LeaguesScreen({super.key});

  @override
  ConsumerState<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends ConsumerState<LeaguesScreen> {
  @override
  Widget build(BuildContext context) {
    final leaguesAsync = ref.watch(userDataProvider);

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Leagues",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1), // orange
            Color.fromRGBO(207, 35, 38, 1),  // red
          ],
        ),
      ),
      body: leaguesAsync.when(
        data: (user) {
          final leagues = user.leagues ?? [];
          if (leagues.isEmpty) return const Center(child: Text("No leagues found"));

          return ListView.separated(
            padding: defaultPadding(vertical: 10),
            itemCount: leagues.length,
            separatorBuilder: (_, __) => 16.0.heightbox,
            itemBuilder: (context, index) {
              final league = leagues[index];
              league.members ??= [];

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
                    // 🔹 Top row with League name + settings icon
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
                          onTap: () {
                            ref.read(selectedLeagueProvider.notifier).state = league;
                            context.route(const LeagueSetting());
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
                            context.route(const MatchesScreen());
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}



// import 'package:champion_footballer/Utils/appextensions.dart';
// import 'package:champion_footballer/Views/Home/Screens/Tables/tablesscreen.dart';
// import 'package:intl/intl.dart';
// import 'package:toastification/toastification.dart';
// import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
// import '../../../../../../Utils/packages.dart';
//
// class LeaguesScreen extends ConsumerStatefulWidget {
//   const LeaguesScreen({super.key});
//
//   @override
//   ConsumerState<LeaguesScreen> createState() => _LeaguesScreenState();
// }
//
// class _LeaguesScreenState extends ConsumerState<LeaguesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final leaguesAsync = ref.watch(userDataProvider);
//     final selectedLeague = ref.watch(selectedLeagueProvider);
//
//     return ScaffoldCustom(
//       appBar: CustomAppBar(
//         titleText: "Leagues",
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color.fromRGBO(229, 106, 22, 1),
//             Color.fromRGBO(207, 35, 38, 1),
//           ],
//         ),
//       ),
//       body: leaguesAsync.when(
//         data: (user) {
//           final leagues = user.leagues ?? [];
//           if (leagues.isEmpty) {
//             return const Center(child: Text("No leagues found"));
//           }
//
//           return SingleChildScrollView(
//             padding: defaultPadding(vertical: 10, horizontal: 16),
//             child: Column(
//               children: [
//                 ListView.separated(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: leagues.length,
//                   separatorBuilder: (_, __) => 16.0.heightbox,
//                   itemBuilder: (context, index) {
//                     final league = leagues[index];
//                     final isSelected = league == selectedLeague;
//
//                     if (isSelected) {
//                       // 🔥 Highlighted card (without Table & Award buttons)
//                       return StyledContainer(
//                         borderRadius: BorderRadius.circular(20),
//                         borderColor: kPrimaryColor,
//                         padding: const EdgeInsets.all(16),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF00D09F), Color(0xFF00A77F)],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     league.name ?? "League Name",
//                                     style: const TextStyle(
//                                       color: kdefwhiteColor,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ),
//                                 Image.asset("assets/icons/invite.png", width: 30, height: 30),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "${league.matches?.length ?? 0} matches available.\n"
//                                   "${league.members?.length ?? 0} Players\n"
//                                   "Created on ${league.createdAt != null ? DateFormat('EEEE, d MMMM yyyy at kk:mm').format(league.createdAt!) : 'Unknown'}",
//                               style: const TextStyle(
//                                 color: kdefwhiteColor,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: IconButton(
//                                 onPressed: () {
//                                   ref.read(selectedLeagueProvider.notifier).state = league;
//                                   context.route(const LeagueSettings());
//                                 },
//                                 icon: const Icon(Icons.settings, color: kdefwhiteColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       // ⚪ Normal white card
//                       return InkWell(
//                         onTap: () {
//                           ref.read(selectedLeagueProvider.notifier).state = league;
//                         },
//                         child: StyledContainer(
//                           borderRadius: BorderRadius.circular(16),
//                           borderColor: kPrimaryColor.withOpacity(0.06),
//                           padding: const EdgeInsets.all(12),
//                           child: ListTile(
//                             contentPadding: EdgeInsets.zero,
//                             title: Text(
//                               league.name ?? "League Name",
//                               style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
//                             ),
//                             subtitle: Text(
//                               "${league.matches?.length ?? 0} matches available.\n"
//                                   "${league.members?.length ?? 0} Players\n"
//                                   "Created on ${league.createdAt != null ? DateFormat('EEEE, d MMMM yyyy at kk:mm').format(league.createdAt!) : 'Unknown'}",
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                             trailing: Image.asset(
//                               "assets/icons/invite.png",
//                               width: 30,
//                               height: 30,
//                               color: kPrimaryColor,
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//       ),
//     );
//   }
// }
