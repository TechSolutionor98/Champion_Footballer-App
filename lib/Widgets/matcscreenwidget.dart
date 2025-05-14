// import '../Utils/packages.dart';

// class MatchCard extends StatelessWidget {
//   final String match;
//   final String score;
//   final bool highlighted;
//   final bool bold;

//   const MatchCard(
//       {super.key,
//       required this.match,
//       required this.score,
//       this.highlighted = false,
//       this.bold = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       decoration: BoxDecoration(
//         color: highlighted ? Color(0xFFFFC7CE) : Colors.transparent,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         "$match: $score",
//         style: TextStyle(
//             fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//             color: Colors.black),
//       ),
//     );
//   }
// }