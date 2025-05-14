import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:intl/intl.dart';

class NewMatchScreen extends StatefulWidget {
  const NewMatchScreen({super.key});

  @override
  NewMatchScreenState createState() => NewMatchScreenState();
}

class NewMatchScreenState extends State<NewMatchScreen> {
  DateTime _selectedDate = DateTime.now();
  // TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 30);
  int _selectedHour = 9;
  int _selectedMinute = 30;
  bool isPM = true; // Toggle between AM & PM
  int _selectedHours = 1;
  int _selectedMinutes = 40;
  TextEditingController locationController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(titleText: "Create Match"),
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // START TIME SECTION
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

            // SAVE BUTTON
            PrimaryButton(
              onPressFunction: () {
                // Save Match
                Navigator.pop(context);
              },
              buttonText: "Save Match",
            ),
            20.0.heightbox,
          ],
        ),
      ),
    );
  }
}
