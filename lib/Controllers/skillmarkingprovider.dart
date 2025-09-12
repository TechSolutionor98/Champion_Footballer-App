// import '../Utils/packages.dart';

// class SkillMarkingProvider extends ChangeNotifier {
//   // Shirt number
//   String shirtNumber = '';

//   // Skill values
//   final List<int> skillValues = [50, 50, 50, 50, 50, 50];

//   // Skill names
//   final List<String> skillNames = [
//     'Dribbling (DRI)',
//     'Shooting (SHO)',
//     'Passing (PAS)',
//     'Pace (PAC)',
//     'Defending (DEF)',
//     'Physical (PHY)',
//   ];

//   // Update shirt number
//   void updateShirtNumber(String value) {
//     shirtNumber = value;
//     notifyListeners();
//   }

//   // Update slider value for a specific skill
//   void updateSkillValue(int index, int value) {
//     skillValues[index] = value;
//     notifyListeners();
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';


class SkillMarkingState {
  final String shirtNumber;
  final List<int> skillValues;

  SkillMarkingState({
    required this.shirtNumber,
    required this.skillValues,
  });

  SkillMarkingState copyWith({
    String? shirtNumber,
    List<int>? skillValues,
  }) {
    return SkillMarkingState(
      shirtNumber: shirtNumber ?? this.shirtNumber,
      skillValues: skillValues ?? this.skillValues,
    );
  }
}

class SkillMarkingNotifier extends Notifier<SkillMarkingState> {
  @override
  SkillMarkingState build() {
    return SkillMarkingState(
      shirtNumber: '',
      skillValues: List<int>.filled(6, 50),
    );
  }

  final List<String> skillNames = [
    'Dribbling (DRI)',
    'Shooting (SHO)',
    'Passing (PAS)',
    'Pace (PAC)',
    'Defending (DEF)',
    'Physical (PHY)',
  ];

  String _getSkillApiKey(String skillNameWithExtra) {
    return skillNameWithExtra.split(' ')[0].toLowerCase();
  }

  void updateShirtNumber(String value) {
    state = state.copyWith(shirtNumber: value);
  }

  void updateSkillValue(int index, int value) {
    final updatedSkills = [...state.skillValues];
    updatedSkills[index] = value;
    state = state.copyWith(skillValues: updatedSkills);
  }

  Map<String, int> getSkillsMap() {
    final Map<String, int> skillsMap = {};
    for (int i = 0; i < skillNames.length; i++) {
      if (i < state.skillValues.length) {
        final apiKey = _getSkillApiKey(skillNames[i]);
        skillsMap[apiKey] = state.skillValues[i];
      }
    }
    return skillsMap;
  }
}

final skillMarkingProvider =
    NotifierProvider<SkillMarkingNotifier, SkillMarkingState>(
        () => SkillMarkingNotifier());
