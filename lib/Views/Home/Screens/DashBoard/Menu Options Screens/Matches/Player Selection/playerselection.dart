import 'dart:math';

import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Team%20Preview/teamprieview.dart';

import '../../../../../../../Utils/packages.dart';

class SelectPlayersScreen extends StatefulWidget {
  const SelectPlayersScreen({super.key});

  @override
  SelectPlayersScreenState createState() => SelectPlayersScreenState();
}

class SelectPlayersScreenState extends State<SelectPlayersScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController guestPlayerController = TextEditingController();
  TextEditingController homeTeamController = TextEditingController();
  TextEditingController awayTeamController = TextEditingController();

  double teamBalance = 90.0;

  List<Map<String, String>> players = [
    {"name": "Harry Kane", "position": "MD", "image": AppImages.profilepic},
    {"name": "Joy Arther", "position": "MD", "image": AppImages.ronaldo},
    {"name": "Elen Roy", "position": "SK", "image": AppImages.profilepic},
    {"name": "Lionel Messi", "position": "DF", "image": AppImages.ronaldo},
    {"name": "Neymar Jr", "position": "GK", "image": AppImages.profilepic},
    {"name": "Xavi", "position": "MD", "image": AppImages.ronaldo},
    {
      "name": "Zlatan Ibrahimovic",
      "position": "MD",
      "image": AppImages.profilepic
    },
    {"name": "Yaya Toure", "position": "SK", "image": AppImages.ronaldo},
    {"name": "Willian", "position": "DF", "image": AppImages.profilepic},
    {"name": "Juan Mata", "position": "GK", "image": AppImages.ronaldo},
  ];
  List<Map<String, String>> homePlayers = [];
  List<Map<String, String>> awayPlayers = [];

  @override
  void initState() {
    super.initState();
    _assignInitialTeams();
  }

  void _assignInitialTeams() {
    setState(() {
      int mid = players.length ~/ 2;
      homePlayers = players.sublist(0, mid);
      awayPlayers = players.sublist(mid);

      teamBalance = (homePlayers.length / players.length) * 100;
    });
  }

  void shuffleTeams() {
    setState(() {
      List<Map<String, String>> shuffledPlayers = List.from(players);
      shuffledPlayers.shuffle(Random());

      int mid = shuffledPlayers.length ~/ 2;
      homePlayers = shuffledPlayers.sublist(0, mid);
      awayPlayers = shuffledPlayers.sublist(mid);

      teamBalance = (homePlayers.length / players.length) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      // appBar: CustomAppBar(titleText: "Select Players"),
      appBar: CustomAppBar(
        titleText: "Select Players",
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
            // Instruction Text
            StyledContainer(
              padding: defaultPadding(vertical: 10),
              borderColor: kPrimaryColor.withValues(alpha: .5),
              boxShadow: [],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Drag Players To Teams:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.0.heightbox,

                  // Search Players Field
                  PrimaryTextField(
                    controller: searchController,
                    hintText: "Search Players",
                    bordercolor: kPrimaryColor.withValues(alpha: .5),
                  ),

                  15.0.heightbox,

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kPrimaryColor.withValues(alpha: .5),
                              width: 1.5,
                            ),
                            color: kdefwhiteColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              topLeft: Radius.circular(6),
                            ),
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: ktextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: kdefgreyColor,
                            cursorHeight: 20,
                            controller: guestPlayerController,
                            decoration: InputDecoration(
                              hintText: "Add Guest Player",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: ktexthintColor.withValues(alpha: .6),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        width: 110,
                        onPressFunction: () {},
                        buttonText: "Add",
                        radius: BorderRadius.only(
                          bottomRight: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        fontSize: 12,
                      ),
                    ],
                  ),
                  20.0.heightbox,

                  // Players Grid
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 0.37,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return Column(
                          children: [
                            Text(
                              player["position"]!,
                              style: TextStyle(
                                color: ktextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),

                            Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: kdefwhiteColor,
                                // border: Border.all(color: kPrimaryColor, width: 2),
                                image: DecorationImage(
                                  image: AssetImage(player["image"]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // child: Image.asset(
                              //   player["image"]!,
                              //   fit: BoxFit.cover,
                              // ),
                            ),

                            // Player Name
                            Text(
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              player["name"]!,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  Text(
                    "Players Appear In The Order They Confirmed Availability",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            20.0.heightbox,

            StyledContainer(
              padding: defaultPadding(vertical: 10),
              borderColor: kPrimaryColor.withValues(alpha: .5),
              boxShadow: [],
              child: Column(
                children: [
                  Text(
                    "${players.length} Players Added",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.0.heightbox,
                  StyledContainer(
                    padding: defaultPadding(vertical: 5),
                    borderColor: kPrimaryColor.withValues(alpha: .5),
                    boxShadow: [],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Home Team",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ktextColor,
                          ),
                        ),
                        Text(
                          "Away Team",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ktextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.0.heightbox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        AppImages.user,
                        color: kPrimaryColor,
                        width: 30,
                        height: 30,
                      ),
                      5.0.widthbox,
                      PrimaryButton(
                        width: context.width / 2.5,
                        onPressFunction: shuffleTeams,
                        buttonText: "Shuffle",
                        fontSize: 14,
                      ),
                      5.0.widthbox,
                      Image.asset(
                        AppImages.user,
                        color: Color(0xFF007499),
                        width: 35,
                        height: 35,
                      ),
                    ],
                  ),
                  10.0.heightbox,
                  Text("Team Balance is ${teamBalance.toInt()}%",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  10.0.heightbox,
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: StyledContainer(
                  //         padding: const EdgeInsets.all(15),
                  //         boxShadow: [],
                  //         borderColor: kPrimaryColor.withValues(alpha: .5),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             const Text(
                  //               '<6 Players In>',
                  //               style: TextStyle(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             const15.0.heightbox,
                  //             SizedBox(
                  //               height: 170,
                  //               child: SingleChildScrollView(
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     _buildPlayer(
                  //                         AppImages.profilepic, "Harry Kane"),
                  //                     _buildPlayer(AppImages.ronaldo, "Messi"),
                  //                     _buildPlayer(
                  //                         AppImages.profilepic, "Elen Roy"),
                  //                     _buildPlayer(
                  //                         AppImages.ronaldo, "John Doe"),
                  //                     _buildPlayer(
                  //                         AppImages.profilepic, "David Warner"),
                  //                     _buildPlayer(
                  //                         AppImages.ronaldo, "Chris Paul"),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     10.0.widthbox,
                  //     Expanded(
                  //       child: StyledContainer(
                  //         padding: const EdgeInsets.all(15),
                  //         boxShadow: [],
                  //         borderColor: kPrimaryColor.withValues(alpha: .5),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             const Text(
                  //               '<6 Players In>',
                  //               style: TextStyle(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             const15.0.heightbox,
                  //             SizedBox(
                  //               height: 170,
                  //               child: SingleChildScrollView(
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     _buildPlayer(
                  //                         AppImages.profilepic, "Ronaldo"),
                  //                     _buildPlayer(
                  //                         AppImages.ronaldo, "Joy Arther"),
                  //                     _buildPlayer(
                  //                         AppImages.profilepic, "Nyemar"),
                  //                     _buildPlayer(AppImages.ronaldo, "Lionel"),
                  //                     _buildPlayer(
                  //                         AppImages.profilepic, "Mbappe"),
                  //                     _buildPlayer(AppImages.ronaldo, "Xavi"),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTeamContainer("Home Team", homePlayers),
                      ),
                      10.0.widthbox,
                      Expanded(
                        child: _buildTeamContainer("Away Team", awayPlayers),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            10.0.heightbox,
            GestureDetector(
              onTap: () {
                context.route(TeamPreviewScreen());
              },
              child: Center(
                child: Text(
                  "Preview",
                  style: TextStyle(
                    fontSize: 14,
                    color: ktextColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            10.0.heightbox,
            PrimaryButton(
              buttonText: "Save Teams",
              onPressFunction: () {},
            ),
            20.0.heightbox,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamContainer(
      String title, List<Map<String, String>> teamPlayers) {
    return StyledContainer(
      padding: const EdgeInsets.all(15),
      boxShadow: [],
      borderColor: kPrimaryColor.withValues(alpha: .5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "<${teamPlayers.length} Players In>",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          15.0.heightbox,
          SizedBox(
            height: 170,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: teamPlayers.map((player) {
                  return _buildPlayer(player["image"]!, player["name"]!);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 15,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
