// import 'package:flutter/material.dart';

// class AuthProvider with ChangeNotifier {
//   bool _isLogin = true;

//   bool get isLogin => _isLogin;

//   void toggleAuthMode(bool isLogin) {
//     _isLogin = isLogin;
//     notifyListeners();
//   }

// //================================== Gender selection ================================
//  String? _selectedGender = 'Male';

//   String? get selectedGender => _selectedGender;

//   void selectGender(String gender) {
//     _selectedGender = gender;
//     notifyListeners();
//   }

// }


import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLogin;
  final String? selectedGender;

  AuthState({required this.isLogin, this.selectedGender});

  AuthState copyWith({bool? isLogin, String? selectedGender}) {
    return AuthState(
      isLogin: isLogin ?? this.isLogin,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState(isLogin: true, selectedGender: 'Male');

  void toggleAuthMode(bool isLogin) {
    state = state.copyWith(isLogin: isLogin);
  }

  void selectGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
