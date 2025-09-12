import 'dart:io';
import 'package:champion_footballer/Controllers/postioncontrollprovider.dart';
import 'package:champion_footballer/Controllers/profileprovider.dart';
import 'package:champion_footballer/Controllers/skillmarkingprovider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:champion_footballer/Widgets/genderradiobutton.dart';
import '../../../../../../../Model/Api Models/usermodel.dart'; // For WelcomeUser type
import '../../../../../../../Services/RiverPord Provider/ref_provider.dart';
import 'package:toastification/toastification.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final PageController _pageController = PageController();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _shirtNumberController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _ageController;

  bool _isUpdatingProfile = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _shirtNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _ageController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).clearSelectionState();
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final WelcomeUser? user = ref.read(userDataProvider).asData?.value;
    final SkillMarkingState skillMarkingCurrentState = ref.read(skillMarkingProvider);
    final SkillMarkingNotifier skillMarkingCtrl = ref.read(skillMarkingProvider.notifier);

    if (user != null) {
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _emailController.text = user.email ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _shirtNumberController.text = user.shirtNumber ?? skillMarkingCurrentState.shirtNumber;
      
      final PositionNotifier positionNotifier = ref.read(positionProvider.notifier);
      if (user.positionType != null && user.positionType!.isNotEmpty) {
          positionNotifier.updateMainPosition(user.positionType!);
      } else if (positionNotifier.mainPositions.isNotEmpty) {
          positionNotifier.updateMainPosition(positionNotifier.mainPositions.first);
      }

      if (user.position != null && user.position!.isNotEmpty) {
          positionNotifier.updateSubPosition(user.position!);
      } else if (positionNotifier.subPositions.isNotEmpty) {
          positionNotifier.updateSubPosition(positionNotifier.subPositions.first);
      }

      if (user.chemistryStyle != null && user.chemistryStyle!.isNotEmpty) {
          positionNotifier.updateStyle(user.chemistryStyle!);
      } else if (positionNotifier.playingStyles.isNotEmpty) {
          positionNotifier.updateStyle(positionNotifier.playingStyles.first);
      }
      
      if (user.preferredFoot?.name != null && user.preferredFoot!.name.isNotEmpty) {
          positionNotifier.updateFoot(user.preferredFoot!.name);
      } else if (positionNotifier.foot.isNotEmpty) {
          positionNotifier.updateFoot(positionNotifier.foot.first);
      }

      if (user.attributes != null) {
          for (int i = 0; i < skillMarkingCtrl.skillNames.length; i++) {
              final String skillApiKey = skillMarkingCtrl.skillNames[i].split(' ')[0].toLowerCase();
              int? valueToUpdate;
              switch (skillApiKey) {
                  case 'pace': valueToUpdate = user.attributes?.pace; break;
                  case 'shooting': valueToUpdate = user.attributes?.shooting; break;
                  case 'passing': valueToUpdate = user.attributes?.passing; break;
                  case 'dribbling': valueToUpdate = user.attributes?.dribbling; break;
                  case 'defending': valueToUpdate = user.attributes?.defending; break;
                  case 'physical': valueToUpdate = user.attributes?.physical; break;
              }
              if (valueToUpdate != null) {
                  skillMarkingCtrl.updateSkillValue(i, valueToUpdate);
              }
          }
      }
    } else {
       print("User data not available in _loadInitialData");
      _shirtNumberController.text = skillMarkingCurrentState.shirtNumber;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _shirtNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: ScaffoldCustom(
        appBar: CustomAppBar(
          titleText: "Edit Your Profile",
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(229, 106, 22, 1),
              Color.fromRGBO(207, 35, 38, 1),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildPlayerCharacteristicsPage(),
                  _buildSkillMarkingPage(),
                  _buildPreferencesPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SmoothPageIndicator(
                controller: _pageController,
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

  Widget _buildPlayerCharacteristicsPage() {
    final ProfileSelectionUpdateState profileState = ref.watch(profileProvider);
    final File? actualProfileImageFile = profileState.selectedFile;
    final ProfileNotifier profileCtrl = ref.read(profileProvider.notifier);
    final PositionState positionState = ref.watch(positionProvider);
    final PositionNotifier positionCtrl = ref.read(positionProvider.notifier);
    final WelcomeUser? currentUser = ref.watch(userDataProvider).asData?.value;

    return SingleChildScrollView(
      padding: defaultPadding(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Text("Upload Pic", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        10.0.heightbox,
        Center(
          child: GestureDetector(
            onTap: () => profileCtrl.showOptions(context, ref, autoUpload: false),
            child: Container(
              padding: EdgeInsets.all(8),
              width: 70.0, height: 70.0,
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
                    image: actualProfileImageFile != null 
                        ? FileImage(actualProfileImageFile)
                        : (currentUser?.pictureKey != null && currentUser!.pictureKey!.isNotEmpty
                            ? NetworkImage(currentUser.pictureKey!) 
                            : const AssetImage("assets/images/editpic.png")) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: _firstNameController,
          labelText: 'First Name',
          hintText: 'Enter your first name',
        ),
        20.0.heightbox,
        PrimaryTextField(
          controller: _lastNameController,
          labelText: 'Last Name',
          hintText: 'Enter your last name',
        ),
        20.0.heightbox,
        Text("Position Type", style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w600)),
        StyledContainer(
          boxShadow: [],
          borderColor: ktextColor.withValues(alpha: .2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: positionCtrl.mainPositions.map((position) {
              bool isSelected = positionState.selectedMain == position;
              return GestureDetector(
                onTap: () => positionCtrl.updateMainPosition(position),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Row(children: [
                    Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ktextColor.withValues(alpha: .4), width: 2)), child: isSelected ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor))) : null),
                    10.0.widthbox,
                    Text(position, style: TextStyle(color: ktextColor, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "Inter")),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        10.0.heightbox,
        Text('Position', style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w600)),
        if (positionCtrl.subPositions.isNotEmpty)
          StyledContainer(
            boxShadow: [],
            borderColor: ktextColor.withValues(alpha: .2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: positionCtrl.subPositions.map((subPosition) {
                bool isSelected = positionState.selectedSub == subPosition;
                return GestureDetector(
                  onTap: () => positionCtrl.updateSubPosition(subPosition),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Row(children: [
                      Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ktextColor.withValues(alpha: .4), width: 2)), child: isSelected ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor))) : null),
                      10.0.widthbox,
                      Text(subPosition, style: TextStyle(color: ktextColor, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "Inter")),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
        10.0.heightbox,
        Text('Your Style of Playing', style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w600)),
        if (positionCtrl.playingStyles.isNotEmpty)
          StyledContainer(
            boxShadow: [],
            borderColor: ktextColor.withValues(alpha: .2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: positionCtrl.playingStyles.map((style) {
                bool isSelected = positionState.selectedStyle == style;
                return GestureDetector(
                  onTap: () => positionCtrl.updateStyle(style),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Row(children: [
                      Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ktextColor.withValues(alpha: .4), width: 2)), child: isSelected ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor))) : null),
                      10.0.widthbox,
                      Text(style, style: TextStyle(color: ktextColor, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "Inter")),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
        10.0.heightbox,
        Text('Preferred Foot', style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w600)),
        if (positionCtrl.foot.isNotEmpty)
          StyledContainer(
            boxShadow: [],
            borderColor: ktextColor.withValues(alpha: .2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: positionCtrl.foot.map((foot) {
                bool isSelected = positionState.selectedFoot == foot;
                return GestureDetector(
                  onTap: () => positionCtrl.updateFoot(foot),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Row(children: [
                      Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ktextColor.withValues(alpha: .4), width: 2)), child: isSelected ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor))) : null),
                      10.0.widthbox,
                      Text(foot, style: TextStyle(color: ktextColor, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "Inter")),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
      ]),
    );
  }

  Widget _buildSkillMarkingPage() {
    final SkillMarkingState skillsPageState = ref.watch(skillMarkingProvider);
    final SkillMarkingNotifier skillsPageCtrl = ref.read(skillMarkingProvider.notifier);

    return Padding(
      padding: defaultPadding(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextField(
            controller: _shirtNumberController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
                skillsPageCtrl.updateShirtNumber(value);
            },
            labelText: 'Shirt Number',
            hintText: 'Enter Shirt number',
          ),
          15.0.heightbox,
          Expanded(
            child: ListView.builder(
              itemCount: skillsPageState.skillValues.length,
              itemBuilder: (context, index) {
                final int skillValue = skillsPageState.skillValues[index];
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
                    Text(skillsPageCtrl.skillNames[index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(trackHeight: 4),
                      child: Slider(
                        value: skillValue.toDouble(),
                        min: 50,
                        max: 99,
                        label: skillValue.toString(),
                        activeColor: skillLevelColor,
                        inactiveColor: Colors.grey.shade300,
                        thumbColor: Color(0xFF757575),
                        onChanged: (value) => skillsPageCtrl.updateSkillValue(index, value.toInt()),
                      ),
                    ),
                    Text(skillValue.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: skillLevelColor)),
                    Text(skillLevelText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: skillLevelColor)),
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

  Widget _buildPreferencesPage() {
    final AuthState authState = ref.watch(authProvider);
    final AuthNotifier authCtrl = ref.read(authProvider.notifier);

    return SingleChildScrollView(
      padding: defaultPadding(vertical: 10),
      child: Column(
        children: [
          PrimaryTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'your.email@address.com',
            keyboardType: TextInputType.emailAddress,
          ),
          20.0.heightbox,
          PrimaryTextField(
            controller: _passwordController,
            labelText: 'Change Password (leave blank to keep current)',
            hintText: 'Enter new password',
            obsecure: true,
          ),
          20.0.heightbox,
          PrimaryTextField(
            controller: _ageController,
            labelText: 'Age',
            hintText: '18-65',
            keyboardType: TextInputType.number,
          ),
          20.0.heightbox,
          Text('Gender', style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.bold)),
          StyledContainer(
            boxShadow: [],
            borderColor: ktextColor.withValues(alpha: .2),
            child: Column(
              children: [
                GenderSelectionButton(
                  gender: 'Male',
                  isSelected: authState.selectedGender == 'Male',
                  onSelected: () => authCtrl.selectGender('Male'),
                ),
                GenderSelectionButton(
                  gender: 'Female',
                  isSelected: authState.selectedGender == 'Female',
                  onSelected: () => authCtrl.selectGender('Female'),
                ),
                 GenderSelectionButton(
                  gender: 'Other',
                  isSelected: authState.selectedGender == 'Other',
                  onSelected: () => authCtrl.selectGender('Other'),
                ),
              ],
            ),
          ),
          30.0.heightbox,
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  fontSize: 14,
                  buttonText: _isUpdatingProfile ? "Updating..." : "Update Player Card",
                  onPressFunction: _isUpdatingProfile ? null : _submitProfileUpdate,
                ),
              ),
              20.0.widthbox,
              Expanded(
                child: SecondaryButton(
                  buttonColor: kredColor,
                  fontSize: 14,
                  buttonText: "Delete Account",
                  onPressFunction: () {
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

  Future<void> _submitProfileUpdate() async {
    if (_isUpdatingProfile) return;

    setState(() {
      _isUpdatingProfile = true;
    });

    final PositionState positionState = ref.read(positionProvider);
    final SkillMarkingNotifier skillsSubmitCtrl = ref.read(skillMarkingProvider.notifier);
    final AuthState authState = ref.read(authProvider);
    final File? selectedImageFile = ref.read(profileProvider).selectedFile;

    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text('Validation Error'),
        description: Text('First and Last name cannot be empty.'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      if (mounted) {
          setState(() {
            _isUpdatingProfile = false;
          });
      }
      return;
    }

    bool textUpdateSuccess = false;
    try {
      await updateProfile(
        ref: ref,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        ageString: _ageController.text.isNotEmpty ? _ageController.text : null,
        gender: authState.selectedGender,
        mainPosition: positionState.selectedMain,
        subPosition: positionState.selectedSub,
        style: positionState.selectedStyle,
        preferredFoot: positionState.selectedFoot,
        shirtNumberString: _shirtNumberController.text.isNotEmpty ? _shirtNumberController.text : null,
        skills: skillsSubmitCtrl.getSkillsMap(),
        password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );
      textUpdateSuccess = true;
      ref.invalidate(userDataProvider);

      if (selectedImageFile != null) {
        try {
          await uploadProfilePicture(ref: ref, profileImageFile: selectedImageFile);
          ref.read(profileProvider.notifier).clearSelectionState();
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            title: Text('Profile Updated'),
            description: Text('Profile and picture updated successfully!'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        } catch (imageError) {
          print("Error uploading profile picture: $imageError");
          toastification.show(
            context: context,
            type: ToastificationType.warning,
            style: ToastificationStyle.fillColored,
            title: Text('Partial Update'),
            description: Text('Profile details saved, but new picture upload failed: ${imageError.toString()}'),
            autoCloseDuration: const Duration(seconds: 7),
          );
        }
      } else if (textUpdateSuccess) {
        ref.read(profileProvider.notifier).clearSelectionState();
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: Text('Profile Updated'),
          description: Text('Profile details updated successfully!'),
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
      
      if (mounted && textUpdateSuccess) {
        final ProfileSelectionUpdateState currentProfileState = ref.read(profileProvider);
        bool imageUploadAttemptedAndFailed = selectedImageFile != null && currentProfileState.selectedFile == selectedImageFile;

        if (!imageUploadAttemptedAndFailed) { 
            Navigator.pop(context);
        }
      }

    } catch (e) {
      print("Error updating profile (text data): $e");
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text('Update Failed'),
        description: Text('Failed to update profile details: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingProfile = false;
        });
      }
    }
  }
}
