// import '../Utils/packages.dart';

// class PositionRadioTile extends StatelessWidget {
//   final String title;
//   final String value;
//   final String groupValue;
//   final Function(String?) onChanged;

//   const PositionRadioTile({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RadioListTile<String>(
//       dense: true,
//       contentPadding: EdgeInsets.zero,
//       title: Text(
//         title,
//         style: TextStyle(
//           color: ktextColor,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       value: value,
//       groupValue: groupValue,
//       onChanged: onChanged,
//     );
//   }
// }