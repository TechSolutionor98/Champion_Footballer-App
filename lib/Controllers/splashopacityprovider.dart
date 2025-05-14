// import '../Utils/packages.dart';

// class SplashProvider with ChangeNotifier {
//   double _opacity = 0.0;

//   double get opacity => _opacity;

//   void startFadeIn() {
//     Future.delayed(const Duration(seconds: 2), () {
//       _opacity = 1.0;
//       notifyListeners();
//     });
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashNotifier extends Notifier<double> {
  @override
  double build() {
    _startFadeIn();
    return 0.0;
  }

  void _startFadeIn() {
    Future.delayed(const Duration(seconds: 2), () {
      state = 1.0;
    });
  }
}

final splashOpacityProvider = NotifierProvider<SplashNotifier, double>(
  () => SplashNotifier(),
);
