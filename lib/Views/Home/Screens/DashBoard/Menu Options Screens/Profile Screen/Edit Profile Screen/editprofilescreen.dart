import 'package:champion_footballer/Controllers/postioncontrollprovider.dart';
import 'package:champion_footballer/Controllers/profileprovider.dart';
import 'package:champion_footballer/Controllers/skillmarkingprovider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Widgets/genderradiobutton.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = PageController();
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: ScaffoldCustom(
        appBar: CustomAppBar(
          titleText: "Edit Your Profile",
          action: PopupMenuButton<String>(
            iconSize: 30,
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Option 1',
                child: Text('Option 1'),
              ),
              const PopupMenuItem(
                value: 'Option 2',
                child: Text('Option 2'),
              ),
              const PopupMenuItem(
                value: 'Option 3',
                child: Text('Option 3'),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  // Page 1: Personal Information
                  _buildPlayerChracteristics(ref),
                  // Page 2: Contact Information
                  _builSkillMarkingPage(ref),
                  // Page 3: Preferences
                  _buildPreferencesPage(context, ref),
                ],
              ),
            ),
            // SmoothPageIndicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: SlideEffect(
                  dotColor: kdefblackColor,
                  activeDotColor: kPrimaryColor,
                  dotHeight: 7,
                  dotWidth: 7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerChracteristics(WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    final positionState = ref.watch(positionProvider);
    final positionNotifier = ref.read(positionProvider.notifier);
    return SingleChildScrollView(
      padding: defaultPadding(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Text(
            "Upload Pic",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        10.0.heightbox,
        Center(
          child: GestureDetector(
            onTap: () {
              profileNotifier.showOptions(ref.context, ref);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kdefwhiteColor,
                borderRadius: defaultBorderRadious,
                border: Border.all(color: kdefblackColor),
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: profile == null
                        ? const AssetImage("assets/images/editpic.png")
                        : FileImage(profile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        20.0.heightbox,
        PrimaryTextField(
          labelText: "Name",
          hintText: "write player name",
          maxLength: 10,
        ),
        20.0.heightbox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Position Type",
              style: TextStyle(
                color: ktextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            StyledContainer(
              boxShadow: [],
              borderColor: ktextColor.withValues(alpha: .2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...positionNotifier.mainPositions.map((position) {
                    bool isSelected = positionState.selectedMain == position;
                    return GestureDetector(
                      onTap: () {
                        positionNotifier.updateMainPosition(position);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ktextColor.withValues(alpha: .4),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            10.0.widthbox,
                            Text(
                              position,
                              style: TextStyle(
                                color: ktextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            10.0.heightbox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Position',
                  style: TextStyle(
                    color: ktextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (positionNotifier.subPositions.isNotEmpty)
                  StyledContainer(
                    boxShadow: [],
                    borderColor: ktextColor.withValues(alpha: .2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...positionNotifier.subPositions.map((subPosition) {
                          bool isSelected =
                              positionState.selectedSub == subPosition;
                          return GestureDetector(
                            onTap: () {
                              positionNotifier.updateSubPosition(subPosition);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ktextColor.withValues(alpha: .4),
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  10.0.widthbox,
                                  Text(
                                    subPosition,
                                    style: TextStyle(
                                      color: ktextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            ),
            10.0.heightbox,
            // Style of Playing

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Style of Playing',
                  style: TextStyle(
                    color: ktextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (positionNotifier.playingStyles.isNotEmpty)
                  StyledContainer(
                    boxShadow: [],
                    borderColor: ktextColor.withValues(alpha: .2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...positionNotifier.playingStyles.map((style) {
                          bool isSelected =
                              positionState.selectedStyle == style;
                          return GestureDetector(
                            onTap: () {
                              positionNotifier.updateStyle(style);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 5,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ktextColor.withValues(alpha: .4),
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  10.0.widthbox,
                                  Text(
                                    style,
                                    style: TextStyle(
                                      color: ktextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            ),

            10.0.heightbox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preferred Foot',
                  style: TextStyle(
                    color: ktextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (positionNotifier.foot.isNotEmpty)
                  StyledContainer(
                    boxShadow: [],
                    borderColor: ktextColor.withValues(alpha: .2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...positionNotifier.foot.map((foot) {
                          bool isSelected = positionState.selectedFoot == foot;
                          return GestureDetector(
                            onTap: () {
                              positionNotifier.updateFoot(foot);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color:
                                              ktextColor.withValues(alpha: .4),
                                          width: 2),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  10.0.widthbox,
                                  Text(
                                    foot,
                                    style: TextStyle(
                                      color: ktextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ]),
    );
  }
}

Widget _builSkillMarkingPage(WidgetRef ref) {
  final skillState = ref.watch(skillMarkingProvider);
  final skillNotifier = ref.read(skillMarkingProvider.notifier);
  final skillNames = skillNotifier.skillNames;
  return Padding(
    padding: defaultPadding(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            skillNotifier.updateShirtNumber(value);
          },
          labelText: 'Shirt Number',
          hintText: 'Enter Shirt number',
        ),
        15.0.heightbox,
        Expanded(
          child: ListView.builder(
            itemCount: skillState.skillValues.length,
            itemBuilder: (context, index) {
              final skillValue = skillState.skillValues[index];
              String skillLevelText;
              Color skillLevelColor;
              if (skillValue >= 50 && skillValue <= 69) {
                skillLevelText = 'Amateur';
                skillLevelColor = Color(0xFF0D9601);
              } else if (skillValue >= 70 && skillValue <= 84) {
                skillLevelText = 'Professional';
                skillLevelColor = Color(0xFF3B82F6);
              } else {
                skillLevelText = 'Elite';
                skillLevelColor = Color(0xFFEF444C);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillNames[index],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(trackHeight: 4),
                        child: Slider(
                          value: skillValue.toDouble(),

                          min: 50,
                          max: 99,
                          // divisions: 49,
                          label: skillValue.toString(),
                          activeColor: skillLevelColor,
                          inactiveColor: Colors.grey.shade300,
                          thumbColor: Color(0xFF757575),
                          onChanged: (value) {
                            skillNotifier.updateSkillValue(
                                index, value.toInt());
                          },
                        ),
                      ),
                      // slider value
                      Text(
                        skillValue.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: skillLevelColor,
                        ),
                      ),
                      // Skill Level Text
                      Text(
                        skillLevelText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: skillLevelColor,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        30.0.heightbox,
      ],
    ),
  );
}

Widget _buildPreferencesPage(BuildContext context, WidgetRef ref) {
  final authState = ref.watch(authProvider);
  final authNotifier = ref.read(authProvider.notifier);
  return SingleChildScrollView(
    padding: defaultPadding(vertical: 10),
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextField(
              labelText: 'Email Address',
              hintText: 'your.email@address.com',
            ),
            20.0.heightbox,
            PrimaryTextField(
              labelText: 'Change Password',
              hintText: 'Enter your password',
              obsecure: true,
            ),
            20.0.heightbox,
            PrimaryTextField(
              labelText: 'First Name',
              hintText: 'Enter your first name',
            ),
            20.0.heightbox,
            PrimaryTextField(
              labelText: 'Last Name',
              hintText: 'Enter your last name',
            ),
            20.0.heightbox,
            PrimaryTextField(
              labelText: 'Age',
              hintText: '18-65',
            ),
            20.0.heightbox,
            Text(
              'Gender',
              style: TextStyle(
                  color: ktextColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            // 10.0.heightbox,
            StyledContainer(
              boxShadow: [],
              borderColor: ktextColor.withValues(alpha: .2),
              child: Column(
                children: [
                  GenderSelectionButton(
                    gender: 'Male',
                    isSelected: authState.selectedGender == 'Male',
                    onSelected: () => authNotifier.selectGender('Male'),
                  ),
                  GenderSelectionButton(
                    gender: 'Female',
                    isSelected: authState.selectedGender == 'Female',
                    onSelected: () => authNotifier.selectGender('Female'),
                  ),
                ],
              ),
            )
          ],
        ),
        30.0.heightbox,
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                fontSize: 14,
                buttonText: "Update Player Card",
                onPressFunction: () {
                  // context.routeoffall(DashboardScreen2());
                  Navigator.pop(context);
                },
              ),
            ),
            20.0.widthbox,
            Expanded(
              child: SecondaryButton(
                buttonColor: kredColor,
                fontSize: 14,
                buttonText: "Delete Account",
                onPressFunction: () {
                  // context.routeoffall(DashboardScreen2());
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
