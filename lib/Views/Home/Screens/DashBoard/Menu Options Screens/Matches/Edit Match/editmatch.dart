/*import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Player%20Selection/playerselection.dart';
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import 'package:intl/intl.dart';

class EditMatchScreen extends StatefulWidget {
  const EditMatchScreen({super.key});

  @override
  EditMatchScreenState createState() => EditMatchScreenState();
}

class EditMatchScreenState extends State<EditMatchScreen> {
  TextEditingController homeTeamController = TextEditingController();
  TextEditingController awayTeamController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController matchNoteController = TextEditingController();

  bool isNoteFieldVisible = false;

  DateTime _selectedDate = DateTime.now();
  // TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 30);
  int _selectedHour = 9;
  int _selectedMinute = 30;
  bool isPM = true; // Toggle between AM & PM
  int _selectedHours = 1;
  int _selectedMinutes = 40;

  String _calculateFinishTime() {
    final matchStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      // _selectedTime.hour,
      // _selectedTime.minute,
    );

    final matchEnd = matchStart
        .add(Duration(hours: _selectedHours, minutes: _selectedMinutes));

    return DateFormat('hh:mm a').format(matchEnd);
  }

  int homeGoals = 0;
  int awayGoals = 0;
  final List<Map<String, String>> homePlayers = [
    {"number": "03", "name": "John"},
    {"number": "05", "name": "Eric"},
  ];

  final List<Map<String, String>> awayPlayers = [
    {"number": "02", "name": "Wedi"},
    {"number": "07", "name": "Terq"},
  ];
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      // appBar: CustomAppBar(titleText: "Edit Match"),
      appBar: CustomAppBar(
        titleText: "Edit Match",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1), // orange
            Color.fromRGBO(207, 35, 38, 1),  // red
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamSection(
                "Home Team", homeTeamController, homeGoals, homePlayers, true),
            20.0.heightbox,
            _buildTeamSection(
                "Away Team", awayTeamController, awayGoals, awayPlayers, false),
            20.0.heightbox,
            ButtonWithIcon(
              buttonColor: kblueColor,
              buttonText: "Select Player",
              leadingWidget: Icon(
                Icons.group,
                color: kdefwhiteColor,
              ),
              onPressFunction: () {
                context.route(SelectPlayersScreen());
              },
            ),
            20.0.heightbox,
            Text("Match Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ktextColor,
                )),
            10.0.heightbox,
            StyledContainer(
              padding: EdgeInsets.all(10),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // START TIME SECTION
                  Text("Start Time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  10.0.heightbox,
                  // Inline Calendar View
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: defaultBorderRadious,
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200, // Soft grey shadow
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 1), // Slight elevation
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: kPrimaryColor,
                              onPrimary: kPrimaryColor,
                              onSurface: ktextColor,
                            ),
                            textTheme: TextTheme(
                              bodyLarge: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ktextColor,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            currentDate:
                                _selectedDate, // Ensures selected date is highlighted
                            selectableDayPredicate: (DateTime val) => true,
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 0.8,
                          color: Colors.grey.shade400,
                        ),

                        // Time Selection
                        // Display selected date
                        Text(
                          DateFormat('EEE  MMM d  yyyy')
                              .format(_selectedDate)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        ),
                        10.0.heightbox,
                        Padding(
                          padding: defaultPadding(vertical: 5, horizontal: 5),
                          child:
                              // Time selection (Hour, Minute, AM/PM)
                              Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 20,
                              ),
                              10.0.widthbox,
                              // Hours Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                  value: _selectedHour,
                                  underline: SizedBox(),
                                  items: List.generate(12, (index) => index + 1)
                                      .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            "$e",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ktextColor,
                                              fontSize: 14,
                                            ),
                                          )))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedHour = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),

                              // Minutes Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.grey.shade700),
                                  value: _selectedMinute,
                                  underline: SizedBox(),
                                  items: List.generate(60, (index) => index)
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e.toString().padLeft(2, '0'),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: ktextColor,
                                                  fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMinute = value!;
                                    });
                                  },
                                ),
                              ),
                              Spacer(),

                              // AM/PM Selection
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? Color(0xFFEDF2F7)
                                              : kPrimaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            topLeft: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "AM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? kPrimaryColor
                                              : Color(0xFFEDF2F7),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "PM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  20.0.heightbox,

                  // MATCH DURATION SECTION
                  Text("Match Duration",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  15.0.heightbox,

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hours",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              // isDense: true,
                              value: _selectedHours,
                              underline: SizedBox(),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              items: List.generate(12, (index) => index + 1)
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          "$e",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ktextColor,
                                              fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedHours = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      20.0.widthbox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Minutes",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              value: _selectedMinutes,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              underline: SizedBox(),
                              items: List.generate(60, (index) => index)
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.toString().padLeft(2, '0'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ktextColor,
                                              fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMinutes = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // Finish Time Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Match will last for $_selectedHours hours and $_selectedMinutes minutes.\nFinish time is ${_calculateFinishTime()}",
                style: TextStyle(
                    color: kdefwhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),

            20.0.heightbox,

            // LOCATION INPUT
            Text("Location",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ktextColor)),

            PrimaryTextField(
              controller: locationController,
              hintText: "e.g. Power league",
              labelText: '',
              bordercolor: kPrimaryColor.withValues(alpha: 0.5),
            ),

            20.0.heightbox,
            // Match Note Section
            GestureDetector(
              onTap: () {
                setState(() {
                  isNoteFieldVisible = !isNoteFieldVisible;
                });
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kblueColor,
                    ),
                    child: Icon(
                      isNoteFieldVisible ? Icons.remove : Icons.add,
                      color: kdefwhiteColor,
                      size: 20,
                    ),
                  ),
                  5.0.widthbox,
                  Text(
                    "Match Note",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ktextColor),
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // Match Note Text Field (Shown on tap)
            if (isNoteFieldVisible)
              PrimaryTextField(
                controller: matchNoteController,
                hintText: "Write your notes here...",
                labelText: '',
                bordercolor: kPrimaryColor.withValues(alpha: .5),
                maxLines: 5,
              ),

            20.0.heightbox,
            // SAVE BUTTON
            PrimaryButton(
              onPressFunction: () {
                // Save Match
                Navigator.pop(context);
              },
              buttonText: "Save Match",
            ),

            10.0.heightbox,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(String title, TextEditingController controller,
      int goals, List<Map<String, String>> players, bool isHome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        10.0.heightbox,
        StyledContainer(
          boxShadow: [],
          padding: EdgeInsets.all(10),
          borderColor: kPrimaryColor.withValues(alpha: 0.5),
          child: Column(
            children: [
              PrimaryTextField(
                height: 35,
                controller: controller,
                hintText: "Change Team Name",
                hintfontSize: 14,
                bordercolor: kdefgreyColor.withValues(alpha: .5),
              ),
              10.0.heightbox,
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          if (homeGoals > 0) homeGoals--;
                        } else {
                          if (awayGoals > 0) awayGoals--;
                        }
                      });
                    },
                  ),
                  Text(
                    "$goals",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          homeGoals++;
                        } else {
                          awayGoals++;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  Text("Goals",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Row(
                      children: players.map((player) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _buildPlayerAvatar(
                            player["number"]!,
                            player["name"]!,
                            isHome ? AppImages.shirt : AppImages.awayshirt,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerAvatar(String number, String name, String shirtImage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              shirtImage,
              width: 30, // Adjust size as needed
              height: 30,
              fit: BoxFit.contain,
            ),
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
                // shadows: [
                //   Shadow(
                //     color: Colors.black.withValues(alpha: .6),
                //     offset: Offset(1, 1),
                //     blurRadius: 2,
                //   ),
                // ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Player%20Selection/playerselection.dart';
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../Services/RiverPord Provider/ref_provider.dart';


class EditMatchScreen extends StatefulWidget {
  final String matchId;
  final String leagueId;

  const EditMatchScreen({
    Key? key,
    required this.matchId,
    required this.leagueId,
  }) : super(key: key);

  @override
  EditMatchScreenState createState() => EditMatchScreenState();
}

class EditMatchScreenState extends State<EditMatchScreen> {
  TextEditingController homeTeamController = TextEditingController();
  TextEditingController awayTeamController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController matchNoteController = TextEditingController();

  bool isNoteFieldVisible = false;

  DateTime _selectedDate = DateTime.now();
  // TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 30);
  int _selectedHour = 9;
  int _selectedMinute = 30;
  bool isPM = true; // Toggle between AM & PM
  int _selectedHours = 1;
  int _selectedMinutes = 40;



  String _calculateFinishTime() {
    final matchStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      // _selectedTime.hour,
      // _selectedTime.minute,
    );

    final matchEnd = matchStart
        .add(Duration(hours: _selectedHours, minutes: _selectedMinutes));

    return DateFormat('hh:mm a').format(matchEnd);
  }

  int homeGoals = 0;
  int awayGoals = 0;
  final List<Map<String, String>> homePlayers = [
    {"number": "03", "name": "John"},
    {"number": "05", "name": "Eric"},
  ];

  final List<Map<String, String>> awayPlayers = [
    {"number": "02", "name": "Wedi"},
    {"number": "07", "name": "Terq"},
  ];
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      // appBar: CustomAppBar(titleText: "Edit Match"),
      appBar: CustomAppBar(
        titleText: "Edit Match",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1), // orange
            Color.fromRGBO(207, 35, 38, 1), // red
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamSection(
                "Home Team", homeTeamController, homeGoals, homePlayers, true),
            20.0.heightbox,
            _buildTeamSection(
                "Away Team", awayTeamController, awayGoals, awayPlayers, false),
            20.0.heightbox,
            ButtonWithIcon(
              buttonColor: kblueColor,
              buttonText: "Select Player",
              leadingWidget: Icon(
                Icons.group,
                color: kdefwhiteColor,
              ),
              onPressFunction: () {
                context.route(SelectPlayersScreen());
              },
            ),
            20.0.heightbox,
            Text("Match Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ktextColor,
                )),
            10.0.heightbox,
            StyledContainer(
              padding: EdgeInsets.all(10),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // START TIME SECTION
                  Text("Start Time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  10.0.heightbox,
                  // Inline Calendar View
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: defaultBorderRadious,
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200, // Soft grey shadow
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 1), // Slight elevation
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: kPrimaryColor,
                              onPrimary: kPrimaryColor,
                              onSurface: ktextColor,
                            ),
                            textTheme: TextTheme(
                              bodyLarge: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ktextColor,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            currentDate:
                            _selectedDate, // Ensures selected date is highlighted
                            selectableDayPredicate: (DateTime val) => true,
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 0.8,
                          color: Colors.grey.shade400,
                        ),

                        // Time Selection
                        // Display selected date
                        Text(
                          DateFormat('EEE  MMM d  yyyy')
                              .format(_selectedDate)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        ),
                        10.0.heightbox,
                        Padding(
                          padding: defaultPadding(vertical: 5, horizontal: 5),
                          child:
                          // Time selection (Hour, Minute, AM/PM)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 20,
                              ),
                              10.0.widthbox,
                              // Hours Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                  Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                  value: _selectedHour,
                                  underline: SizedBox(),
                                  items: List.generate(12, (index) => index + 1)
                                      .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        "$e",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ktextColor,
                                          fontSize: 14,
                                        ),
                                      )))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedHour = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),

                              // Minutes Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                  Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.grey.shade700),
                                  value: _selectedMinute,
                                  underline: SizedBox(),
                                  items: List.generate(60, (index) => index)
                                      .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ktextColor,
                                          fontSize: 14),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMinute = value!;
                                    });
                                  },
                                ),
                              ),
                              Spacer(),

                              // AM/PM Selection
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? Color(0xFFEDF2F7)
                                              : kPrimaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            topLeft: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "AM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? kPrimaryColor
                                              : Color(0xFFEDF2F7),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "PM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  20.0.heightbox,

                  // MATCH DURATION SECTION
                  Text("Match Duration",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  15.0.heightbox,

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hours",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              // isDense: true,
                              value: _selectedHours,
                              underline: SizedBox(),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              items: List.generate(12, (index) => index + 1)
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  "$e",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ktextColor,
                                      fontSize: 12),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedHours = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      20.0.widthbox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Minutes",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              value: _selectedMinutes,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              underline: SizedBox(),
                              items: List.generate(60, (index) => index)
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ktextColor,
                                      fontSize: 12),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMinutes = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // Finish Time Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Match will last for $_selectedHours hours and $_selectedMinutes minutes.\nFinish time is ${_calculateFinishTime()}",
                style: TextStyle(
                    color: kdefwhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),

            20.0.heightbox,

            // LOCATION INPUT
            Text("Location",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ktextColor)),

            PrimaryTextField(
              controller: locationController,
              hintText: "e.g. Power league",
              labelText: '',
              bordercolor: kPrimaryColor.withValues(alpha: 0.5),
            ),

            20.0.heightbox,
            // Match Note Section
            GestureDetector(
              onTap: () {
                setState(() {
                  isNoteFieldVisible = !isNoteFieldVisible;
                });
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kblueColor,
                    ),
                    child: Icon(
                      isNoteFieldVisible ? Icons.remove : Icons.add,
                      color: kdefwhiteColor,
                      size: 20,
                    ),
                  ),
                  5.0.widthbox,
                  Text(
                    "Match Note",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ktextColor),
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // Match Note Text Field (Shown on tap)
            if (isNoteFieldVisible)
              PrimaryTextField(
                controller: matchNoteController,
                hintText: "Write your notes here...",
                labelText: '',
                bordercolor: kPrimaryColor.withValues(alpha: .5),
                maxLines: 5,
              ),

            20.0.heightbox,
            // SAVE BUTTON
            PrimaryButton(
              onPressFunction: () async {
                // Prepare start and end DateTimes
                try {
                  int hour24 = (_selectedHour % 12) + (isPM ? 12 : 0);
                  DateTime startTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    hour24,
                    _selectedMinute,
                  );

                  DateTime endTime = startTime.add(
                    Duration(hours: _selectedHours, minutes: _selectedMinutes),
                  );

                  await updateMatch(
                    matchId: widget.matchId,
                    leagueId: widget.leagueId,
                    date: _selectedDate,
                    start: startTime,
                    end: endTime,
                    location: locationController.text,
                    homeTeamName: homeTeamController.text.isNotEmpty
                        ? homeTeamController.text
                        : null,
                    awayTeamName: awayTeamController.text.isNotEmpty
                        ? awayTeamController.text
                        : null,
                  );

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("Match updated successfully ✅")),
                  // );

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating match: $e")),
                  );
                }
              },
              buttonText: "Save Match",
            ),

            10.0.heightbox,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(String title, TextEditingController controller,
      int goals, List<Map<String, String>> players, bool isHome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        10.0.heightbox,
        StyledContainer(
          boxShadow: [],
          padding: EdgeInsets.all(10),
          borderColor: kPrimaryColor.withValues(alpha: 0.5),
          child: Column(
            children: [
              PrimaryTextField(
                height: 35,
                controller: controller,
                hintText: "Change Team Name",
                hintfontSize: 14,
                bordercolor: kdefgreyColor.withValues(alpha: .5),
              ),
              10.0.heightbox,
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          if (homeGoals > 0) homeGoals--;
                        } else {
                          if (awayGoals > 0) awayGoals--;
                        }
                      });
                    },
                  ),
                  Text(
                    "$goals",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          homeGoals++;
                        } else {
                          awayGoals++;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  Text("Goals",
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Row(
                      children: players.map((player) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _buildPlayerAvatar(
                            player["number"]!,
                            player["name"]!,
                            isHome ? AppImages.shirt : AppImages.awayshirt,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerAvatar(String number, String name, String shirtImage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              shirtImage,
              width: 30, // Adjust size as needed
              height: 30,
              fit: BoxFit.contain,
            ),
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
                // shadows: [
                //   Shadow(
                //     color: Colors.black.withValues(alpha: .6),
                //     offset: Offset(1, 1),
                //     blurRadius: 2,
                //   ),
                // ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Player%20Selection/playerselection.dart';
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../Services/RiverPord Provider/ref_provider.dart';


class EditMatchScreen extends ConsumerStatefulWidget {
  final String matchId;
  final String leagueId;

  const EditMatchScreen({
    Key? key,
    required this.matchId,
    required this.leagueId,
  }) : super(key: key);

  @override
  EditMatchScreenState createState() => EditMatchScreenState();
}

class EditMatchScreenState extends ConsumerState<EditMatchScreen> {
  TextEditingController homeTeamController = TextEditingController();
  TextEditingController awayTeamController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController matchNoteController = TextEditingController();

  bool isNoteFieldVisible = false;

  DateTime _selectedDate = DateTime.now();
  int _selectedHour = 9;
  int _selectedMinute = 30;
  bool isPM = true; // Toggle between AM & PM
  int _selectedHours = 1;
  int _selectedMinutes = 40;

  String _calculateFinishTime() {
    final matchStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final matchEnd = matchStart
        .add(Duration(hours: _selectedHours, minutes: _selectedMinutes));

    return DateFormat('hh:mm a').format(matchEnd);
  }

  int homeGoals = 0;
  int awayGoals = 0;
  final List<Map<String, String>> homePlayers = [
    {"number": "03", "name": "John"},
    {"number": "05", "name": "Eric"},
  ];

  final List<Map<String, String>> awayPlayers = [
    {"number": "02", "name": "Wedi"},
    {"number": "07", "name": "Terq"},
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Edit Match",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1), // orange
            Color.fromRGBO(207, 35, 38, 1), // red
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamSection(
                "Home Team", homeTeamController, homeGoals, homePlayers, true),
            20.0.heightbox,
            _buildTeamSection(
                "Away Team", awayTeamController, awayGoals, awayPlayers, false),
            20.0.heightbox,
            ButtonWithIcon(
              buttonColor: kblueColor,
              buttonText: "Select Player",
              leadingWidget: Icon(
                Icons.group,
                color: kdefwhiteColor,
              ),
              onPressFunction: () {
                context.route(SelectPlayersScreen());
              },
            ),
            20.0.heightbox,
            Text("Match Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ktextColor,
                )),
            10.0.heightbox,
            StyledContainer(
              padding: EdgeInsets.all(10),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // START TIME SECTION
                  Text("Start Time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  10.0.heightbox,
                  // Inline Calendar View
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: defaultBorderRadious,
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200, // Soft grey shadow
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 1), // Slight elevation
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: kPrimaryColor,
                              onPrimary: kPrimaryColor,
                              onSurface: ktextColor,
                            ),
                            textTheme: TextTheme(
                              bodyLarge: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ktextColor,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            currentDate:
                            _selectedDate, // Ensures selected date is highlighted
                            selectableDayPredicate: (DateTime val) => true,
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 0.8,
                          color: Colors.grey.shade400,
                        ),

                        // Display selected date
                        Text(
                          DateFormat('EEE  MMM d  yyyy')
                              .format(_selectedDate)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        ),
                        10.0.heightbox,
                        Padding(
                          padding: defaultPadding(vertical: 5, horizontal: 5),
                          child:
                          // Time selection (Hour, Minute, AM/PM)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 20,
                              ),
                              10.0.widthbox,
                              // Hours Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                  Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                  value: _selectedHour,
                                  underline: SizedBox(),
                                  items: List.generate(12, (index) => index + 1)
                                      .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        "$e",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ktextColor,
                                          fontSize: 14,
                                        ),
                                      )))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedHour = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),

                              // Minutes Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                  Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.grey.shade700),
                                  value: _selectedMinute,
                                  underline: SizedBox(),
                                  items: List.generate(60, (index) => index)
                                      .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ktextColor,
                                          fontSize: 14),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMinute = value!;
                                    });
                                  },
                                ),
                              ),
                              Spacer(),

                              // AM/PM Selection
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? Color(0xFFEDF2F7)
                                              : kPrimaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            topLeft: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "AM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? kPrimaryColor
                                              : Color(0xFFEDF2F7),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "PM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  20.0.heightbox,

                  // MATCH DURATION SECTION
                  Text("Match Duration",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  15.0.heightbox,

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hours",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              value: _selectedHours,
                              underline: SizedBox(),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              items: List.generate(12, (index) => index + 1)
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  "$e",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ktextColor,
                                      fontSize: 12),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedHours = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      20.0.widthbox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Minutes",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              value: _selectedMinutes,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              underline: SizedBox(),
                              items: List.generate(60, (index) => index)
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ktextColor,
                                      fontSize: 12),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMinutes = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // Finish Time Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Match will last for $_selectedHours hours and $_selectedMinutes minutes.\nFinish time is ${_calculateFinishTime()}",
                style: TextStyle(
                    color: kdefwhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),

            20.0.heightbox,

            // LOCATION INPUT
            Text("Location",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ktextColor)),

            PrimaryTextField(
              controller: locationController,
              hintText: "e.g. Power league",
              labelText: '',
              bordercolor: kPrimaryColor.withValues(alpha: 0.5),
            ),

            20.0.heightbox,
            // Match Note Section
            GestureDetector(
              onTap: () {
                setState(() {
                  isNoteFieldVisible = !isNoteFieldVisible;
                });
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kblueColor,
                    ),
                    child: Icon(
                      isNoteFieldVisible ? Icons.remove : Icons.add,
                      color: kdefwhiteColor,
                      size: 20,
                    ),
                  ),
                  5.0.widthbox,
                  Text(
                    "Match Note",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ktextColor),
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            // Match Note Text Field (Shown on tap)
            if (isNoteFieldVisible)
              PrimaryTextField(
                controller: matchNoteController,
                hintText: "Write your notes here...",
                labelText: '',
                bordercolor: kPrimaryColor.withValues(alpha: .5),
                maxLines: 5,
              ),

            20.0.heightbox,
            // SAVE BUTTON
            PrimaryButton(
              onPressFunction: () async {
                try {
                  int hour24 = (_selectedHour % 12) + (isPM ? 12 : 0);
                  DateTime startTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    hour24,
                    _selectedMinute,
                  );

                  DateTime endTime = startTime.add(
                    Duration(hours: _selectedHours, minutes: _selectedMinutes),
                  );

                  await updateMatch(
                    matchId: widget.matchId,
                    leagueId: widget.leagueId,
                    date: _selectedDate,
                    start: startTime,
                    end: endTime,
                    location: locationController.text,
                    homeTeamName: homeTeamController.text.isNotEmpty
                        ? homeTeamController.text
                        : null,
                    awayTeamName: awayTeamController.text.isNotEmpty
                        ? awayTeamController.text
                        : null,
                    notes: matchNoteController.text.isNotEmpty
                        ? matchNoteController.text
                        : null,
                    // keep sending goals if your updateMatch needs them, but the backend ignores them
                    homeTeamGoals: homeGoals.toString(),
                    awayTeamGoals: awayGoals.toString(),
                  );

                  // 🔥 Patch goals separately
                  await updateMatchGoals(
                    matchId: widget.matchId,
                    homeGoals: homeGoals.toString(),
                    awayGoals: awayGoals.toString(),
                  );

                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating match: $e")),
                  );
                }
              },
              buttonText: "Save Match",
            ),

            10.0.heightbox,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(String title, TextEditingController controller,
      int goals, List<Map<String, String>> players, bool isHome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        10.0.heightbox,
        StyledContainer(
          boxShadow: [],
          padding: EdgeInsets.all(10),
          borderColor: kPrimaryColor.withValues(alpha: 0.5),
          child: Column(
            children: [
              PrimaryTextField(
                height: 35,
                controller: controller,
                hintText: "Change Team Name",
                hintfontSize: 14,
                bordercolor: kdefgreyColor.withValues(alpha: .5),
              ),
              10.0.heightbox,
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          if (homeGoals > 0) homeGoals--;
                        } else {
                          if (awayGoals > 0) awayGoals--;
                        }
                      });
                    },
                  ),
                  Text(
                    "$goals",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          homeGoals++;
                        } else {
                          awayGoals++;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  Text("Goals",
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Row(
                      children: players.map((player) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _buildPlayerAvatar(
                            player["number"]!,
                            player["name"]!,
                            isHome ? AppImages.shirt : AppImages.awayshirt,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerAvatar(String number, String name, String shirtImage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              shirtImage,
              width: 30, // Adjust size as needed
              height: 30,
              fit: BoxFit.contain,
            ),
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/Menu%20Options%20Screens/Matches/Player%20Selection/playerselection.dart';
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'dart:convert';
import '../../../../../../../Services/RiverPord Provider/ref_provider.dart';

class EditMatchScreen extends ConsumerStatefulWidget {
  final String matchId;
  final String leagueId;

  const EditMatchScreen({
    Key? key,
    required this.matchId,
    required this.leagueId,
  }) : super(key: key);

  @override
  EditMatchScreenState createState() => EditMatchScreenState();
}

class EditMatchScreenState extends ConsumerState<EditMatchScreen> {
  @override
  void initState() {
    super.initState();
    _loadMatchData();
  }

  Future<void> _loadMatchData() async {
    try {
      print(
          "🔎 _loadMatchData: fetching match ${widget.matchId} for league ${widget.leagueId}");

      final raw = await getMatchById(widget.matchId, widget.leagueId);
      print("📦 getMatchById returned (raw): $raw");

      Map<String, dynamic> matchData;
      if (raw is Map<String, dynamic>) {
        matchData = Map<String, dynamic>.from(raw);
        if (matchData.containsKey('data') && matchData['data'] is Map) {
          matchData = Map<String, dynamic>.from(matchData['data']);
          print("➡️ Using nested 'data' object");
        } else if (matchData.containsKey('match') &&
            matchData['match'] is Map) {
          matchData = Map<String, dynamic>.from(matchData['match']);
          print("➡️ Using nested 'match' object");
        }
      } else {
        try {
          matchData = jsonDecode(raw.toString()) as Map<String, dynamic>;
        } catch (e) {
          throw Exception("Unexpected response format from getMatchById: $e");
        }
      }

      print("🔧 Normalized matchData keys: ${matchData.keys.toList()}");

      DateTime? _parseToDateTime(dynamic value) {
        if (value == null) return null;
        if (value is DateTime) return value;
        if (value is int) {
          try {
            return DateTime.fromMillisecondsSinceEpoch(value);
          } catch (_) {}
        }
        if (value is String) {
          try {
            return DateTime.parse(value);
          } catch (_) {
            final asInt = int.tryParse(value);
            if (asInt != null) {
              return DateTime.fromMillisecondsSinceEpoch(asInt);
            }
          }
        }
        return null;
      }

      // Build local values
      final local = <String, dynamic>{};
      local['homeTeamName'] = matchData['homeTeamName'] ??
          matchData['home_name'] ??
          matchData['home'] ??
          "";
      local['awayTeamName'] = matchData['awayTeamName'] ??
          matchData['away_name'] ??
          matchData['away'] ??
          "";
      local['location'] = matchData['location'] ?? matchData['venue'] ?? "";
      local['notes'] = matchData['notes'] ?? matchData['note'] ?? "";

      final parsedDate =
          _parseToDateTime(matchData['date'] ?? matchData['matchDate']);
      final parsedStart =
          _parseToDateTime(matchData['start'] ?? matchData['startTime']);
      final parsedEnd =
          _parseToDateTime(matchData['end'] ?? matchData['endTime']);

      final parsedDateLocal = parsedDate?.toLocal();
      final parsedStartLocal = parsedStart?.toLocal();
      final parsedEndLocal = parsedEnd?.toLocal();

      local['date'] = parsedDateLocal;
      local['start'] = parsedStartLocal;
      local['end'] = parsedEndLocal;

      local['homeGoals'] = (matchData['homeTeamGoals'] ??
                  matchData['homeGoals'] ??
                  matchData['home_goals'])
              ?.toString() ??
          "0";
      local['awayGoals'] = (matchData['awayTeamGoals'] ??
                  matchData['awayGoals'] ??
                  matchData['away_goals'])
              ?.toString() ??
          "0";

      List<dynamic>? rawHomePlayers;
      List<dynamic>? rawAwayPlayers;

      if (matchData['homePlayers'] is List)
        rawHomePlayers = matchData['homePlayers'];
      if (matchData['awayPlayers'] is List)
        rawAwayPlayers = matchData['awayPlayers'];

      if (rawHomePlayers == null &&
          matchData['home'] is Map &&
          matchData['home']['players'] is List) {
        rawHomePlayers = matchData['home']['players'];
      }
      if (rawAwayPlayers == null &&
          matchData['away'] is Map &&
          matchData['away']['players'] is List) {
        rawAwayPlayers = matchData['away']['players'];
      }

      final parsedHomePlayers =
          (rawHomePlayers ?? []).map<Map<String, String>>((p) {
        final number = (p is Map && p['number'] != null)
            ? p['number'].toString()
            : (p is String ? p : "");
        final name = (p is Map && p['name'] != null)
            ? p['name'].toString()
            : (p is Map && p['fullName'] != null
                ? p['fullName'].toString()
                : "");
        return {"number": number, "name": name};
      }).toList();

      final parsedAwayPlayers =
          (rawAwayPlayers ?? []).map<Map<String, String>>((p) {
        final number = (p is Map && p['number'] != null)
            ? p['number'].toString()
            : (p is String ? p : "");
        final name = (p is Map && p['name'] != null)
            ? p['name'].toString()
            : (p is Map && p['fullName'] != null
                ? p['fullName'].toString()
                : "");
        return {"number": number, "name": name};
      }).toList();

      print(
          "➡️ Will set: home:'${local['homeTeamName']}' away:'${local['awayTeamName']}' location:'${local['location']}' notes:'${local['notes']}'");
      print(
          "➡️ Dates: date=$parsedDateLocal start=$parsedStartLocal end=$parsedEndLocal");
      print("➡️ Goals: home=${local['homeGoals']} away=${local['awayGoals']}");
      print(
          "➡️ Players count: home=${parsedHomePlayers.length} away=${parsedAwayPlayers.length}");
      bool _isMatchLoaded = false;

      setState(() {
        homeTeamController.text = local['homeTeamName'] ?? "";
        awayTeamController.text = local['awayTeamName'] ?? "";
        locationController.text = local['location'] ?? "";
        matchNoteController.text = local['notes'] ?? "";

        if (local['date'] != null) _selectedDate = local['date'] as DateTime;

        if (local['start'] != null) {
          final s = local['start'] as DateTime;
          final hour12 = s.hour % 12;
          _selectedHour = hour12 == 0 ? 12 : hour12;
          _selectedMinute = s.minute;
          isPM = s.hour >= 12;
        }

        if (local['end'] != null && local['start'] != null) {
          final s = local['start'] as DateTime;
          final e = local['end'] as DateTime;
          final diff = e.difference(s);
          final diffHours = diff.inHours;
          final diffMinutes = diff.inMinutes % 60;
          _selectedHours = (diffHours > 0) ? diffHours : 1;
          _selectedMinutes = diffMinutes;
        }

        homeGoals = int.tryParse(local['homeGoals'] ?? "0") ?? 0;
        awayGoals = int.tryParse(local['awayGoals'] ?? "0") ?? 0;

        homePlayers = parsedHomePlayers;
        awayPlayers = parsedAwayPlayers;

        _isMatchLoaded = true;
      });
    } catch (e, st) {
      print("❌ _loadMatchData error: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load match details")));
    }
  }

  TextEditingController homeTeamController = TextEditingController();
  TextEditingController awayTeamController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController matchNoteController = TextEditingController();
  final FocusNode matchNoteFocus = FocusNode();

  bool isNoteFieldVisible = false;

  bool _saving = false;

  DateTime _selectedDate = DateTime.now();
  int _selectedHour = 9;
  int _selectedMinute = 30;
  bool isPM = true;
  int _selectedHours = 1;
  int _selectedMinutes = 40;

  String _calculateFinishTime() {
    int hour24 = (_selectedHour % 12) + (isPM ? 12 : 0);
    final matchStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour24,
      _selectedMinute,
    );
    final matchEnd = matchStart.add(
      Duration(hours: _selectedHours, minutes: _selectedMinutes),
    );
    return DateFormat('hh:mm a').format(matchEnd);
  }

  int homeGoals = 0;
  int awayGoals = 0;

  List<Map<String, String>> homePlayers = [];
  List<Map<String, String>> awayPlayers = [];

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Edit Match",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1), // orange
            Color.fromRGBO(207, 35, 38, 1), // red
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamSection(
                "Home Team", homeTeamController, homeGoals, homePlayers, true),
            20.0.heightbox,
            _buildTeamSection(
                "Away Team", awayTeamController, awayGoals, awayPlayers, false),
            20.0.heightbox,
            ButtonWithIcon(
              buttonColor: kblueColor,
              buttonText: "Select Player",
              leadingWidget: Icon(
                Icons.group,
                color: kdefwhiteColor,
              ),
              onPressFunction: () {
                context.route(SelectPlayersScreen());
              },
            ),
            20.0.heightbox,
            Text("Match Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ktextColor,
                )),
            10.0.heightbox,
            StyledContainer(
              padding: EdgeInsets.all(10),
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Start Time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  10.0.heightbox,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: defaultBorderRadious,
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: kPrimaryColor,
                              onPrimary: kPrimaryColor,
                              onSurface: ktextColor,
                            ),
                            textTheme: TextTheme(
                              bodyLarge: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ktextColor,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                          child: CalendarDatePicker(
                            key: ValueKey(_selectedDate),
                            initialDate: _selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                            currentDate: _selectedDate,
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            selectableDayPredicate: (DateTime val) => true,
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 0.8,
                          color: Colors.grey.shade400,
                        ),

                        // Display selected date
                        Text(
                          DateFormat('EEE  MMM d  yyyy')
                              .format(_selectedDate)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        ),
                        10.0.heightbox,
                        Padding(
                          padding: defaultPadding(vertical: 5, horizontal: 5),
                          child:
                              Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 20,
                              ),
                              10.0.widthbox,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                  value: _selectedHour,
                                  underline: SizedBox(),
                                  items: List.generate(12, (index) => index + 1)
                                      .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            "$e",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ktextColor,
                                              fontSize: 14,
                                            ),
                                          )))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedHour = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.grey.shade700),
                                  value: _selectedMinute,
                                  underline: SizedBox(),
                                  items: List.generate(60, (index) => index)
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e.toString().padLeft(2, '0'),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: ktextColor,
                                                  fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMinute = value!;
                                    });
                                  },
                                ),
                              ),
                              Spacer(),

                              // AM/PM Selection
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? Color(0xFFEDF2F7)
                                              : kPrimaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            topLeft: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "AM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPM = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: isPM
                                              ? kPrimaryColor
                                              : Color(0xFFEDF2F7),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          )),
                                      child: Text(
                                        "PM",
                                        style: TextStyle(
                                          color: isPM
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  20.0.heightbox,

                  Text("Match Duration",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      )),
                  15.0.heightbox,

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hours",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              value: _selectedHours,
                              underline: SizedBox(),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              items: List.generate(12, (index) => index + 1)
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          "$e",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ktextColor,
                                              fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedHours = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      20.0.widthbox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Minutes",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<int>(
                              value: _selectedMinutes,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade700),
                              underline: SizedBox(),
                              items: List.generate(60, (index) => index)
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.toString().padLeft(2, '0'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: ktextColor,
                                              fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMinutes = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Match will last for $_selectedHours hours and $_selectedMinutes minutes.\nFinish time is ${_calculateFinishTime()}",
                style: TextStyle(
                    color: kdefwhiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),

            20.0.heightbox,

            // LOCATION INPUT
            Text("Location",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ktextColor)),

            PrimaryTextField(
              controller: locationController,
              hintText: "e.g. Power league",
              labelText: '',
              bordercolor: kPrimaryColor.withValues(alpha: 0.5),
            ),

            20.0.heightbox,
            // Match Note Section
            GestureDetector(
              onTap: () {
                setState(() {
                  isNoteFieldVisible = !isNoteFieldVisible;
                });
                if (isNoteFieldVisible) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted) matchNoteFocus.requestFocus();
                  });
                } else {
                  // optionally unfocus when closed
                  matchNoteFocus.unfocus();
                }
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kblueColor,
                    ),
                    child: Icon(
                      isNoteFieldVisible ? Icons.remove : Icons.add,
                      color: kdefwhiteColor,
                      size: 20,
                    ),
                  ),
                  5.0.widthbox,
                  Text(
                    "Match Note",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ktextColor),
                  ),
                ],
              ),
            ),

            10.0.heightbox,

            if (isNoteFieldVisible)
              AnimatedSize(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: PrimaryTextField(
                    controller: matchNoteController,
                    focusNode: matchNoteFocus,
                    // keep focus behavior
                    hintText: "Write your notes here...",
                    labelText: '',
                    bordercolor: kPrimaryColor.withValues(alpha: 0.5),
                    height: 35,
                    maxLines: 1,
                    hintfontSize: 14,
                  ),
                ),
              ),

            20.0.heightbox,
            Opacity(
              opacity: _saving ? 0.6 : 1.0,
              child: PrimaryButton(
                buttonText: _saving ? "Saving..." : "Save Match",
                onPressFunction: _saving
                    ? null
                    : () async {
                        setState(() => _saving = true);
                        try {
                          int hour24 = (_selectedHour % 12) + (isPM ? 12 : 0);
                          DateTime startTime = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            hour24,
                            _selectedMinute,
                          );

                          DateTime endTime = startTime.add(
                            Duration(
                                hours: _selectedHours,
                                minutes: _selectedMinutes),
                          );

                          DateTime onlyDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                          );

                          await updateMatch(
                            matchId: widget.matchId,
                            leagueId: widget.leagueId,
                            date: startTime,
                            start: startTime,
                            end: endTime,
                            location: locationController.text,
                            homeTeamName: homeTeamController.text.isNotEmpty
                                ? homeTeamController.text
                                : null,
                            awayTeamName: awayTeamController.text.isNotEmpty
                                ? awayTeamController.text
                                : null,
                            homeTeamGoals: homeGoals.toString(),
                            awayTeamGoals: awayGoals.toString(),
                          );

                          await updateMatchGoals(
                            matchId: widget.matchId,
                            homeGoals: homeGoals.toString(),
                            awayGoals: awayGoals.toString(),
                          );

                          if (matchNoteController.text.isNotEmpty) {
                            await updateMatchNote(
                              matchId: widget.matchId,
                              note: matchNoteController.text,
                            );
                          }

                          if (!mounted) return;
                          toastification.show(
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.fillColored,
                            title: const Text("Match updated successfully"),
                          );
                          Navigator.pop(context, true);
                        } catch (e) {
                          toastification.show(
                            context: context,
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored,
                            title: Text("Error updating match: $e"),
                          );
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
              ),
            ),

            10.0.heightbox,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(String title, TextEditingController controller,
      int goals, List<Map<String, String>> players, bool isHome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        10.0.heightbox,
        StyledContainer(
          boxShadow: [],
          padding: EdgeInsets.all(10),
          borderColor: kPrimaryColor.withValues(alpha: 0.5),
          child: Column(
            children: [
              PrimaryTextField(
                height: 35,
                controller: controller,
                hintText: "Change Team Name",
                hintfontSize: 14,
                bordercolor: kdefgreyColor.withValues(alpha: .5),
              ),
              10.0.heightbox,
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          if (homeGoals > 0) homeGoals--;
                        } else {
                          if (awayGoals > 0) awayGoals--;
                        }
                      });
                    },
                  ),
                  Text(
                    "$goals",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isHome) {
                          homeGoals++;
                        } else {
                          awayGoals++;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  Text("Goals",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Row(
                      children: players.map((player) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _buildPlayerAvatar(
                            player["number"]!,
                            player["name"]!,
                            isHome ? AppImages.shirt : AppImages.awayshirt,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerAvatar(String number, String name, String shirtImage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              shirtImage,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
