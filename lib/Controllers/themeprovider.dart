
// import '../Utils/packages.dart';

// class ThemeProvider extends ChangeNotifier {
//   ColorScheme _currentColorScheme = kColorScheme;
//   bool _isDarkTheme = false;

//   ColorScheme get currentColorScheme => _currentColorScheme;
//   bool get isDarkTheme => _isDarkTheme;

//   ThemeProvider() {
//     _loadThemePreference();
//   }

//   Future<void> _loadThemePreference() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
//     _updateColorScheme();
//   }

//   void _updateColorScheme() {
//     _currentColorScheme = _isDarkTheme ? kDarkColorScheme : kColorScheme;
//     notifyListeners();
//   }

//   void toggleTheme() async {
//     _isDarkTheme = !_isDarkTheme;
//     await _saveThemePreference();
//     _updateColorScheme();
//   }

//   Future<void> _saveThemePreference() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isDarkTheme', _isDarkTheme);
//   }
// }




import '../Utils/packages.dart';

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    final isDark = false;
    _loadThemePreference();
    return ThemeState(
      isDarkTheme: isDark,
      currentColorScheme: kColorScheme,
    );
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? false;
    state = state.copyWith(
      isDarkTheme: isDark,
      currentColorScheme: isDark ? kDarkColorScheme : kColorScheme,
    );
  }

  void toggleTheme() async {
    final newIsDark = !state.isDarkTheme;
    final newScheme = newIsDark ? kDarkColorScheme : kColorScheme;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', newIsDark);

    state = state.copyWith(
      isDarkTheme: newIsDark,
      currentColorScheme: newScheme,
    );
  }
}

class ThemeState {
  final bool isDarkTheme;
  final ColorScheme currentColorScheme;

  ThemeState({
    required this.isDarkTheme,
    required this.currentColorScheme,
  });

  ThemeState copyWith({
    bool? isDarkTheme,
    ColorScheme? currentColorScheme,
  }) {
    return ThemeState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      currentColorScheme: currentColorScheme ?? this.currentColorScheme,
    );
  }
}


final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(() => ThemeNotifier());
