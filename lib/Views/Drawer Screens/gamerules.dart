// import 'package:champion_footballer/Utils/appextensions.dart';
// import '../../Utils/packages.dart';

// class GameRulesScreen extends StatelessWidget {
//   GameRulesScreen({super.key});
//   final items = [
//     'Play Fair',
//     'Play Safe',
//     'Show Respect',
//     'Play As a Team',
//     'Commit To Play',
//     'Pick Balance Teams',
//     'Rise To the Challenge',
//     'Have fun!',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldCustom(
//       appBar: CustomAppBar(titleText: "Game Rules"),
//       body: Padding(
//         padding: defaultPadding(vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             StyledContainer(
//               borderColor: kPrimaryColor,
//               padding: defaultPadding(vertical: 5),
//               child: Center(
//                 child: Text(
//                   'Characteristics of a champion',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,,
//                     color: ktextColor,
//                   ),
//                 ),
//               ),
//             ),
//             15.0.heightbox,
//             StyledContainer(
//               borderColor: kPrimaryColor,
//               padding: defaultPadding(horizontal: 10, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: items.map((text) {
//                   return Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.circle,
//                         color: kPrimaryColor,
//                         size: 20,
//                       ),
//                       8.0.widthbox,
//                       Text(
//                         text,
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.w600,
//                             color: ktextColor),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             20.0.heightbox,
//             StyledContainer(
//               borderColor: kPrimaryColor,
//               padding: defaultPadding(vertical: 5),
//               child: Center(
//                 child: Text(
//                   'Characteristics of a Champion',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,,
//                     color: ktextColor,
//                   ),
//                 ),
//               ),
//             ),
//             15.0.heightbox,
//             StyledContainer(
//               padding: defaultPadding(vertical: 10, horizontal: 0),
//               borderColor: kPrimaryColor,
//               child: Center(
//                 child: Column(
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'C',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'ourageous',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'H',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'opeful',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'A',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'ppreciative',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'M',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'odest',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'C',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'ourageous',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'P',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'erseverant',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'I',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'nspired',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'O',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'ptimistic',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 3),
//                       height: 2,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade100,
//                             Colors.green.shade400,
//                             Colors.green.shade100,
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'N',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 26,
//                                 color: ktextColor,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextSpan(
//                             text: 'oble',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: ktextColor,
//                                 fontFamily: "Inter",
//                                 fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

class GameRulesScreen extends StatelessWidget {
  const GameRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(titleText: 'Game Rules'),
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          children: [
            // Small Container with "Video coming soon" text
            StyledContainer(
              width: context.width / 2,
              padding: EdgeInsets.all(5),
              child: Center(
                child: Text(
                  'Video coming soon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ),
            20.0.heightbox,
            // Heading 1 with description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Team-Based Points Winning Team:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                08.0.heightbox,
                StyledContainer(
                  boxShadow: [],
                  padding: defaultPadding(vertical: 10),
                  borderColor: kPrimaryColor.withValues(alpha: .5),
                  child: Text(
                    'Each player on the winning team earns 10 points. \nDraw: Each player on both teams earns 5 points. \nLosing Team: Each player on the losing team earns 2 points.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ktextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            20.0.heightbox,
            // Heading 2 with description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2. Individual Performance Points:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                08.0.heightbox,
                StyledContainer(
                  width: context.width,
                  boxShadow: [],
                  padding: defaultPadding(vertical: 10),
                  borderColor: kPrimaryColor.withValues(alpha: .5),
                  child: Text(
                    'Goals Scored: +3 points per goal. \nAssists: +2 points per assist. \nClean Sheet: +3 points',
                    style: TextStyle(
                        fontSize: 16,
                        color: ktextColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            20.0.heightbox,
            // Heading 3 with description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3. Penalties/Deductions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                08.0.heightbox,
                StyledContainer(
                  boxShadow: [],
                  padding: defaultPadding(vertical: 10),
                  borderColor: kPrimaryColor.withValues(alpha: .5),
                  child: Text(
                    'Penalty - 5 point (Poor sportsmanship - decided jointly by both captains)',
                    style: TextStyle(
                        fontSize: 16,
                        color: ktextColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            20.0.heightbox,
            // Heading 4 with description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4. Bonus Points:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                08.0.heightbox,
                StyledContainer(
                  boxShadow: [],
                  padding: defaultPadding(vertical: 10),
                  borderColor: kPrimaryColor.withValues(alpha: .5),
                  child: Text(
                    'Player of the Match votes: +2 points per vote (chosen by player votes). \nHat-Trick: +3 points. \nSignificant Defensive Action: +3 points (awarded for a crucial defensive play such as a goal-line clearance or key tackle, or a decisive save by a goal keeper chosen by the team\'s captain).',
                    style: TextStyle(
                        fontSize: 16,
                        color: ktextColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            20.0.heightbox,
          ],
        ),
      ),
    );
  }
}
