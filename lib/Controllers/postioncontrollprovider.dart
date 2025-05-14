// import '../Utils/packages.dart';

// class PositionProvider extends ChangeNotifier {
//   // Main Positions
//   final List<String> mainPositions = [
//     'Goalkeeper',
//     'Defender',
//     'Midfielder',
//     'Forward',
//   ];

//   // Sub Positions
//   Map<String, List<String>> subPositionMap = {
//     'Goalkeeper': ['Goalkeeper'],
//     'Defender': [
//       'Centre-Back (CB)',
//       'Right-Back (RB)',
//       'Left-Back (LB)',
//       'Right Wing-back (RWB)',
//       'Left Wing-back (LWB)',
//     ],
//     'Midfielder': [
//       'Central Midfielder (CM)',
//       'Defender Midfielder (CDM)',
//       'Attacking Midfielder (CAM)',
//       'Right Midfielder (RM)',
//       'Left Midfielder (LM)',
//     ],
//     'Forward': [
//       'Striker (ST)',
//       'Central Forward (CF)',
//       'Right Forward (RF)',
//       'Left Forward (LF)',
//       'Right Winger (RW)',
//       'Left Winger (LW)',
//     ],
//   };

//   // Styles for each main position
//   Map<String, List<String>> positionStyles = {
//     'Goalkeeper': [
//       'Axe',
//       'Eagle',
//       'Iron Fist',
//       'Shot Stopper',
//       'Soldier',
//       'Sweeper Keeper',
//     ],
//     'Defender': [
//       'Hacker',
//       'No-Bull',
//       'Shield',
//       'Terminator',
//       'Wall',
//       'Warrior',
//     ],
//     'Midfielder': [
//       'Gladiator',
//       'Maestro',
//       'Magician',
//       'Power House',
//       'Road Runner',
//       'Scientist',
//     ],
//     'Forward': [
//       'Finisher',
//       'Poacher',
//       'Predator',
//       'Rocket',
//       'Ruthless',
//       'Sniper',
//     ],
//   };

//   // Styles for each main position
//   Map<String, List<String>> preferredfoot = {
//     'Goalkeeper': [
//       'Left',
//       'Right',
//     ],
//     'Defender': [
//       'Left',
//       'Right',
//     ],
//     'Midfielder': [
//       'Left',
//       'Right',
//     ],
//     'Forward': [
//       'Left',
//       'Right',
//     ],
//   };

//   String? selectedMainPosition = 'Goalkeeper';
//   String? selectedSubPosition;
//   String? selectedplayerstyle;
//   String? selectedfoot = 'Right';

//   List<String> get subPositions => selectedMainPosition != null
//       ? subPositionMap[selectedMainPosition!] ?? []
//       : [];
// // Styles based on selected main position
//   List<String> get playingStyles => selectedMainPosition != null
//       ? positionStyles[selectedMainPosition!] ?? []
//       : [];
// // Styles based on selected main position
//   List<String> get foot =>
//       selectedfoot != null ? preferredfoot[selectedMainPosition!] ?? [] : [];

//   void updateMainPosition(String position) {
//     selectedMainPosition = position;
//     selectedSubPosition = null;
//     selectedplayerstyle = null; 
//     selectedfoot = foot.isNotEmpty ? foot.first : null;
//     notifyListeners();
//   }

//   void updateSubPosition(String subPosition) {
//     selectedSubPosition = subPosition;
//     notifyListeners();
//   }

//   void updateStyle(String styleofplayer) {
//     if (playingStyles.contains(styleofplayer)) {
//       selectedplayerstyle = styleofplayer;
//       notifyListeners();
//     }
//   }

//   void updateFoot(String foot) {
//     if (foot.contains(foot)) {
//       selectedfoot = foot;
//       notifyListeners();
//     }
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionState {
  final String selectedMain;
  final String? selectedSub;
  final String? selectedStyle;
  final String? selectedFoot;

  PositionState({
    required this.selectedMain,
    this.selectedSub,
    this.selectedStyle,
    this.selectedFoot,
  });

  PositionState copyWith({
    String? selectedMain,
    String? selectedSub,
    String? selectedStyle,
    String? selectedFoot,
  }) {
    return PositionState(
      selectedMain: selectedMain ?? this.selectedMain,
      selectedSub: selectedSub ?? this.selectedSub,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      selectedFoot: selectedFoot ?? this.selectedFoot,
    );
  }
}

class PositionNotifier extends Notifier<PositionState> {
  @override
  PositionState build() {
    return PositionState(
      selectedMain: 'Goalkeeper',
      selectedFoot: 'Right',
    );
  }

  List<String> get mainPositions => _subPositionMap.keys.toList();

  static final _subPositionMap = {
    'Goalkeeper': ['Goalkeeper'],
    'Defender': [
      'Centre-Back (CB)',
      'Right-Back (RB)',
      'Left-Back (LB)',
      'Right Wing-back (RWB)',
      'Left Wing-back (LWB)',
    ],
    'Midfielder': [
      'Central Midfielder (CM)',
      'Defender Midfielder (CDM)',
      'Attacking Midfielder (CAM)',
      'Right Midfielder (RM)',
      'Left Midfielder (LM)',
    ],
    'Forward': [
      'Striker (ST)',
      'Central Forward (CF)',
      'Right Forward (RF)',
      'Left Forward (LF)',
      'Right Winger (RW)',
      'Left Winger (LW)',
    ],
  };

  static final _positionStyles = {
    'Goalkeeper': ['Axe', 'Eagle', 'Iron Fist', 'Shot Stopper', 'Soldier', 'Sweeper Keeper'],
    'Defender': ['Hacker', 'No-Bull', 'Shield', 'Terminator', 'Wall', 'Warrior'],
    'Midfielder': ['Gladiator', 'Maestro', 'Magician', 'Power House', 'Road Runner', 'Scientist'],
    'Forward': ['Finisher', 'Poacher', 'Predator', 'Rocket', 'Ruthless', 'Sniper'],
  };

  static final _footOptions = {
    'Goalkeeper': ['Left', 'Right'],
    'Defender': ['Left', 'Right'],
    'Midfielder': ['Left', 'Right'],
    'Forward': ['Left', 'Right'],
  };

  List<String> get subPositions =>
      _subPositionMap[state.selectedMain] ?? [];

  List<String> get playingStyles =>
      _positionStyles[state.selectedMain] ?? [];

  List<String> get foot => _footOptions[state.selectedMain] ?? [];

  void updateMainPosition(String newMain) {
    state = PositionState(
      selectedMain: newMain,
      selectedSub: null,
      selectedStyle: null,
      selectedFoot: _footOptions[newMain]?.first ?? 'Right',
    );
  }

  void updateSubPosition(String subPosition) {
    state = state.copyWith(selectedSub: subPosition);
  }

  void updateStyle(String style) {
    if (playingStyles.contains(style)) {
      state = state.copyWith(selectedStyle: style);
    }
  }

  void updateFoot(String foot) {
    if (this.foot.contains(foot)) {
      state = state.copyWith(selectedFoot: foot);
    }
  }
}

final positionProvider = NotifierProvider<PositionNotifier, PositionState>(
  () => PositionNotifier(),
);
